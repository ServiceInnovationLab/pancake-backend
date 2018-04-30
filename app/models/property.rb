# frozen_string_literal: true

class Property < ApplicationRecord
  validates :valuation_id, uniqueness: true
  has_many :rates_bills, dependent: :destroy
  has_many :rates_payers, dependent: :destroy
end
