# frozen_string_literal: true

class Signature < ApplicationRecord
  belongs_to :rebate_form
  belongs_to :signature_type
  validates :signature_type, presence: true

  scope :applicant, -> { joins(:signature_type).where("signature_types.name": 'applicant') }
  scope :witness, -> { joins(:signature_type).where("signature_types.name": 'witness') }

  after_save :update_form_completed
  after_destroy :update_form_completed

  def update_form_completed
    rebate_form.completed = (rebate_form.applicant_signature.present? && rebate_form.witness_signature.present?)
    rebate_form.save
  end
end
