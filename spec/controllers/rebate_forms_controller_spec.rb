# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateFormsController, type: :controller do
  subject { JSON.parse response.body }

  before { ENV['YEAR'] = '2018' }

  let(:fields) { { 'dependants' => '0', 'full_name' => 'bob', 'income' => '10000' } }
  let(:property) { FactoryBot.create :property_with_rates }

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

    before { post :create, format: :json, params: { api: body } }

    it { expect(subject['data']['attributes']['fields']).to eq fields }
    it { expect(RebateForm.first.fields).to eq fields }
    it 'calculates their rebate' do
      expect(RebateForm.first.rebate).to eq 620.0
    end
  end

  pending '#update'

  describe '#show' do
    let(:property) { FactoryBot.create :property }
    let(:rebate_form) { FactoryBot.create :rebate_form, valuation_id: property.valuation_id }

    before { get :show, format: :json, params: { id: rebate_form.token } }

    it { expect(subject['data']['attributes']['fields']).to eq rebate_form.fields }
    it { expect(subject['data']['attributes']['token']).to eq rebate_form.token }
  end
end
