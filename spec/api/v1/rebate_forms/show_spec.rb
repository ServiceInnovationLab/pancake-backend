# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rebate_forms#show', type: :request do
  let(:params) { {} }

  let!(:rebate_form) { FactoryBot.create(:rebate_form) }

  describe 'fetch by token' do
    subject(:make_request) do
      jsonapi_get "/api/v1/rebate_forms/#{rebate_form.token}",
                  params: params
    end

    it 'retrieves form by token' do
      make_request
      assert_payload(:rebate_form, rebate_form, json_item)
    end

    it 'does not alter token on fetch' do
      token = rebate_form.token
      make_request
      expect(rebate_form.token).to eq token
      make_request
      expect(rebate_form.token).to eq token
    end
  end

  describe 'fetch by id' do
    subject(:make_request) do
      jsonapi_get "/api/v1/rebate_forms/#{rebate_form.id}",
                  params: params
    end

    it 'does not retrieve form by id' do
      expect do
        make_request
      end.to raise_error(JsonapiCompliable::Errors::RecordNotFound)
    end
  end
end
