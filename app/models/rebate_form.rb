# frozen_string_literal: true

class RebateForm < ApplicationRecord
  has_many :signatures, dependent: :destroy
  after_initialize :set_token

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

  def new_token
    "#{random_token 3}-#{random_token 3}-#{random_token 3}"
  end

  def random_token(length)
    (0...length).map { rand(65..90).chr }.join
  end
end
