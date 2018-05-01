# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'properties#index', type: :request do
  subject(:make_request) do
    jsonapi_get '/api/v1/properties',
                params: params
  end
  let(:params) { { q: 'main' } }

  describe 'basic fetch' do
    let!(:matching_property) { create(:property, location: '1 main street') }
    let!(:unrelated_property) { create(:property, location: '22 tawa road') }

    it 'serializes the list correctly' do
      make_request
      assert_payload(:property, matching_property, json_items[0])
      expect(json_items.first['id']).to eq matching_property.valuation_id
      expect(json_items.size).to eq 1
    end
  end
end
