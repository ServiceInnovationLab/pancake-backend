# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signatures#show', type: :request do
  subject(:make_request) do
    jsonapi_get "/api/v1/signatures/#{signature.id}",
                params: params
  end
  let(:params) { {} }

  describe 'basic fetch' do
    let!(:signature) { create(:signature) }

    pending 'serializes the resource correctly' do
      expect do
        make_request
      end.to raise_error(ActionController::RoutingError)
      # assert_payload(:signature, signature, json_item)
    end
  end
end
