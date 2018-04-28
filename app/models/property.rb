# frozen_string_literal: true

class Property < ApplicationRecord
  has_many :rates_bills
  has_many :rates_payers
end
