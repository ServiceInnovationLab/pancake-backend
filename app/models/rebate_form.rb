# frozen_string_literal: true

class RebateForm < ApplicationRecord
  has_many :signatures, dependent: :destroy
  belongs_to :property, required: false

  after_initialize :set_token
  validates :valuation_id, presence: true
  validates :token, presence: true
  before_save :set_property_id
  validate :required_fields_present

  after_create :send_emails

  def fully_signed?
    applicant_signature.present? && witness_signature.present?
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
    self.property = Property.find_by(valuation_id: valuation_id)
  end

  def new_token
    SecureRandom.hex(rand(40..60))
  end

  def send_emails
    mailer.applicant_mail.deliver_later
    mailer.council_mail.deliver_later
  end

  def mailer
    RebateFormsMailer.with(rebate_form: self)
  end

  def required_fields_present
    errors.add(:fields, "must include income") unless fields["income"].present?
    errors.add(:fields, "must include dependants") unless fields["dependants"].present?
    errors.add(:fields, "must include full_name") unless fields["full_name"].present?
  end
end
