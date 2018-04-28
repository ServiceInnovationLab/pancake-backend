# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rates_payers#create', type: :request do
  subject(:make_request) do
    jsonapi_post '/api/v1/rates_payers', payload
  end

  describe 'basic create' do
    let(:payload) do
      {
        data: {
          type: 'rates_payers',
          attributes: {
            # ... your attrs here
          }
        }
      }
    end

    it 'creates the resource' do
      expect do
        make_request
      end.to change { RatesPayer.count }.by(1)
      rates_payer = RatesPayer.last

      assert_payload(:rates_payer, rates_payer, json_item)
    end
  end
end
