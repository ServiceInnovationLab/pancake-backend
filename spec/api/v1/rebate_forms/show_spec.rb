# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rebate_forms#show', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/v1/rebate_forms/#{rebate_form.id}",
                params: params
  end

  describe 'basic fetch' do
    let!(:rebate_form) { create(:rebate_form) }

    pending 'serializes the resource correctly' do
      make_request
      assert_payload(:rebate_form, rebate_form, json_item)
    end
  end
end
