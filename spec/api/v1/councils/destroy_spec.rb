# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'councils#destroy', type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/v1/councils/#{council.id}"
  end

  describe 'basic destroy' do
    let!(:council) { create(:council) }

    it 'updates the resource' do
      expect do
        make_request
      end.to change { Council.count }.by(-1)

      expect(response.status).to eq(200)
      expect(json).to eq('meta' => {})
    end
  end
end
