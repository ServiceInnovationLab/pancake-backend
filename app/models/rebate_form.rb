# frozen_string_literal: true

class RebateForm < ApplicationRecord
  has_many :signatures, dependent: :destroy
  belongs_to :property, required: true
  belongs_to :batch, required: false

  delegate :council, to: :property
  delegate :rating_year, to: :property

  after_initialize :set_token
  before_validation :set_property_id

  validates :token, presence: true
  validates :rebate, presence: true
  validates :property, presence: true

  validate :same_council
  validate :only_completed_forms_in_batch

  after_create :send_email
  has_many_attached :attachments

  scope :by_council, ->(council) { where(properties: { council_id: council.id }) }

  def calc_rebate_amount!
    rates_bill = property.rates_bills.find_by(rating_year: rating_year)
    raise "No rates bill found for rating_year #{year}" if rates_bill.blank?

    rebate = OpenFiscaService.rebate_amount(
      income: income, rates: rates_bill.total_bill,
      dependants: dependants, year: rating_year
    )
    update!(rebate: rebate)
  rescue StandardError => e
    errors.add(:address, e)
    errors.add(:address, 'Application invalid')
  end

  def full_name
    fields['full_name']
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
      return value if key.start_with?('lived_here_before_july_')
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

  def signing_url
    ENV['SIGNING_URL'].sub('{token}', token)
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

  def only_completed_forms_in_batch
    errors.add(:batch_id, 'uncompleted forms cannot be in a batch') if batch_id.present? && !completed
  end
end
