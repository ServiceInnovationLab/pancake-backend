# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Council', type: :feature do
  subject { page }

  let!(:council) { FactoryBot.create :council }


  context 'anonymous' do
    before { visit "/admin/councils/#{council.id}" }

    it { is_expected.to have_text('Forgot your password?') }
    it { is_expected.to have_http_status :ok }
    it { is_expected.not_to have_text(council.name) }
  end

  context 'signed in as council' do
    before do
      # Set up some data
      FactoryBot.create(:rebate_form, property: FactoryBot.create(:property, council: council))
      FactoryBot.create(:rebate_form, property: FactoryBot.create(:property, council: council))
      FactoryBot.create(:signed_form, property: FactoryBot.create(:property, council: council))

      login_as(user)
      visit "/admin/councils/#{council.id}"
    end

    let(:user) { FactoryBot.create :user, council: council }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_text(council.name) }
    it { is_expected.to have_text('3 Rebate forms collected') }
    it { is_expected.to have_text('3 Rateable properties in database') }
  end

  context 'signed in as dia' do
    before do
      login_as(user, scope: :user)
      visit "/admin/councils/#{council.id}"
    end

    let(:user) { FactoryBot.create :admin_user }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_text(council.name) }
  end
end
