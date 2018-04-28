# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'properties#show', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/v1/properties/#{property.id}",
                params: params
  end

  describe 'basic fetch' do
    let!(:property) { create(:property) }

    it 'serializes the resource correctly' do
      make_request
      assert_payload(:property, property, json_item)
    end
  end
end
