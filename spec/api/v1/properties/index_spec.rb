# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'properties#index', type: :request do
  subject(:make_request) do
    jsonapi_get '/api/v1/properties',
                params: params
  end

  let(:year) { ENV['YEAR'] }
  let(:params) { { q: 'main', council_id: council.id } }
  let(:council) { FactoryBot.create :council }

  describe 'basic fetch' do
    let!(:matching_property) { create(:property, location: '1 main street', council: council, rating_year: year) }
    let!(:matching_property_wrong_year) { create(:property, location: '1 main street', council: council, rating_year: '1840') }
    let!(:unrelated_property) { create(:property, location: '22 tawa road', council: council, rating_year: year) }

    before { make_request }
    it 'serializes the list correctly' do
      assert_payload(:property, matching_property, json_items[0])
    end
    it { expect(json_items.first['id']).to eq matching_property.valuation_id }
    it { expect(json_items.size).to eq 1 }
  end
end
