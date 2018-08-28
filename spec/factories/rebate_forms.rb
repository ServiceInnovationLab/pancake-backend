# frozen_string_literal: true

FactoryBot.define do
  factory :rebate_form do
    valuation_id { Faker::Vehicle.vin }
    property do
      unless Property.find_by(valuation_id: valuation_id)
        FactoryBot.create(:property_with_rates,
                          valuation_id: valuation_id)
      end
    end
    # token <-- auto generated. Don't set in factory
    fields { { "full_name": 'Fred', "income": 0, dependants: 0 } }
    completed { false }
    rebate { 555.12 }
    batch { nil }
  end

  factory :signed_form, parent: :rebate_form do
    after(:create) do |rebate_form|
      create(:applicant_signature, rebate_form: rebate_form)
      create(:witness_signature, rebate_form: rebate_form)
    end
  end
end
