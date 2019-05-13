# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rebate_forms#update', type: :request do
  subject(:make_request) do
    jsonapi_put "/api/v1/rebate_forms/#{rebate_form.id}", payload
  end

  describe 'basic update' do
    let!(:rebate_form) { FactoryBot.create(:rebate_form) }

    let(:payload) do
      {
        data: {
          id: rebate_form.id.to_s,
          type: 'rebate_forms',
          attributes: {
 # ... your attrs here
            },
        },
      }
    end

    # Replace 'xit' with 'it' after adding attributes
    xit 'updates the resource' do
      expect do
        make_request
      end.to change { rebate_form.reload.attributes }
      assert_payload(:rebate_form, rebate_form, json_item)

      # ... assert updates attributes ...
    end
  end
end
