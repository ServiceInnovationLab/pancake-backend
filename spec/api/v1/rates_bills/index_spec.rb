# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rates_bills#index', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get '/api/v1/rates_bills',
                params: params
  end

  describe 'basic fetch' do
    let!(:rates_bill1) { create(:rates_bill) }
    let!(:rates_bill2) { create(:rates_bill) }

    it 'serializes the list correctly' do
      make_request
      expect(json_ids(true)).to match_array([rates_bill1.id, rates_bill2.id])
      assert_payload(:rates_bill, rates_bill1, json_items[0])
      assert_payload(:rates_bill, rates_bill2, json_items[1])
    end
  end
end
