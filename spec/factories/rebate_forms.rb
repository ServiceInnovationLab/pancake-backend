# frozen_string_literal: true

FactoryBot.define do
  factory :rebate_form do
    customer_id { Faker::Alphanumeric.alphanumeric 10 }
    application_id { Faker::Alphanumeric.alphanumeric 10 }
    property { FactoryBot.create(:property_with_rates, rating_year: ENV['YEAR']) }
    location { property.location }
    valuation_id { property.valuation_id }
    total_rates { property.rates_bills.first.total_rates }
    # token <-- auto generated. Don't set in factory
    fields do
      { full_name: Faker::Name.name,
        dependants: 0,
        customer_id: 123,
        phone_number: '0212345678',
        income: {
          total_income: 224,
          applicant: {
            wages_salary: 74
          },
          otherIncome: {
            applicant: {
              'Selling old toys': 70
            }
          },
          partner: {
            wages_salary: '80'
          }
        },
        email: 'hermione.granger@hogwarts.com',
        spouse_or_partner: true,
        occupation: 'witch',
        fifty_percent_claimed: true,
        moved_within_rating_year: false,
        lived_in_property_july_1: true }
    end
    status { RebateForm::NOT_SIGNED_STATUS }
    rebate { 555.12 }
    batch { nil }

    trait :moved_within_rating_year do
      fields do
        { full_name: Faker::Name.name,
          dependants: 0,
          customer_id: 123,
          phone_number: '0212345678',
          income: {
            total_income: 224,
            applicant: {
              wages_salary: 74
            },
            otherIncome: {
              applicant: {
                'Selling old toys': 70
              }
            },
            partner: {
              wages_salary: '80'
            }
          },
          email: 'hermione.granger@hogwarts.com',
          spouse_or_partner: true,
          occupation: 'witch',
          fifty_percent_claimed: true,
          moved_within_rating_year: true,
          lived_in_property_july_1: false,
          previous_address: '123 Muggle Lane, Hogsmead, England',
          settlement_date: 1.month.ago,
          rates_paid: 1234,
          rates_rebate_received: false }
      end
    end

    trait :income_less_than_5k do
      fields do
        { full_name: Faker::Name.name,
          dependants: 0,
          customer_id: 123,
          phone_number: '0212345678',
          income: {
            total_income: 224,
            applicant: {
              wages_salary: 74
            },
            otherIncome: {
              applicant: {
                'Selling old toys': 70
              }
            },
            partner: {
              wages_salary: '80'
            }
          },
          email: 'hermione.granger@hogwarts.com',
          spouse_or_partner: true,
          occupation: 'witch',
          fifty_percent_claimed: true,
          moved_within_rating_year: false,
          lived_in_property_july_1: true,
          income_less_than_5k: 'We were given a money tree for Witchmas.' }
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
    after(:create, &:transition_to_processed_state)
  end

  factory :batched_form, parent: :processed_form do
    after(:create) do |rebate_form|
      batch = FactoryBot.create(:batch, council: rebate_form.council)
      rebate_form.transition_to_batched_state(batch)
    end
  end
end
