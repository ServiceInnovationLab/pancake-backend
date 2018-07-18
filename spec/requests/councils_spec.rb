# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Councils', type: :request do
  describe 'GET /councils' do
    it 'works! (now write some real specs)' do
      get admin_councils_path
      expect(response).to have_http_status(200)
    end
  end
end
