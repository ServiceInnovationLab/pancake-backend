# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'properties#show', type: :request do
  subject(:make_request) do
    jsonapi_get "/api/v1/properties/#{property.valuation_id}"
  end

  let!(:property) { create(:property) }

  describe 'basic fetch' do
    it 'serializes the resource correctly' do
      make_request
      assert_payload(:property, property, json_item)
    end
  end
end
