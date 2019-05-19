# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateFormsController, type: :controller do
  subject { JSON.parse response.body }

  let(:rebate_form) { FactoryBot.create :rebate_form }
  let(:fields) { { 'dependants' => '0', 'full_name' => 'bob', 'income' => '10000' } }
  let(:property) { FactoryBot.create :property_with_rates, rating_year: ENV['YEAR'] }

  describe '#create' do
    let(:body) do
      {
        data: {
          type: 'rebate-forms',
          attributes: {
            valuation_id: property.valuation_id,
            fields: fields
          }
        }
      }
    end

    describe 'creates one application form' do
      it { expect { post :create, format: :json, params: { api: body } }.to change { RebateForm.all.size }.by(1) }
    end

    describe 'data format' do
      before { post :create, format: :json, params: { api: body } }
      it { expect(subject['data']['attributes']['fields']).to eq(RebateForm.last.fields) }
      it { expect(RebateForm.last.fields).to eq fields }
      it { expect(response).to have_http_status(:success) }
    end
  end

  describe '#show_by_jwt' do
    describe 'with a valid token' do
      before { get :show_by_jwt, format: :json, params: { jwt: token } }
      let(:payload) do
        {
          rebate_form_id: rebate_form.id,
          exp: Time.now.to_i + (1000 * 60),
          per: 'fetch_application_and_submit_signatures'
        }
      end

      let(:token) { JWT.encode payload, ENV['HMAC_SECRET'], 'HS256' }

      it { expect(subject['data']['attributes']['fields']).to eq rebate_form.fields }
      it { expect(subject['data']['attributes']['token']).to eq rebate_form.token }
      it { expect(response).to have_http_status(:success) }
    end

    describe 'with expired token' do
      let(:payload) do
        {
          rebate_form_id: rebate_form.id,
          exp: Time.now.to_i - (1000 * 60),
          per: 'fetch_application_and_submit_signatures'
        }
      end
      let(:token) { JWT.encode payload, ENV['HMAC_SECRET'], 'HS256' }
      it { expect { get :show_by_jwt, format: :json, params: { jwt: token } }.to raise_error JWT::DecodeError }
    end

    describe 'with no token' do
      let(:token) { '' }
      it { expect { get :show_by_jwt, format: :json, params: { jwt: token } }.to raise_error JWT::DecodeError }
    end

    describe 'with bogus token' do
      let(:token) { 'hello' }
      it { expect { get :show_by_jwt, format: :json, params: { jwt: token } }.to raise_error JWT::DecodeError }
    end
  end
end
