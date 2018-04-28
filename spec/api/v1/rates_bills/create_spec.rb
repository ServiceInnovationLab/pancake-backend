# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rates_bills#create', type: :request do
  subject(:make_request) do
    jsonapi_post '/api/v1/rates_bills', payload
  end

  describe 'basic create' do
    let(:payload) do
      {
        data: {
          type: 'rates_bills',
          attributes: {
            # ... your attrs here
          }
        }
      }
    end

    it 'creates the resource' do
      expect do
        make_request
      end.to change { RatesBill.count }.by(1)
      rates_bill = RatesBill.last

      assert_payload(:rates_bill, rates_bill, json_item)
    end
  end
end
