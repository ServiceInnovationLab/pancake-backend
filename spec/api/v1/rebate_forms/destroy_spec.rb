# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rebate_forms#destroy', type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/v1/rebate_forms/#{rebate_form.id}"
  end

  describe 'basic destroy' do
    let!(:rebate_form) { FactoryBot.create(:rebate_form) }

    it 'updates the resource' do
      expect do
        make_request
      end.to raise_error(ActionController::RoutingError)
    end
  end
end
