# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Property', type: :feature do
  let!(:council) { FactoryBot.create :council }
  let!(:property) { FactoryBot.create :property, council: council }

  context 'anonymous' do
    it "can't see it" do
      visit "/admin/councils/#{council.id}/properties"
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
    end
  end

  shared_examples 'can see properties for a council' do
    it do
      visit '/admin/councils'
      expect(page).to have_text(council.name)
      click_link 'rateable properties data'
      expect(page).to have_text(property.valuation_id)
      expect(page).to have_text(property.location)
    end
  end

  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }

    before { login_as(user, scope: :user) }

    include_examples 'can see properties for a council'
  end

  context 'signed in as council' do
    let(:user) { FactoryBot.create :user, council: council }

    before { login_as(user, scope: :user) }

    include_examples 'can see properties for a council'
    include_examples 'percy snapshot'
  end
end
