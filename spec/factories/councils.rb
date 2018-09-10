# frozen_string_literal: true

FactoryBot.define do
  factory :council do
    name { "#{Faker::Address.city} City Council" }
    short_name { Faker::Types.rb_string }
    email { Faker::Internet.email }
    active { true }
  end
end
