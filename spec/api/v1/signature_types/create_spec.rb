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
            # ... your attrs here
          }
        }
      }
    end

    pending 'creates the resource' do
      expect do
        make_request
      end.to change { SignatureType.count }.by(1)
      signature_type = SignatureType.last

      assert_payload(:signature_type, signature_type, json_item)
    end
  end
end
