# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Councils', type: :request do
  context 'not signed in' do
    describe 'GET /admin/councils' do
      it 'works! (now write some real specs)' do
        get admin_councils_path
        expect(response).to have_http_status(302)
      end
    end
  end
end
