# frozen_string_literal: true

class RebateForm < ApplicationRecord
  has_many :signatures, dependent: :destroy
  belongs_to :property, optional: false
  belongs_to :batch, optional: true

  delegate :council, to: :property
  delegate :rating_year, to: :property

  after_initialize :set_token
  before_validation :set_property_id

  validates :token, presence: true
  validates :property, presence: true

  validate :same_council

  after_create :send_email
  has_many_attached :attachments

  scope :by_council, ->(council) { where(properties: { council_id: council.id }) }

  NOT_SIGNED_STATUS = 'not signed'
  SIGNED_STATUS = 'signed'
  PROCESSED_STATUS = 'processed'
  BATCHED_STATUS = 'batched'

  def self.to_csv
    attributes = %w[valuation_id created_at updated_at fields status customer_id application_id location total_rates]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |rebate_form|
        csv << attributes.map { |attr| rebate_form.send(attr) }
      end
    end
  end

  def signed_state?
    status == SIGNED_STATUS
  end

  def not_signed_state?
    status == NOT_SIGNED_STATUS
  end

  def processed_state?
    status == PROCESSED_STATUS
  end

  def batched_state?
    (status == BATCHED_STATUS) && batch_id.positive?
  end

  def transition_to_signed_state
    update!(status: SIGNED_STATUS)
  end

  def transition_to_not_signed_state
    update!(status: NOT_SIGNED_STATUS)
  end

  def transition_to_processed_state
    update!(status: PROCESSED_STATUS)
  end

  def transition_to_batched_state(batch)
    update!(status: BATCHED_STATUS, batch: batch)
  end

  def full_name
    fields['full_name']
  end

  def occupation
    fields['occupation']
  end

  def email
    fields['email']
  end

  def dependants
    fields['dependants']
  end

  def income
    fields['income']['total_income']
  end

  def lived_here
    fields.each do |key, value|
      return value if key.start_with?('lived_in_property_')
    end
    nil
  end

  def applicant_signature
    signatures.applicant.first
  end

  def witness_signature
    signatures.witness.first
  end

  def set_token
    self.token = new_token unless token
  end

  private

  def set_property_id
    return if property_id.present?

    self.property = Property.find_by(valuation_id: valuation_id, rating_year: Rails.configuration.rating_year)
  end

  def new_token
    SecureRandom.hex(rand(40..60))
  end

  def send_email
    RebateFormsMailer.applicant_mail(self).deliver_now if fields['email'].present?
  end

  def same_council
    errors.add(:batch_id, 'council must match') if batch.present? && property.council_id != batch.council_id
  end
end
