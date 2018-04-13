# frozen_string_literal: true

class RebateForm < ApplicationRecord
  has_many :signatures, dependent: :destroy
  after_initialize :set_token
  validates :valuation_id, presence: true
  validates :token, presence: true

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
    bits = []
    5.times do
      bits << (0...3).map { rand(65..90).chr }.join
    end
    bits.join('-')
  end
end
