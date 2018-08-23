# frozen_string_literal: true

FactoryBot.define do
  factory :council do
    name { "#{Faker::Address.city} City Council" }
    short_name { Faker::Address.city }
    active { true }
  end
end
