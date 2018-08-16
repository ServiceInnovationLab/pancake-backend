# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Properties', type: :request do
  describe 'GET /admin_properties' do
    it 'works! (now write some real specs)' do
      get admin_properties_path
      expect(response).to have_http_status(200)
    end
  end
end
