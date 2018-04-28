# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rates_bills#destroy', type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/v1/rates_bills/#{rates_bill.id}"
  end

  describe 'basic destroy' do
    let!(:rates_bill) { create(:rates_bill) }

    it 'updates the resource' do
      expect do
        make_request
      end.to change { RatesBill.count }.by(-1)

      expect(response.status).to eq(200)
      expect(json).to eq('meta' => {})
    end
  end
end
