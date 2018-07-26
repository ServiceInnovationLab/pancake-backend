# frozen_string_literal: true

class Council < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :short_name, uniqueness: true, presence: true
  # validates :active, presence: true
  has_many :properties, dependent: :destroy
  has_many :rates_payers, through: :properties
  has_many :rates_bills, through: :properties
  has_many :rebate_forms, through: :properties

  has_many :batches
  has_many :users
end
