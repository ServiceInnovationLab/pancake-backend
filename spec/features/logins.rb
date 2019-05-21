# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logging in', type: :feature do
  context 'anonymous' do
    it "can't see it" do
      visit '/admin'
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
      expect(page).not_to have_text('Log out')
    end
  end

  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }

    before { login_as(user, scope: :user) }

    it ' Can see rebate forms' do
      visit '/admin'
      expect(page).to have_text('Log out')
    end
  end
end
