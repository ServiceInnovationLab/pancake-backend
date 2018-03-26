# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signature_types#update', type: :request do
  subject(:make_request) do
    jsonapi_put "/api/v1/signature_types/#{signature_type.id}", payload
  end

  describe 'basic update' do
    let!(:signature_type) { create(:signature_type) }

    let(:payload) do
      {
        data: {
          id: signature_type.id.to_s,
          type: 'signature_types',
          attributes: {
            # ... your attrs here
          }
        }
      }
    end

    # Replace 'xit' with 'it' after adding attributes
    xit 'updates the resource' do
      expect do
        make_request
      end.to change { signature_type.reload.attributes }
      assert_payload(:signature_type, signature_type, json_item)

      # ... assert updates attributes ...
    end
  end
end
