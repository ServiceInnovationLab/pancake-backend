# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::RebateFormsCouncilDetailsController, type: :controller do
  let(:property) { FactoryBot.create :property_with_rates, rating_year: ENV['YEAR'] }
  let!(:rebate_form) { FactoryBot.create :rebate_form, status: RebateForm::NOT_SIGNED_STATUS, property: property }

  shared_examples 'can update council details' do
    describe '#update' do
      let(:params) do
        { id: rebate_form.id,
          rebate_form: {
            valuation_id: '123Iamawesome',
            application_id: '456Youaretoo',
            customer_id: '789Wearethebest'
          } }
      end

      before do
        patch :update, params: params
        rebate_form.reload
      end

      it 'updates the rebate form' do
        expect(rebate_form.valuation_id).to eq '123Iamawesome'
        expect(rebate_form.application_id).to eq '456Youaretoo'
        expect(rebate_form.customer_id).to eq '789Wearethebest'
      end
    end
  end

  context 'signed in as council users' do
    let(:user) { FactoryBot.create :user, council: rebate_form.council }

    before { sign_in user }

    include_examples 'can update council details'
  end

  context 'signed in as admin' do
    let(:user) { FactoryBot.create :admin_user }

    before { sign_in user }

    include_examples 'can update council details'
  end
end
