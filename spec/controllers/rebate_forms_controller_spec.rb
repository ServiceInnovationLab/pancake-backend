# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateFormsController, type: :controller do
  subject { JSON.parse response.body }

  let(:fields) { { 'dependants' => '0', 'full_name' => 'bob', 'income' => '10000' } }
  let(:property) { FactoryBot.create :property_with_rates, rating_year: ENV['YEAR'] }

  pending '#create' do
    # these will have to be seriously refactored during RR-257
    let(:body) do
      {
        "data": {
          "attributes": {
            "valuation_id": '12345',
            "council": 'Wellington City Council',
            "total_rates": '12345',
            "location": 'This is the address',
            "fields": {
              "full_name": 'Herminone Granger',
              "customer_id": '12345',
              "phone": '022123-4567',
              "email": 'hermione.granger@hogwarts.com',
              "partner": 'string string string',
              "dependants": '0',
              "occupation": 'witch',
              "50_percent_claimed": 'true',
              "moved_within_rating_year": 'false',
              "lived_in_property_july_1": 'true',
              "details_of_previous_property": 'string string string',
              "income": {
                "total_income": '1234'
              }
            }
          }
        }
      }
    end

    before { post :create, format: :json, params: { api: body } }

    it { expect(subject['data']['attributes']['fields']).to eq fields }
    it { expect(RebateForm.first.fields).to eq fields }
    it 'calculates their rebate' do
      expect(RebateForm.first.rebate).to eq 630.0
    end
  end

  pending '#update'

  describe '#show' do
    let(:rebate_form) { FactoryBot.create :rebate_form }

    before { get :show, format: :json, params: { id: rebate_form.token } }

    it { expect(subject['data']['attributes']['fields']).to eq rebate_form.fields }
    it { expect(subject['data']['attributes']['token']).to eq rebate_form.token }
  end
end
