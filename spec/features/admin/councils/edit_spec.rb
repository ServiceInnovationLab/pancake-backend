# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Council', type: :feature, js: true do
  let!(:council) { FactoryBot.create :council, name: 'Most Oarsum City Council', short_name: 'MOCC' }

  context 'anonymous' do
    it "can't see it" do
      visit "/admin/councils/#{council.id}"
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
    end
  end

  context 'can edit' do
    let(:user) { FactoryBot.create :admin_user }
    before do
      login_as(user, scope: :user)
      visit "/admin/councils/#{council.id}/edit"
    end
    describe 'can modify the fields for the selected council' do
      it { expect(page).to have_text('Editing council') }
      it { expect(page).to have_text('Name') }
      it { expect(page).to have_field(with: council.name) }
      it { expect(page).to have_text('This is a required field.') }
      it { expect(page).to have_text('Short name') }
      it { expect(page).to have_field(with: council.short_name) }
      it { expect(page).to have_text('This is a required field.') }
      it { expect(page).to have_text('Email') }
      it { expect(page).to have_field(with: council.email) }
      it { expect(page).to have_text('where to send') }
      it { expect(page).to have_checked_field('council_active') }
      it { expect(page).to have_text('Active') }
      it { expect(page).to have_button('Save') }
      it { expect(page).to have_link('Show') }
      it { expect(page).to have_link('Back') }

      describe 'saving' do
        it do
          fill_in 'Name', with: 'New Council 2'
          fill_in 'Short name', with: 'New C2'
          fill_in 'Email', with: 'C2@council.co.nz'
          check 'council_active'
          click_button 'Save'
          expect(page).to have_text('Council was successfully updated.')
        end
      end

      describe 'editing' do
        # This blocks exists mostly to make the percy snapshot happen
        it do
          fill_in 'Name', with: 'New Council 2'
          fill_in 'Short name', with: 'New C2'
          fill_in 'Email', with: 'C2@council.co.nz'
          check 'council_active'
        end
        include_examples 'percy snapshot'
      end
    end
  end
end
