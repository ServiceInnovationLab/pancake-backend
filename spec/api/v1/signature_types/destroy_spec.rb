# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signature_types#destroy', type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/v1/signature_types/#{signature_type.id}"
  end

  describe 'basic destroy' do
    let!(:signature_type) { create(:signature_type) }

    it 'will not delete the resource' do
      expect do
        make_request
      end.to raise_error(ActionController::RoutingError)
    end
  end
end
