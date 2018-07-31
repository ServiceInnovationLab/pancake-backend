# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'properties#index', type: :request do
  let(:year) { '2018' }
  before { ENV['YEAR'] = year }

  subject(:make_request) do
    jsonapi_get '/api/v1/properties',
                params: params
  end

  let(:params) { { q: 'main' } }

  describe 'basic fetch' do
    let!(:matching_property) { create(:property, location: '1 main street', rating_year: year) }
    let!(:unrelated_property) { create(:property, location: '22 tawa road', rating_year: year) }

    it 'serializes the list correctly' do
      make_request
      assert_payload(:property, matching_property, json_items[0])
      expect(json_items.first['id']).to eq matching_property.valuation_id
      expect(json_items.size).to eq 1
    end
  end
end
