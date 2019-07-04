# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rebate_forms#create', type: :request do
  subject(:make_request) do
    post '/api/v1/rebate_forms', params: payload
  end

  let(:property) { FactoryBot.create :property_with_rates, rating_year: ENV['YEAR'] }

  describe 'basic create' do
    let(:payload) do
      {
        api: {
          data: {
            type: 'rebate_forms',
            attributes: {
              valuation_id: property.valuation_id,
              council: property.council.name,
              total_rates: property.rates_bills.first.total_rates,
              location: property.location,
              fields: {
                full_name: 'Hermione Granger',
                phone_number: '022123-4567',
                email: 'hermione.granger@hogwarts.com',
                dependants: '0',
                occupation: 'witch',
                "50%_claimed_expenses": 'true',
                moved_within_rating_year: 'false',
                lived_in_property_july_1: 'true',
                income: {
                  total_income: '1234'
                }
              }
            }
          }
        }
      }
    end

    context 'creates the resource' do
      it 'works' do
        expect do
          make_request
        end.to change(RebateForm, :count).by(1)
        rebate_form = RebateForm.last

        assert_payload(:rebate_form, rebate_form, json_item)
      end
    end
  end
end
