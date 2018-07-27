# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::BatchesController, type: :controller do
  context 'signed in as admin' do
    let(:admin_user) { FactoryBot.create :admin_user }

    before { sign_in admin_user }
  end
end
