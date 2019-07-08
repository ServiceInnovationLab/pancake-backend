# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'IPad Signing', type: :feature, js: true do
  include FormattingHelper

  let(:property) { FactoryBot.create(:property_with_rates) }
  let!(:rebate_form) { FactoryBot.create(:rebate_form, property: property) }

  context 'when a rebate form is ready to sign' do
    let(:user) { FactoryBot.create :admin_user, email: 'somebody.important@dia.govt.nz' }
    let(:signing_url) do
      GenerateQrService.new(rebate_form, user).send(:signing_url)
    end

    let(:test_host) { "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/" }

    it 'can visit an ipad signing url' do
      visit signing_url.sub(ENV['APP_URL'], test_host)

      expect(page).to have_text('Application summary')

      # expect 'Next' button
      expect(page).to have_css('button.next.ga-appsum-next')

      expected_content = [
        rebate_form.location,
        currency_like_ipad(rebate_form.total_rates),
        rebate_form.fields['full_name'],
        rebate_form.fields['dependants'].to_s,
        rebate_form.fields['occupation'],
        currency_like_ipad(rebate_form.fields['income']['total_income'])
      ]

      expect(page.body).to include(*expected_content)

      if rebate_form.fields['lived_in_property_1_July'] == 'yes'
        expect(page.body).to include('I lived here on')
      else
        expect(page.body).to include('I have not lived here')
      end

      if rebate_form.fields['moved_within_rating_year'] == 'yes'
        expect(page.body).to include('I have moved')
      else
        expect(page.body).to include('I have not moved')
      end

      if rebate_form.fields['spouse_or_partner'] == 'yes'
        expect(page.body).to include('Our combined income')
      else
        expect(page.body).to include('My income')
      end

      if rebate_form.fields['income_less_than_5k'].present?
        expect(page.body).to include('I supported myself on less than $5,000 by')
        expect(page.body).to include(rebate_form.fields['income_less_than_5k'])
      end
    end
  end
end
