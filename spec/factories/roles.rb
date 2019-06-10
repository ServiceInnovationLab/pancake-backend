# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name { 'rates' }
    friendly_name { 'very cool' }
  end
  factory :dia_role, parent: :role do
    name { 'dia' }
    friendly_name { 'Te Tari Taiwhenua' }
  end
end
