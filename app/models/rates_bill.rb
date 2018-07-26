# frozen_string_literal: true

class RatesBill < ApplicationRecord
  belongs_to :property, required: true
  delegate :council, to: :property

  validates :rating_year, presence: true
  validates :total_rates, presence: true
  validates :total_water_rates, presence: true

  def total_bill
    format('%.2f', (total_rates.to_f + total_water_rates.to_f))
  end
end
