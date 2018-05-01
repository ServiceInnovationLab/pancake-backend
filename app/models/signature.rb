# frozen_string_literal: true

class Signature < ApplicationRecord
  belongs_to :rebate_form
  belongs_to :signature_type

  validates :signature_type, presence: true
  # validates :image, presence: true
  # validates :name, presence: true

  scope :applicant, -> { joins(:signature_type).where("signature_types.name": 'applicant') }
  scope :witness, -> { joins(:signature_type).where("signature_types.name": 'witness') }
end
