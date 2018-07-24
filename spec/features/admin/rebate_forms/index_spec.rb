# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RebateForm', type: :feature do
  let!(:rebate_form) { FactoryBot.create :rebate_form }

  context 'anonymous' do
    it "can't see it" do
      visit '/admin/rebate_forms'
      expect(page).to have_text('Forgot your password?')
    end
  end
  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }
    before { login_as(user, scope: :user) }
    it ' Can see rebate forms' do
      visit '/admin/rebate_forms'
      expect(page).to have_text(rebate_form.fields['full_name'])

      # show the form
      click_link 'show'
      expect(page).to have_text(rebate_form.fields['full_name'])
    end
  end
  context 'signed in as council' do
  end
end
