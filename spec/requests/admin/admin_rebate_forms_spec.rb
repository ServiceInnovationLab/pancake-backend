# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::RebateForms', type: :request do
  describe 'GET /admin_rebate_forms' do
    it 'works! (now write some real specs)' do
      get admin_rebate_forms_path
      expect(response).to have_http_status(200)
    end
  end
end
