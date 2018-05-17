# frozen_string_literal: true

FactoryBot.define do
  factory :rebate_form do
    valuation_id '123'
    property { FactoryBot.create :property }
    # token <-- auto generated. Don't set in factory
    fields("full_name": 'Fred', "income": 0, dependants: 0)
  end

  factory :signed_form, parent: :rebate_form do
    after(:create) do |rebate_form|
      create_list(:signature, 2, rebate_form: rebate_form)
    end
  end
end
