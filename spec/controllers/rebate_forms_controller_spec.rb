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
    let(:rebate_form) { FactoryBot.create(:rebate_form, property: property) }

    before do
      # Rebate form must be created in the past to avoid a stale payload error
      Timecop.freeze(Time.now.utc - 1.day) do
        rebate_form
      end
    end

    context 'with a valid token' do
      let(:token) do
        Timecop.freeze(Time.now.utc - 1.minute) do
          JwtService.new.create_signing_token(rebate_form.id, witness: witness)
        end
      end

      context 'the token is not stale' do
        context 'the form has not been signed' do
          before { get :show_by_jwt, format: :json, params: { jwt: token } }

          it { expect(subject['data']['attributes']['fields']).to eq rebate_form.fields }
          it { expect(subject['data']['attributes']['token']).to eq rebate_form.token }
          it { expect(response).to have_http_status(:success) }
        end

        context 'the form has been signed' do
          before do
            Timecop.freeze(Time.now.utc - 10.minutes) do
              rebate_form.signatures << FactoryBot.create(:applicant_signature)
              rebate_form.signatures << FactoryBot.create(:witness_signature)
            end

            get :show_by_jwt, format: :json, params: { jwt: token }
          end

          it { expect(response).to have_http_status(:unprocessable_entity) }
        end
      end

      context 'the token is stale' do
        before do
          rebate_form.update!(updated_at: Time.now.utc)
          get :show_by_jwt, format: :json, params: { jwt: token }
        end

        it { expect(response).to have_http_status(:conflict) }
      end
    end

    context 'with expired token' do
      let(:token) do
        JwtService.new.create_signing_token(
          rebate_form.id,
          witness: nil,
          expire_at: Time.now.to_i - (ENV['IPAD_JWT_LENGTH'].to_i * 60)
        )
      end

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
