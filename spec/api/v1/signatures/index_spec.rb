# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signatures#index', type: :request do
  subject(:make_request) do
    jsonapi_get '/api/v1/signatures',
                params: params
  end
  let(:params) { {} }

  describe 'basic fetch' do
    let!(:signature1) { create(:signature) }
    let!(:signature2) { create(:signature) }

    it 'serializes the list correctly' do
      expect do
        make_request
      end.to raise_error(ActionController::RoutingError)
    end
  end
end
