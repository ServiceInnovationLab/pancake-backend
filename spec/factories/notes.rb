# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    user
    body
  end
end
