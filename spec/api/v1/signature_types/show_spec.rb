# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signature_types#show', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/v1/signature_types/#{signature_type.id}",
                params: params
  end

  describe 'basic fetch' do
    let!(:signature_type) { create(:signature_type) }

    it 'serializes the resource correctly' do
      make_request
      assert_payload(:signature_type, signature_type, json_item)
    end
  end
end
