# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signature_types#create', type: :request do
  subject(:make_request) do
    jsonapi_post '/api/v1/signature_types', payload
  end

  describe 'basic create' do
    let(:payload) do
      {
        data: {
          type: 'signature_types',
          attributes: {
            name: 'scribble'
          }
        }
      }
    end

    it 'does not let api calls create new signature_types' do
      expect do
        make_request
      end.to raise_error(ActionController::RoutingError)
    end
  end
end
