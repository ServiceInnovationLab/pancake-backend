# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rebate_forms#index', type: :request do
  subject(:make_request) do
    jsonapi_get '/api/v1/rebate_forms',
                params: params
  end
  let(:params) { {} }


  describe 'basic fetch' do
    let!(:rebate_form1) { create(:rebate_form) }
    let!(:rebate_form2) { create(:rebate_form) }

    it 'does not return list' do
      expect do
        make_request
      end.to raise_error(ActionController::RoutingError)
    end
  end
end
