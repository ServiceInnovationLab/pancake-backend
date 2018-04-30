# frozen_string_literal: true

FactoryBot.define do
  factory :property do
    valuation_id { Faker::Vehicle.vin }
    location '999 Lambton quay'
    suburb 'coolville'
    town_city 'Tauranga'
  end
end
