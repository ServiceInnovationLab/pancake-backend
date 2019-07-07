# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RebateFormsCouncilDetails', type: :feature, js: true do
  let(:property) { FactoryBot.create :property_with_rates, rating_year: ENV['YEAR'] }
  let!(:rebate_form) { FactoryBot.create :rebate_form, status: RebateForm::NOT_SIGNED_STATUS, property: property }

  context 'anonymous' do
    it "can't see it" do
      visit "/admin/rebate_forms/edit_council_details?rebate_form_id=#{rebate_form.id}"
      expect(page).to have_text('Rates Rebate')
      expect(page).to have_text('Log in')
    end
  end

  shared_examples 'can edit' do
    describe '#edit' do
      it 'can modify the council details section of the rebate_form' do
        visit "/admin/rebate_forms/edit_council_details?rebate_form_id=#{rebate_form.id}"
        expect(page).to have_text('Council details')
        expect(page).to have_text('Valuation ID')
        expect(page).to have_text('Application ID')
        expect(page).to have_text('Customer ID')
        fill_in('Valuation ID', with: '123Iamawesome', fill_options: { clear: :backspace })
        fill_in('Application ID', with: '456Youaretoo', fill_options: { clear: :backspace })
        fill_in('Customer ID', with: '789Wearethebest', fill_options: { clear: :backspace })
        click_button 'SAVE'
        expect(page).to have_text('123Iamawesome')
        expect(page).to have_text('456Youaretoo')
        expect(page).to have_text('789Wearethebest')
        rebate_form.reload
        expect(rebate_form.valuation_id).to eq '123Iamawesome'
        expect(rebate_form.application_id).to eq '456Youaretoo'
        expect(rebate_form.customer_id).to eq '789Wearethebest'
      end
    end

    describe '#cancel' do
      it 'can see the CANCEL button' do
        visit "/admin/rebate_forms/edit_council_details?rebate_form_id=#{rebate_form.id}"
        expect(page).to have_text('CANCEL')
        expect(page).to have_text('Council details')
        expect(page).to have_text('Valuation ID')
        expect(page).to have_text('Application ID')
        expect(page).to have_text('Customer ID')
        expect(page).to have_field(with: rebate_form.valuation_id)
        fill_in('Valuation ID', with: '123Iamawesome', fill_options: { clear: :backspace })
        click_link 'cancel'
        expect(page).to have_text('EDIT')
        expect(page).to_not have_text('CANCEL')
        expect(page).to have_text('Council details')
        expect(page).to have_text(rebate_form.valuation_id)
      end
    end
  end

  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }

    before { login_as(user, scope: :user) }

    include_examples 'can edit'
  end

  context 'signed in as council' do
    let(:user) { FactoryBot.create :user, council_id: rebate_form.property.council_id }

    before { login_as(user, scope: :user) }

    include_examples 'can edit'
  end
end
