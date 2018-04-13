# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateFormsController, type: :controller do
  subject { JSON.parse response.body }
  describe '#create' do
    let(:body) do
      {
        data: {
          type: 'rebate-forms',
          attributes: {
            valuation_id: 'abc',
            fields: fields
          }
        }
      }
    end
    let(:fields) { { 'name' => 'bob', 'relationship' => 'married' } }
    before { post :create, format: :json, params: { api: body } }
    it { expect(subject['data']['attributes']['fields']).to eq fields }
    it { expect(RebateForm.first.fields).to eq fields }
  end

  describe '#update' do
    let(:body) do
      {
        data: {
          type: 'rebate-forms',
          token: rebate_form.token,
          attributes: {
            valuation_id: 'abc',
            fields: fields
          }
        }
      }
    end
    let(:rebate_form) { FactoryBot.create :rebate_form }
    let(:fields) { { 'name' => 'bob', 'relationship' => 'married' } }
    before { patch :update, format: :json, params: { id: rebate_form.token, api: body } }
    it { expect(subject['data']['attributes']['fields']).to eq fields }
    it { expect(RebateForm.find(rebate_form.id).fields).to eq fields }
  end

  describe '#show' do
    let(:rebate_form) { FactoryBot.create :rebate_form }
    before { get :show, format: :json, params: { id: rebate_form.token } }
    it { expect(subject['data']['attributes']['fields']).to eq rebate_form.fields }
    it { expect(subject['data']['attributes']['token']).to eq rebate_form.token }
  end
end
