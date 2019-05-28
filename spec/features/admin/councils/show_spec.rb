# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Council', type: :feature do
  subject { page }

  let!(:council) { FactoryBot.create :council }

  before do
    # Set up some data
    3.times do
      FactoryBot.create(:rebate_form, completed: true,
                                      property: FactoryBot.create(:property_with_rates, council: council))
      FactoryBot.create(:rebate_form, completed: false,
                                      property: FactoryBot.create(:property_with_rates, council: council))
    end
  end

  context 'anonymous' do
    before { visit "/admin/councils/#{council.id}" }

    it { is_expected.to have_text('Rates Rebate 2018/2019') }
    it { is_expected.to have_text('Log in') }
    it { is_expected.to have_http_status :ok }
    it { is_expected.not_to have_text(council.name) }
  end

  context 'signed in as council' do
    before do
      login_as(user)
      visit "/admin/councils/#{council.id}"
    end

    let(:user) { FactoryBot.create :user, council: council }

    it { is_expected.to have_http_status :ok }
    describe 'show name of council' do
      it { expect(page).to have_text(council.name) }
      include_examples 'percy snapshot'
    end
    it { is_expected.to have_text('$555.12') } # average
    it { is_expected.to have_text('$3,330.72') } # sum
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
