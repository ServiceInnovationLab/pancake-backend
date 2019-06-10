# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SignedRebateFormsController, type: :controller do
  let(:user) { FactoryBot.create :admin_user }

  before { sign_in user }

  describe '#index' do
    let!(:signed_forms) { FactoryBot.create_list(:signed_form, 3) }

    it 'assigns all signed rebate forms to @signed_rebate_forms' do
      get :index
      expect(assigns(:signed_rebate_forms)).to eq signed_forms.to_json(include: [:property])
      expect(response.status).to eq(200)
    end
  end
end
