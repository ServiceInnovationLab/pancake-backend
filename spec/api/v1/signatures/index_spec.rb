# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signatures#index', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get '/api/v1/signatures',
                params: params
  end

  describe 'basic fetch' do
    let!(:signature1) { create(:signature) }
    let!(:signature2) { create(:signature) }

    it 'serializes the list correctly' do
      make_request
      expect(json_ids(true)).to match_array([signature1.id, signature2.id])
      assert_payload(:signature, signature1, json_items[0])
      assert_payload(:signature, signature2, json_items[1])
    end
  end
end
