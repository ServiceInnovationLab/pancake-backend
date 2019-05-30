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
      expect(RebateForm.where(status: RebateForm::PROCESSED_STATUS).count).to eq 1
    end
  end

  describe '#destroy' do
    let!(:processed_form) { FactoryBot.create(:processed_form) }

    it 'unprocesses a single application' do
      expect(RebateForm.count).to eq 1
      expect(RebateForm.where(status: RebateForm::PROCESSED_STATUS).count).to eq 1
      delete :destroy, params: { id: processed_form.id }
      expect(RebateForm.where(status: RebateForm::SIGNED_STATUS).count).to eq 1
    end
  end

  describe '#destroy_all' do
    let!(:processed_forms) { FactoryBot.create_list(:processed_form, 3) }

    it 'unprocesses multiple applications' do
      expect(RebateForm.count).to eq 3
      expect(RebateForm.where(status: RebateForm::PROCESSED_STATUS).count).to eq 3
      delete :destroy_all, params: { ids: processed_forms.map(&:id) }
      expect(RebateForm.where(status: RebateForm::SIGNED_STATUS).count).to eq 3
    end
  end
end
