# frozen_string_literal: true

class RatesBill < ApplicationRecord
  belongs_to :property, required: true
  delegate :council, to: :property
  validates :total_rates, presence: true
  validates :total_water_rates, presence: true

  scope :by_council, ->(council) { joins(:property).where(properties: { council_id: council.id }) }
  scope :by_rating_year, ->(rating_year) { joins(:property).where(properties: { rating_year: rating_year }) }

  def total_bill
    format('%.2f', (total_rates.to_f + total_water_rates.to_f))
  end
end
