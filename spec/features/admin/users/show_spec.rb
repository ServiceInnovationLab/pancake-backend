# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :feature, js: true do
  let!(:user) { FactoryBot.create :user, name: 'User1', email: 'User1@dia.govt.nz', password: 'P@ssw0rd' }

  context 'anonymous' do
    it "can't see it" do
      visit '/admin/users'
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
    end
  end

  context 'can edit' do
    let(:user) { FactoryBot.create :admin_user }
    let(:user2) { FactoryBot.create :council_user, :deactivated_at }
    before do
      login_as(user, scope: :user)
      visit '/admin/users/'
    end
    describe 'show table of users' do
      it { expect(page).to have_text('Users') }
      it { expect(page).to have_text('Invite new users') }
      it { expect(page).to have_text('Name') }
      it { expect(page).to have_text('Email') }
      it { expect(page).to have_text('Role') }
      it { expect(page).to have_text('Council') }
      it { expect(page).to have_text(user.name) }
      it { expect(page).to have_text(user.email) }
      it { expect(page).to have_text('Te Tari Taiwhenua') }
      it { expect(page).to have_text(user.council) }
      it { expect(page).to have_link('edit') }
      # it { expect(page).to have_button('deactivate') }
    end
    # describe 'deactivating user' do
    #   it do
    #     click_on('deactivate')
    #     expect(page).to have_text('User was de-activated.')
    #     click_link('edit')
    #     click_button('Re-activate')
    #   end
    # end
    describe 'invite new users' do
      before do
        click_on('Invite new users')
      end
      it { expect(page).to have_text('Send invitation') }
      it { expect(page).to have_text('Email') }
      it { expect(page).to have_field('user_email') }
      it { expect(page).to have_button('Send an invitation') }
      it 'fill in email address' do
        fill_in('user_email', with: 'user1@dia.govt.nz')
        click_on('Send an invitation')
        expect(page).to have_text('An invitation email has been sent to user1@dia.govt.nz')
      end
    end
  end
end
