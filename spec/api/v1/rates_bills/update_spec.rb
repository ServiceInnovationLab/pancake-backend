# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rates_bills#update', type: :request do
  subject(:make_request) do
    jsonapi_put "/api/v1/rates_bills/#{rates_bill.id}", payload
  end

  describe 'basic update' do
    let!(:rates_bill) { create(:rates_bill) }

    let(:payload) do
      {
        data: {
          id: rates_bill.id.to_s,
          type: 'rates_bills',
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
      end.to change { rates_bill.reload.attributes }
      assert_payload(:rates_bill, rates_bill, json_item)

      # ... assert updates attributes ...
    end
  end
end
