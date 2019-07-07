# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :feature, js: true do
  context 'anonymous' do
    it "can't see it" do
      visit '/admin/users'
      expect(page).to have_text('Rates Rebate')
      expect(page).to have_text('Log in')
    end
  end

  context 'can edit' do
    let!(:admin_user) { FactoryBot.create :admin_user, name: 'AdminAdmin', email: 'User1@dia.govt.nz' }
    let!(:user1) { FactoryBot.create :council_user, name: 'First user' }
    let!(:user2) { FactoryBot.create :council_user, name: 'Second user' }

    before do
      login_as(admin_user, scope: :user)
      visit admin_users_path
    end

    describe 'show table of users' do
      it { expect(page).to have_text('Users') }
      it { expect(page).to have_text('Invite new users') }
      it { expect(page).to have_text('Name') }
      it { expect(page).to have_text('Email') }
      it { expect(page).to have_text('Role') }
      it { expect(page).to have_text('Council') }

      it { expect(page).to have_text(user1.name) }
      it { expect(page).to have_text(user1.email) }
      it { expect(page).to have_text(user1.council.name) }

      it { expect(page).to have_text(user2.name) }
      it { expect(page).to have_text(user2.email) }
      it { expect(page).to have_text(user2.council.name) }
    end

    describe 'deactivating user' do
      it do
        accept_confirm do
          click_link('deactivate', href: admin_user_path(user1))
        end
        expect(page).to have_text('User was de-activated.')

        click_link('edit', href: edit_admin_user_path(user1))
        click_button('Re-activate')
        expect(page).to have_text('User was re-activated.')
      end
    end

    describe 'invite new users' do
      before { click_on('Invite new users') }
      it { expect(page).to have_text('Send invitation') }
      it { expect(page).to have_text('Email') }
      it { expect(page).to have_field('user_email') }
      it { expect(page).to have_button('Send an invitation') }
      it 'fill in email address' do
        fill_in('user_email', with: 'user999@dia.govt.nz')
        click_on('Send an invitation')
        expect(page).to have_text('An invitation email has been sent to user999@dia.govt.nz')
      end
    end
  end
end
