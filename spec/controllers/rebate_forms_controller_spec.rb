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
    let(:rebate_form) { FactoryBot.create :rebate_form }
    let(:fields) { { 'name' => 'bob', 'relationship' => 'married' } }

    describe 'good' do
      let(:body) do
        {
          data: {
            type: 'rebate-forms',
            id: rebate_form.token,
            attributes: {
              valuation_id: 'abc',
              fields: fields
            }
          }
        }
      end

      before { patch :update, format: :json, params: { id: rebate_form.token, api: body } }
      it { expect(subject['data']['attributes']['fields']).to eq fields }
      it { expect(RebateForm.find(rebate_form.id).fields).to eq fields }
    end

    describe 'bad' do
      let(:body) do
        {
          data: {
            type: 'rebate-forms',
            id: rebate_form.token,
            attributes: {
              valuation_id: '',
              fields: fields
            }
          }
        }
      end
      let(:expected_errors) do
        { 'errors' => [
          {
            'code' => 'unprocessable_entity',
            'status' => '422',
            'title' => 'Validation Error',
            'detail' => "Valuation can't be blank",
            'source' => { 'pointer' => '/data/attributes/valuation_id' },
            'meta' => { 'attribute' => 'valuation_id', 'message' => "can't be blank", 'code' => 'blank' }
          }
        ] }
      end

      before { patch :update, format: :json, params: { id: rebate_form.token, api: body } }
      it { expect(subject).to eq expected_errors }
    end
  end

  describe '#show' do
    let(:rebate_form) { FactoryBot.create :rebate_form }

    before { get :show, format: :json, params: { id: rebate_form.token } }
    it { expect(subject['data']['attributes']['fields']).to eq rebate_form.fields }
    it { expect(subject['data']['attributes']['token']).to eq rebate_form.token }
  end
end
