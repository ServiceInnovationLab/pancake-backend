# frozen_string_literal: true

class Property < ApplicationRecord
  validates :valution_id, uniqueness: true
  has_many :rates_bills
  has_many :rates_payers
end
