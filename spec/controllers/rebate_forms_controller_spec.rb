# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateFormsController, type: :controller do
  subject { JSON.parse response.body }

  let(:property) { FactoryBot.create :property_with_rates, rating_year: ENV['YEAR'] }
  let(:witness) { FactoryBot.create :user }

  describe '#create' do
    let(:body) do
      {
        "data": {
          "attributes": {
            "valuation_id": property.valuation_id,
            "council": property.council.name,
            "total_rates": property.rates_bills.first.total_rates,
            "location": property.location,
            "fields": {
              "full_name": 'Hermione Granger',
              "phone_number": '022123-4567',
              "email": 'hermione.granger@hogwarts.com',
              "dependants": '0',
              "occupation": 'witch',
              "50_percent_claimed": 'true',
              "moved_within_rating_year": 'false',
              "lived_in_property_july_1": 'true',
              "income": {
                "total_income": '1234'
              }
            }
          }
        }
      }
    end

    context 'creates one application form' do
      it { expect { post :create, format: :json, params: { api: body } }.to change { RebateForm.count }.by(1) }
    end

    context 'data format' do
      before { post :create, format: :json, params: { api: body } }
      it { expect(subject['data']['attributes']['fields']).to eq(RebateForm.last.fields) }
      it { expect(response).to have_http_status(:success) }
    end
  end

  describe '#show_by_jwt' do
    let!(:rebate_form) { FactoryBot.create(:rebate_form, property: property) }

    context 'with a valid token' do
      let(:token) { JwtService.new.encode_for_rebate_form_signing(rebate_form.id, witness: witness) }

      before { get :show_by_jwt, format: :json, params: { jwt: token } }

      it { expect(subject['data']['attributes']['fields']).to eq rebate_form.fields }
      it { expect(subject['data']['attributes']['token']).to eq rebate_form.token }
      it { expect(response).to have_http_status(:success) }
    end

    context 'with expired token' do
      let(:payload) do
        {
          rebate_form_id: rebate_form.id,
          exp: Time.now.to_i - (1000 * 60),
          per: 'sign'
        }
      end
      let(:token) { JwtService.new.encode(payload, witness: nil) }
      it { expect { get :show_by_jwt, format: :json, params: { jwt: token } }.to raise_error JWT::DecodeError }
    end

    context 'with no token' do
      let(:token) { '' }
      it { expect { get :show_by_jwt, format: :json, params: { jwt: token } }.to raise_error JWT::DecodeError }
    end

    context 'with bogus token' do
      let(:token) { 'hello' }
      it { expect { get :show_by_jwt, format: :json, params: { jwt: token } }.to raise_error JWT::DecodeError }
    end
  end
end
