# frozen_string_literal: true

FactoryBot.define do
  factory :rebate_form do
    valuation_id { Faker::Vehicle.vin }
    property { Property.find_by(valuation_id: valuation_id, rating_year: ENV['YEAR']) }
    # token <-- auto generated. Don't set in factory
    fields { { "full_name": 'Fred', "income": 0, dependants: 0 } }
    completed { false }
    rebate { 555.12 }
    batch { nil }

    before(:create) do |rebate_form|
      unless Property.find_by(valuation_id: rebate_form.valuation_id, rating_year: ENV['YEAR'])
        FactoryBot.create(:property_with_rates,
                          rating_year: ENV['YEAR'],
                          valuation_id: rebate_form.valuation_id)
      end
    end
  end

  factory :signed_form, parent: :rebate_form do
    after(:create) do |rebate_form|
      create(:applicant_signature, rebate_form: rebate_form)
      create(:witness_signature, rebate_form: rebate_form)
    end
  end
end
