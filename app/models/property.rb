# frozen_string_literal: true

class Property < ApplicationRecord
  has_many :rates_bills, dependent: :destroy
  has_many :rebate_forms, dependent: :destroy
  belongs_to :council, optional: false
  validates :rating_year, presence: true
end
