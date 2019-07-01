# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :feature, js: true do
  let!(:user) { FactoryBot.create :user, email: 'User1@dia.govt.nz', password: 'P@ssw0rd' }

  context 'anonymous' do
    it "can't see it" do
      visit "/admin/users/#{user.id}"
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
    end
  end

  context 'can edit' do
    let(:user) { FactoryBot.create :admin_user }
    let(:user2) { FactoryBot.create :admin_user }
    before do
      login_as(user, scope: :user)
      visit "/admin/users/#{user.id}/edit"
    end
    describe 'can see the fields for the selected user' do
      it { expect(page).to have_text('Editing User') }
      it { expect(page).to have_text(user.email) }
      it { expect(page).to have_text('Name') }
      it { expect(page).to have_field(user.name) }
      it { expect(page).to have_text('Role') }
      it { expect(page).to have_checked_field('Te Tari Taiwhenua') }
      # it { expect(page).to have_unchecked_field('Council frontline staff') }
      # it { expect(page).to have_unchecked_field('Council rates staff') }
      it { expect(page).to have_text('Council') }
      it { expect(page).to have_checked_field('-- None --') }
      # it { expect(page).to have_checked_field('Bayerport City Council') }
      # it { expect(page).to have_checked_field('Bergstromshire City Council') }
      # it { expect(page).to have_checked_field('Bradtkemouth City Council') }
      # it { expect(page).to have_checked_field('Bryonfort City Council') }
      # it { expect(page).to have_checked_field('Hoppemouth City Council') }
      # it { expect(page).to have_checked_field('Lake Lucioland City Council') }
      # it { expect(page).to have_checked_field('Maritaside City Council') }
      # it { expect(page).to have_checked_field('New Barrettport City Council') }
      # it { expect(page).to have_checked_field('New Council 12') }
      # it { expect(page).to have_checked_field('New Lilla City Council') }
      # it { expect(page).to have_checked_field('New Zulmachester City Council') }
      # it { expect(page).to have_checked_field('North Averyside City Council') }
      # it { expect(page).to have_checked_field('North Davidstad City Council') }
      # it { expect(page).to have_checked_field('North Reginia City Council') }
      # it { expect(page).to have_checked_field('North Roxie City Council') }
      # it { expect(page).to have_checked_field('Port Damon City Council') }
      # it { expect(page).to have_checked_field('South Jessieshire City Council') }
      # it { expect(page).to have_checked_field('South Kena City Council') }
      # it { expect(page).to have_checked_field('South Lura City Council') }
      # it { expect(page).to have_checked_field('Tauranga') }
      # it { expect(page).to have_checked_field('West Stacy City Council') }
      # it { expect(page).to have_checked_field('Zemlakbury City Council') }
      it { expect(page).to have_button('Save') }
      it { expect(page).to have_link('Back') }
    end
    describe 'saving' do
      it do
        fill_in 'Name', with: 'User 1'
        click_button 'Save'
        expect(page).to have_text('User was updated.')
      end
    end
    describe 'editing' do
      # This blocks exists mostly to make the percy snapshot happen
      it do
        fill_in 'Name', with: 'User 1'
      end
      include_examples 'percy snapshot'
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
