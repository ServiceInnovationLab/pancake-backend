# frozen_string_literal: true

FactoryBot.define do
  factory :rates_bill do
    property
    total_rates { 100 }
    total_water_rates { 10 }
    rating_year { 2018 }
  end
end
