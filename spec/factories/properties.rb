# frozen_string_literal: true

FactoryBot.define do
  factory :property do
    valuation_id { Faker::Vehicle.vin }
    location '999 Lambton quay'
    suburb 'coolville'
    town_city 'Tauranga'
    council
  end
  factory :property_with_rates, parent: :property do
    after(:create) do |property|
      year = 2018
      create :rates_payer, property: property, rating_year: year
      create :rates_bill, property: property,
                          total_rates: 100,
                          total_water_rates: 10,
                          rating_year: year
    end
  end
end
