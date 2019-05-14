# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RebateForm', type: :feature do
  let!(:rebate_form) { FactoryBot.create :rebate_form }

  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }

    before { login_as(user, scope: :user) }

    context 'rebate form is not completed' do
      it ' Can see customer details' do
        visit "/admin/rebate_forms/#{rebate_form.id}"
        expect(page).to have_text('Customer details')
        expect(page).to have_text('Signature required')
        expect(page).to have_text(rebate_form.fields['full_name'])
        expect(page).to have_text(rebate_form.fields['email'])
        expect(page).to have_text(rebate_form.fields['occupation'])
      end
    end

    context 'rebate form is completed' do
      before { rebate_form.update(completed: true) }

      it ' Can see customer details' do
        visit "/admin/rebate_forms/#{rebate_form.id}"
        expect(page).to have_text('Customer details')
        expect(page).to have_text('Signed and ready to process')
        expect(page).to have_text(rebate_form.fields['full_name'])
        expect(page).to have_text(rebate_form.fields['email'])
        expect(page).to have_text(rebate_form.fields['occupation'])
      end
    end
  end
end
