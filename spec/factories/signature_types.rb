# frozen_string_literal: true

FactoryBot.define do
  factory :signature_type do
    name { Faker::Lorem.word }
  end
end
