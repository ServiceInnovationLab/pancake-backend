# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signatures#create', type: :request do
  subject(:make_request) do
    jsonapi_post '/api/v1/signatures', payload
  end

  describe 'basic create' do
    let(:payload) do
      {
        data: {
          type: 'signatures',
          attributes: {
 # ... your attrs here
            },
        },
      }
    end

    pending 'creates the resource' do
      expect do
        make_request
      end.to change(Signature, :count).by(1)
      signature = Signature.last

      assert_payload(:signature, signature, json_item)
    end
  end
end
