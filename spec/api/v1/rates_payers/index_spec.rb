# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rates_payers#index', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get '/api/v1/rates_payers',
                params: params
  end

  describe 'basic fetch' do
    let!(:rates_payer1) { create(:rates_payer) }
    let!(:rates_payer2) { create(:rates_payer) }

    it 'serializes the list correctly' do
      make_request
      expect(json_ids(true)).to match_array([rates_payer1.id, rates_payer2.id])
      assert_payload(:rates_payer, rates_payer1, json_items[0])
      assert_payload(:rates_payer, rates_payer2, json_items[1])
    end
  end
end
