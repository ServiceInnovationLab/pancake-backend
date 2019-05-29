# frozen_string_literal: true

FactoryBot.define do
  factory :rebate_form do
    valuation_id { Faker::Vehicle.vin }
    property { Property.find_by(valuation_id: valuation_id, rating_year: ENV['YEAR']) }
    # token <-- auto generated. Don't set in factory
    fields do
      { full_name: Faker::Name.name,
        dependants: 0,
        customer_id: 123,
        phone: '0212345678',
        income: {},
        email: 'hermione.granger@hogwarts.com',
        has_partner: true,
        occupation: 'witch',
        fifty_percent_claimed: true,
        moved_within_rating_year: false,
        lived_in_property_july_1: true,
        details_of_previous_property: '123 Muggle Lane, Hogsmead, England' }
    end
    status { RebateForm::NOT_SIGNED_STATUS }
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
      rebate_form.transition_to_signed_state
    end
  end

  factory :processed_form, parent: :signed_form do
    after(:create) do |rebate_form|
      rebate_form.transition_to_processed_state
    end
  end
end
