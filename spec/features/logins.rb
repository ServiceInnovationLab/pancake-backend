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
  shared_examples 'on login' do
    describe 'can see highlighted unsigned tab and search button ' do
      it 'at /admin' do
        visit '/admin'
        expect(page).to have_text('Log out')
        expect(page).to have_text('Signed')
        expect(page).to have_text('Not Signed')
        expect(page).to have_field('name')
      end

      it 'at /admin/rebate_forms' do
        visit '/admin/rebate_forms'
        expect(page).to have_text('Log out')
        expect(page).to have_text('Signed')
        expect(page).to have_text('Not Signed')
        expect(page).to have_field('name')
      end
    end
  end
  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }

    before { login_as(user, scope: :user) }

    include_examples 'on login'
  end

  context 'signed in as council' do
    let(:user) { FactoryBot.create :user }

    before { login_as(user, scope: :user) }

    include_examples 'on login'
  end
end
