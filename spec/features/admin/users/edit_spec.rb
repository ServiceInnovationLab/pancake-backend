# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :feature, js: true do
  let!(:admin_user) { FactoryBot.create :admin_user, email: 'User1@dia.govt.nz', password: 'P@ssw0rd' }
  let!(:user1) { FactoryBot.create :council_user }
  let!(:user2) { FactoryBot.create :council_user }
  let!(:other_council) { FactoryBot.create :council }
  let!(:other_role) { FactoryBot.create :role, name: 'comic', friendly_name: 'comic relief' }

  context 'anonymous' do
    it "can't see it" do
      visit "/admin/users/#{user1.id}"
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
    end
  end

  context 'can edit' do
    before do
      login_as(admin_user, scope: :user)
      visit "/admin/users/#{user1.id}/edit"
    end
    describe 'can see the fields for the selected user' do
      it { expect(page).to have_text('Editing User') }
      it { expect(page).to have_text(user1.email) }
      it { expect(page).to have_text('Name') }
      it { expect(page).to have_field(user1.name) }
      it { expect(page).to have_text('Role') }

      it { expect(page).to have_field('Te Tari Taiwhenua') }
      it { expect(page).to have_field(other_role.friendly_name) }
      # TODO: this is the council role from factorybot. Needs some tidy up.
      it { expect(page).to have_checked_field('very cool') }

      it { expect(page).to have_text('Council') }
      it { expect(page).to have_field('-- None --') }
      it { expect(page).to have_checked_field(user1.council.name) }
      it { expect(page).to have_field(other_council.name) }

      it { expect(page).to have_button('Save') }
      it { expect(page).to have_link('Back') }
    end

    describe 'saving' do
      before do
        fill_in 'Name', with: 'User 1'
        click_button 'Save'
      end
      it { expect(page).to have_text('User was updated.') }
    end
  end

  context 'cannot edit' do
    let(:user) { FactoryBot.create :council_user }
    before do
      login_as(user, scope: :user)
      visit "/admin/users/#{user.id}/edit"
    end
    describe 'cannot modify the fields for the selected user' do
      it { expect(page).to have_text('You are not authorized to perform this action.') }
      it { expect(page).to have_text('Forbidden') }
    end
  end
end
