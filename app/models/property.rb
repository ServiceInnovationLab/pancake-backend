# frozen_string_literal: true

class Property < ApplicationRecord
  has_many :rates_bills, dependent: :destroy
  has_many :rates_payers, dependent: :destroy
  has_many :rebate_forms, dependent: :destroy
  belongs_to :council, required: true
end
