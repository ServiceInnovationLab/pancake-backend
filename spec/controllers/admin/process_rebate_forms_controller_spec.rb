# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ProcessRebateFormsController, type: :controller do
  let(:user) { FactoryBot.create :admin_user }

  before { sign_in user }

  describe '#create' do
    let!(:form_to_process) { FactoryBot.create(:signed_form) }

    it 'processes the rebate form' do
      expect(RebateForm.count).to eq 1
      expect(RebateForm.where(status: RebateForm::SIGNED_STATUS).count).to eq 1
      post :create, params: { id: form_to_process.id }
      expect(RebateForm.first.reload.processed_state?).to eq true
    end
  end

  describe '#destroy' do

  end
end
