# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RebateForm', type: :feature, js: true do
  let(:property) { FactoryBot.create(:property_with_rates) }
  let!(:rebate_form) { FactoryBot.create(:rebate_form, property: property) }
  let(:user) { FactoryBot.create :admin_user, email: 'somebody.important@dia.govt.nz' }

  context 'when signed in as an admin user viewing an incomplete rebate form' do
    before do
      login_as(user, scope: :user)
      visit "/admin/rebate_forms/#{rebate_form.id}"
    end

    scenario 'when I view the form I can decline it then restore it' do
      find('.rebate-form__action--decline').click

      expect(page).to have_text('Decline Application')

      click_on 'Save'
      expect(page).to have_text('Must provide a reason')
      fill_in 'rebate_form_audit_comment', with: 'Rspec decline'
      click_on 'Save'

      expect(page).to have_text('Rebate form was declined')
      find('.rebate-form__action--restore').click

      expect(page).to have_text('Restore Application')
      click_on 'Save'
      expect(page).to have_text('Must provide a reason')
      fill_in 'rebate_form_audit_comment', with: 'Rspec restore'
      click_on 'Save'

      expect(page).to have_text('Rebate form was restored')
    end

    scenario 'when I cancel the decline dialog it goes back the show page and is not declined' do
      find('.rebate-form__action--decline').click
      expect(page).to have_text('Decline Application')
      click_on 'Cancel'

      expect(page).not_to have_text('Rebate form was declined')
    end

    scenario 'when I cancel the restore dialog it goes back to the show page and is not restored' do
      find('.rebate-form__action--decline').click

      expect(page).to have_text('Decline Application')
      fill_in 'rebate_form_audit_comment', with: 'Rspec decline'
      click_on 'Save'

      expect(page).to have_text('Rebate form was declined')
      find('.rebate-form__action--restore').click

      expect(page).to have_text('Restore Application')
      fill_in 'rebate_form_audit_comment', with: 'Rspec restore'
      click_on 'Cancel'

      expect(page).to have_text('Rebate form was declined')
    end
  end
end
