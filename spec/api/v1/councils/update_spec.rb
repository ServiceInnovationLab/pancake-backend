# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'councils#update', type: :request do
  subject(:make_request) do
    jsonapi_put "/api/v1/councils/#{council.id}", payload
  end

  describe 'basic update' do
    let!(:council) { create(:council) }

    let(:payload) do
      {
        data: {
          id: council.id.to_s,
          type: 'councils',
          attributes: {
            # ... your attrs here
          }
        }
      }
    end

    it 'updates the resource' do
      expect { make_request }.to(change { council.reload.attributes })
      assert_payload(:council, council, json_item)
    end
  end
end
