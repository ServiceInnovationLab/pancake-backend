# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'properties#create', type: :request do
  subject(:make_request) do
    jsonapi_post '/api/v1/properties', payload
  end

  describe 'basic create' do
    let(:payload) do
      {
        data: {
          type: 'properties',
          attributes: {
            # ... your attrs here
          }
        }
      }
    end

    it 'creates the resource' do
      expect do
        make_request
      end.to change { Property.count }.by(1)
      property = Property.last

      assert_payload(:property, property, json_item)
    end
  end
end
