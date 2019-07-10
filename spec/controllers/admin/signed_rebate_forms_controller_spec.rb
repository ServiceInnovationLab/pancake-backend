# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SignedRebateFormsController, type: :controller do
  let(:user) { FactoryBot.create :admin_user }

  before { sign_in user }

  describe '#index' do
    let!(:signed_forms) { FactoryBot.create_list(:signed_form, 3) }

    it 'assigns all signed rebate forms to @signed_rebate_forms' do
      get :index
      expect(assigns(:signed_rebate_forms)).to eq signed_forms
      expect(response.status).to eq(200)
    end
  end

  describe 'GET download_csv' do
    let!(:signed_forms) { FactoryBot.create_list(:signed_form, 3) }

    before :each do
      get :download_csv
    end

    it 'generate CSV' do
      expect(response.header['Content-Type']).to include 'text/csv'
      expect(response.body).to include('location')
      expect(response.body).to include('fields')

      signed_forms.each do |rebate_form|
        expect(response.body).to include(rebate_form.valuation_id)
        expect(response.body).to include(rebate_form.fields['full_name'])
        expect(response.body).to include(rebate_form.status)
        expect(response.body).to include(rebate_form.customer_id)
        expect(response.body).to include(rebate_form.application_id)
        expect(response.body).to include(rebate_form.location)
      end
    end
  end
end
