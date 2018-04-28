# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rates_payers#show', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/v1/rates_payers/#{rates_payer.id}",
                params: params
  end

  describe 'basic fetch' do
    let!(:rates_payer) { create(:rates_payer) }

    it 'serializes the resource correctly' do
      make_request
      assert_payload(:rates_payer, rates_payer, json_item)
    end
  end
end
