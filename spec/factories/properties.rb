# frozen_string_literal: true

FactoryBot.define do
  factory :property do
    valuation_id { Faker::Alphanumeric.alphanumeric 10 }
    location { Faker::Address.street_address }
    suburb { Faker::Address.community }
    town_city { Faker::Address.city }
    council
    rating_year { Rails.configuration.rating_year }
  end

  factory :property_with_rates, parent: :property do
    after(:create) do |property|
      create :rates_bill, property: property,
                          total_rates: 100,
                          total_water_rates: 10,
                          rating_year: property.rating_year
    end
  end
end
