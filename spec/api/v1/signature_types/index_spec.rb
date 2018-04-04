# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'signature_types#index', type: :request do
  subject(:make_request) do
    jsonapi_get '/api/v1/signature_types',
                params: params
  end
  let(:params) { {} }

  describe 'basic fetch' do
    let!(:applicant) { create(:signature_type, name: 'applicant') }
    let!(:witness) { create(:signature_type, name: 'witness') }

    it 'serializes the list correctly' do
      make_request
      expect(json_ids(true)).to match_array([applicant.id, witness.id])
      assert_payload(:signature_type, applicant, json_items[0])
      assert_payload(:signature_type, witness, json_items[1])
    end
  end
end
