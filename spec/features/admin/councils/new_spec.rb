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

  context 'can edit' do
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
      it { expect(page).to have_selector(:link_or_button, 'Save') }
      it { expect(page).to have_selector(:link_or_button, 'Back') }
    end
  end
end
