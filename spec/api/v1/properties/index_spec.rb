# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'properties#index', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get '/api/v1/properties',
                params: params
  end

  describe 'basic fetch' do
    let!(:property1) { create(:property) }
    let!(:property2) { create(:property) }

    it 'serializes the list correctly' do
      make_request
      expect(json_ids(true)).to match_array([property1.id, property2.id])
      assert_payload(:property, property1, json_items[0])
      assert_payload(:property, property2, json_items[1])
    end
  end
end
