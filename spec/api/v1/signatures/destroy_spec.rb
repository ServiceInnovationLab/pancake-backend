# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signatures#destroy', type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/v1/signatures/#{signature.id}"
  end

  describe 'basic destroy' do
    let!(:signature) { create(:signature) }

    it 'deletes the signature' do
      expect do
        make_request
      end.to change { Signature.count }.by(-1)

      expect(response.status).to eq(200)
      expect(json).to eq('meta' => {})
    end
  end
end
