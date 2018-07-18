# frozen_string_literal: true

class Council < ApplicationRecord
  validates :name, uniqueness: true
  has_many :properties, dependent: :destroy
  has_many :rate_payers, through: :properties
  has_many :rates_bills, through: :properties
  has_many :rebate_forms, through: :properties
end
