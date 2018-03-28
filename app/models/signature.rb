# frozen_string_literal: true

class Signature < ApplicationRecord
  belongs_to :rebate_form
  belongs_to :signature_type

  scope :applicant, -> { joins(:signature_type).where("signature_types.name": 'applicant') }
  scope :witness, -> { joins(:signature_type).where("signature_types.name": 'witness') }
end
