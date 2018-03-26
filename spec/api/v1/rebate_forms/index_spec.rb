# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rebate_forms#index', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get '/api/v1/rebate_forms',
                params: params
  end

  describe 'basic fetch' do
    let!(:rebate_form1) { create(:rebate_form) }
    let!(:rebate_form2) { create(:rebate_form) }

    it 'serializes the list correctly' do
      make_request
      expect(json_ids(true)).to match_array([rebate_form1.id, rebate_form2.id])
      assert_payload(:rebate_form, rebate_form1, json_items[0])
      assert_payload(:rebate_form, rebate_form2, json_items[1])
    end
  end
end
