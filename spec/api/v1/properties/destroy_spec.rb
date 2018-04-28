# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'properties#destroy', type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/v1/properties/#{property.id}"
  end

  describe 'basic destroy' do
    let!(:property) { create(:property) }

    it 'updates the resource' do
      expect do
        make_request
      end.to change { Property.count }.by(-1)

      expect(response.status).to eq(200)
      expect(json).to eq('meta' => {})
    end
  end
end
