# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rates_payers#destroy', type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/v1/rates_payers/#{rates_payer.id}"
  end

  describe 'basic destroy' do
    let!(:rates_payer) { create(:rates_payer) }

    it 'updates the resource' do
      expect do
        make_request
      end.to change { RatesPayer.count }.by(-1)

      expect(response.status).to eq(200)
      expect(json).to eq('meta' => {})
    end
  end
end
