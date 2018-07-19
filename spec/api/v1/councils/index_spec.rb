# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'councils#index', type: :request do
  subject(:make_request) do
    jsonapi_get '/api/v1/councils',
                params: params
  end
  let(:params) { {} }

  describe 'basic fetch' do
    let!(:council1) { create(:council) }
    let!(:council2) { create(:council) }

    it 'serializes the list correctly' do
      make_request
      expect(json_ids(true)).to match_array([council1.id, council2.id])
      assert_payload(:council, council1, json_items[0])
      assert_payload(:council, council2, json_items[1])
    end
  end
end
