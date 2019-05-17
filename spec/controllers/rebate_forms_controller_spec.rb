# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateFormsController, type: :controller do
  subject { JSON.parse response.body }

  let(:fields) { { 'dependants' => '0', 'full_name' => 'bob', 'income' => '10000' } }
  let(:property) { FactoryBot.create :property_with_rates, rating_year: ENV['YEAR'] }

  before do
    payload = {
      rebate_form_id: rebate_form.id,
      exp: Time.now.to_i + (1000 * 60),
      per: 'fetch_application_and_submit_signatures'
    }

    @token = JWT.encode payload, ENV['HMAC_SECRET'], 'HS256'
  end

  pending '#create' do
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

    before { post :create, format: :json, params: { api: body } }

    it { expect(subject['data']['attributes']['fields']).to eq fields }
    it { expect(RebateForm.first.fields).to eq fields }
    it 'calculates their rebate' do
      expect(RebateForm.first.rebate).to eq 630.0
    end
  end

  describe '#show_by_jwt' do
    let(:rebate_form) { FactoryBot.create :rebate_form }

    before { get :show_by_jwt, format: :json, params: { jwt: @token } }

    it { expect(subject['data']['attributes']['fields']).to eq rebate_form.fields }
    it { expect(subject['data']['attributes']['token']).to eq rebate_form.token }
  end
end
