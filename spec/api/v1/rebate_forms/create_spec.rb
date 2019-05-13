# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rebate_forms#create', type: :request do
  subject(:make_request) do
    jsonapi_post '/api/v1/rebate_forms', payload
  end

  describe 'basic create' do
    let(:payload) do
      {
        data: {
          type: 'rebate_forms',
          attributes: {
 # ... your attrs here
            },
        },
      }
    end

    pending 'creates the resource' do
      expect do
        make_request
      end.to change(RebateForm, :count).by(1)
      rebate_form = RebateForm.last

      assert_payload(:rebate_form, rebate_form, json_item)
    end
  end
end
