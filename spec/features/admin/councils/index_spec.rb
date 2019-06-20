# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Council', type: :feature, js: true do
  let!(:council) { FactoryBot.create :council }
  let!(:council_two) { FactoryBot.create :council }

  context 'anonymous' do
    it "can't see it" do
      visit '/admin/councils'
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
    end
  end

  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }

    before { login_as(user, scope: :user) }

    it ' Can see all councils' do
      visit '/admin/councils'
      expect(page).to have_text(council.name)
      expect(page).to have_text(council.short_name)
    end
    include_examples 'percy snapshot'
  end

  context 'signed in as council' do
    let(:user) { FactoryBot.create :user, council: council }

    before { login_as(user, scope: :user) }

    it 'can see only my council' do
      visit '/admin/councils'
      expect(page).to have_text(council.name)
      expect(page).to have_text(council.short_name)

      expect(page).not_to have_text council_two.name
    end
  end
end
