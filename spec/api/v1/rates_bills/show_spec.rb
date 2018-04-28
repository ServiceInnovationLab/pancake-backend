# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rates_bills#show', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/v1/rates_bills/#{rates_bill.id}",
                params: params
  end

  describe 'basic fetch' do
    let!(:rates_bill) { create(:rates_bill) }

    it 'serializes the resource correctly' do
      make_request
      assert_payload(:rates_bill, rates_bill, json_item)
    end
  end
end
