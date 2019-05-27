# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Council', type: :feature, js: true do
  let!(:council) { FactoryBot.create :council }

  context 'anonymous' do
    it "can't see it" do
      visit "/admin/councils/#{council.id}"
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
    end
  end

  context 'edit form is displayed' do
    let(:user) { FactoryBot.create :admin_user }
    before do
      login_as(user, scope: :user)
      visit '/admin/councils/new'
    end

    describe 'can create new council' do
      it { expect(page).to have_text('New council') }
      it { expect(page).to have_text('Name') }
      it { expect(page).to have_field('council_name') }
      it { expect(page).to have_text('This is a required field.') }
      it { expect(page).to have_text('Short name') }
      it { expect(page).to have_field('council_short_name') }
      it { expect(page).to have_text('This is a required field.') }
      it { expect(page).to have_text('Email') }
      it { expect(page).to have_field('council_email') }
      it { expect(page).to have_text('where to send') }
      it { expect(page).to have_unchecked_field('council_active') }
      it { expect(page).to have_text('Active') }
      it { expect(page).to have_button('Save') }
      it { expect(page).to have_link('Back') }

      it do
        fill_in 'Name', with: 'New Council 1'
        fill_in 'Short name', with: 'New C1'
        fill_in 'Email', with: 'C1@council.co.nz'
        check 'council_active'
        expect { click_button 'Save' }.to change { Council.count }.by(1)
        expect(page).to have_text('Council was successfully created.')
      end

      # Only Name filled in
      it do
        fill_in 'Name', with: 'New Council 1'
        expect { click_button 'Save' }.to change { Council.count }.by(0)
        expect(page).to have_text('2 errors prohibited this data from being saved:')
        expect(page).to have_text("Short name can't be blank")
        expect(page).to have_text("Email can't be blank")
      end

      # Only Short name filled in
      it do
        fill_in 'Short name', with: 'New C1'
        expect { click_button 'Save' }.to change { Council.count }.by(0)
        expect(page).to have_text('2 errors prohibited this data from being saved:')
        expect(page).to have_text("Name can't be blank")
        expect(page).to have_text("Email can't be blank")
      end

      # Only Email filled in
      it do
        fill_in 'Email', with: 'C1@council.co.nz'
        expect { click_button 'Save' }.to change { Council.count }.by(0)
        expect(page).to have_text('2 errors prohibited this data from being saved:')
        expect(page).to have_text("Name can't be blank")
        expect(page).to have_text("Short name can't be blank")
      end

      # Duplicate Name & Short name
      it do
        FactoryBot.create :council, name: 'New Council 1', short_name: 'New C1'
        fill_in 'Name', with: 'New Council 1'
        fill_in 'Short name', with: 'New C1'
        fill_in 'Email', with: 'C1@council.co.nz'
        expect { click_button 'Save' }.to change { Council.count }.by(0)
        expect(page).to have_text('2 errors prohibited this data from being saved:')
        expect(page).to have_text('Name has already been taken')
        expect(page).to have_text('Short name has already been taken')
      end
    end
  end
end
