# frozen_string_literal: true

FactoryBot.define do
  factory :signature_type do
    name { Faker::DrWho.specie }
  end
end
