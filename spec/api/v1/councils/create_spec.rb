# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'councils#create', type: :request do
  subject(:make_request) do
    jsonapi_post '/api/v1/councils', payload
  end

  describe 'basic create' do
    let(:payload) do
      {
        data: {
          type: 'councils',
          attributes: {
            # ... your attrs here
          }
        }
      }
    end

    it 'creates the resource' do
      expect do
        make_request
      end.to change { Council.count }.by(1)
      council = Council.last

      assert_payload(:council, council, json_item)
    end
  end
end
