# frozen_string_literal: true

class RebateForm < ApplicationRecord
  has_many :signatures, dependent: :destroy
  belongs_to :property, required: true
  belongs_to :batch, required: false

  delegate :council, to: :property

  after_initialize :set_token
  before_validation :set_property_id

  validates :valuation_id, presence: true
  validates :token, presence: true
  validates :rebate, presence: true

  validate :required_fields_present
  validate :same_council
  validate :only_completed_forms_in_batch

  after_create :send_emails
  has_many_attached :attachments

  def calc_rebate_amount!
    year = ENV['YEAR']
    raise 'No year set' if year.blank?
    raise 'No associated property record' if property.blank?
    raise 'Application year must match property record year' unless year == property.rating_year

    rates_bill = property.rates_bills.find_by(rating_year: year)
    raise 'No rates bill found' if rates_bill.blank?

    rebate = OpenFiscaService.rebate_amount(
      income: income, rates: rates_bill.total_bill,
      dependants: dependants, year: year
    )
    update!(rebate: rebate)
  rescue StandardError => e
    errors.add(:address, e)
    errors.add(:address, 'Application invalid')
  end

  def dependants
    fields['dependants']
  end

  def income
    fields['income']
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
    self.property = Property.find_by(valuation_id: valuation_id, rating_year: ENV['YEAR'])
  end

  def new_token
    SecureRandom.hex(rand(40..60))
  end

  def send_emails
    mailer.applicant_mail.deliver_now if fields['email'].present?
    mailer.council_mail.deliver_now if ENV['COUNCIL_EMAIL'].present?
  end

  def mailer
    RebateFormsMailer.with(rebate_form: self)
  end

  def required_fields_present
    %w[income dependants full_name].each do |field|
      errors.add(:fields, "must include #{field}") if fields[field].blank?
    end
  end

  def same_council
    errors.add(:batch_id, 'council must match') if batch.present? && property.council_id != batch.council_id
  end

  def only_completed_forms_in_batch
    errors.add(:batch_id, 'uncompleted forms cannot be in a batch') if batch_id.present? && !completed
  end
end
