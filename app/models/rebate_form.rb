# frozen_string_literal: true

class RebateForm < ApplicationRecord
  has_many :signatures, dependent: :destroy

  def applicant_signature
    signatures.applicant.first
  end

  def witness_signature
    signatures.witness.first
  end
end
