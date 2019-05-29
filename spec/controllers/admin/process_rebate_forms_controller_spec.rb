# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ProcessRebateFormsController, type: :controller do
  let(:user) { FactoryBot.create :admin_user }

  before { sign_in user }

  describe '#index' do
    let!(:processed_rebate_form) { FactoryBot.create(:processed_form) }

    it 'returns a list of processed rebate forms' do
      get :index, format: :json
      expect(assigns(:processed_rebate_forms)).to eq([processed_rebate_form])
    end
  end

  describe '#create' do
  end

  describe '#destroy' do
  end
end
