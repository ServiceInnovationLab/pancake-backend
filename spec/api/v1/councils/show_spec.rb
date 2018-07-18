# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'councils#show', type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/v1/councils/#{council.id}",
                params: params
  end

  describe 'basic fetch' do
    let!(:council) { create(:council) }

    it 'serializes the resource correctly' do
      make_request
      assert_payload(:council, council, json_item)
    end
  end
end
