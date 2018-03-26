# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signature_types#index', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get '/api/v1/signature_types',
                params: params
  end

  describe 'basic fetch' do
    let!(:signature_type1) { create(:signature_type) }
    let!(:signature_type2) { create(:signature_type) }

    it 'serializes the list correctly' do
      make_request
      expect(json_ids(true)).to match_array([signature_type1.id, signature_type2.id])
      assert_payload(:signature_type, signature_type1, json_items[0])
      assert_payload(:signature_type, signature_type2, json_items[1])
    end
  end
end
