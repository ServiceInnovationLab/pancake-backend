# frozen_string_literal: true

FactoryBot.define do
  factory :property do
    valuation_id { Faker::Vehicle.vin }
    location { '999 Lambton quay' }
    suburb { 'coolville' }
    town_city { 'Tauranga' }
    council
    rating_year { Rails.configuration.rating_year }
  end
  factory :property_with_rates, parent: :property do
    after(:create) do |property|
      # create :rates_payer, property: property, rating_year: property.rating_year
      create :rates_bill, property: property,
                          total_rates: 100,
                          total_water_rates: 10,
                          rating_year: property.rating_year
    end
  end
end
