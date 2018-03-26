# frozen_string_literal: true

class SignatureType < ApplicationRecord
  scope :applicant, -> { where(name: 'applicant') }
  scope :witness, -> { where(name: 'witness') }
end
