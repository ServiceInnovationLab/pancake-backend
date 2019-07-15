# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:owner] do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    after(:create) do |user, _evaluator|
      user.confirm
    end
  end
  factory :council_user, parent: :user do
    roles { [Role.find_or_create_by(name: 'rates', friendly_name: 'very cool')] }
    council { FactoryBot.create :council }
  end
  factory :admin_user, parent: :user do
    roles { [Role.find_or_create_by(name: 'dia', friendly_name: 'Te Tari Taiwhenua')] }
  end
  factory :admin_user_with_name, parent: :user do
    name { Faker::Name.name }
    roles { [Role.find_or_create_by(name: 'dia', friendly_name: 'Te Tari Taiwhenua')] }
  end
end
