# frozen_string_literal: true

FactoryBot.define do
  factory :council do
    name { "#{Faker::Address.city} City Council" }
    short_name { "#{Faker::Types.rb_string}#{Faker::Number.number(100)}" }
    email { Faker::Internet.email }
    active { true }
    has_address_lookups { false }
  end
end
