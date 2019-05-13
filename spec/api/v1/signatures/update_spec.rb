# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signatures#update', type: :request do
  subject(:make_request) do
    jsonapi_put "/api/v1/signatures/#{signature.id}", payload
  end

  describe 'basic update' do
    let!(:signature) { create(:signature) }

    let(:payload) do
      {
        data: {
          id: signature.id.to_s,
          type: 'signatures',
          attributes: {
 # ... your attrs here
            },
        },
      }
    end

    # Replace 'xit' with 'it' after adding attributes
    pending 'updates the resource' do
      expect do
        make_request
      end.to change { signature.reload.attributes }
      assert_payload(:signature, signature, json_item)

      # ... assert updates attributes ...
    end
  end
end
