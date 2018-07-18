# frozen_string_literal: true

FactoryBot.define do
  factory :council do
    name { "#{Faker::Address.city} City Council" }
    active true
  end
end
