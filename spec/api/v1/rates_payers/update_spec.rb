# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rates_payers#update', type: :request do
  subject(:make_request) do
    jsonapi_put "/api/v1/rates_payers/#{rates_payer.id}", payload
  end

  describe 'basic update' do
    let!(:rates_payer) { create(:rates_payer) }

    let(:payload) do
      {
        data: {
          id: rates_payer.id.to_s,
          type: 'rates_payers',
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
      end.to change { rates_payer.reload.attributes }
      assert_payload(:rates_payer, rates_payer, json_item)

      # ... assert updates attributes ...
    end
  end
end
