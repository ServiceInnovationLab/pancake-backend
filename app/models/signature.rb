# frozen_string_literal: true

class Signature < ApplicationRecord
  belongs_to :rebate_form
  belongs_to :signature_type
  validates :signature_type, presence: true

  scope :applicant, -> { joins(:signature_type).where("signature_types.name": 'applicant') }
  scope :witness, -> { joins(:signature_type).where("signature_types.name": 'witness') }

  scope :by_council, ->(council) { joins(rebate_form: :property).where(properties: { council_id: council.id }) }
  scope :by_rating_year, ->(rating_year) { joins(rebate_form: :property).where(properties: { rating_year: rating_year }) }

  after_save :update_form_status
  after_destroy :update_form_status
  delegate :council, to: :property

  def update_form_status
    rebate_form.status = if (rebate_form.applicant_signature.present? && rebate_form.witness_signature.present?)
                           RebateForm::SIGNED_STATUS
                         else
                           RebateForm::NOT_SIGNED_STATUS
                         end
    rebate_form.save
  end

  def time_after_application
    created_at - rebate_form.created_at
  end
end
