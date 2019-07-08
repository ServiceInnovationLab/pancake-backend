# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'IPad Signing', type: :feature, js: true do
  let(:property) { FactoryBot.create(:property_with_rates) }
  let!(:rebate_form) { FactoryBot.create(:rebate_form, property: property) }

  context 'when a rebate form is ready to sign' do
    let(:user) { FactoryBot.create :admin_user, email: 'somebody.important@dia.govt.nz' }
    let(:signing_url) do
      Timecop.freeze(Time.zone.local(2019, 9, 1, 10, 5, 0))
      GenerateQrService.new(rebate_form, user).send(:signing_url)
    end

    let(:test_host) { "#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/" }

    it 'can visit an ipad signing url' do
      visit signing_url.sub("localhost:3000/", test_host)

      expect(page).to have_text('Application summary')

      # expect 'Next' button
      expect(page).to have_css('button.next.ga-appsum-next')

      # My name is Miss Sherron Ortiz and my occupation is witch.\nMy address is and I
      # have not lived here 1 July 2018. I have not moved within this rating year.\nMy
      # 2018 rates bill (including water) is $0.00.\nI have 0 dependants.\nMy income
      # (before tax) for the 2017/2018 tax year is $224.

      expected_user_values = rebate_form
        .attributes.slice(
          *%w[
            location
            total_rates
          ]
        ).merge(
          rebate_form.fields.slice(
            *%w[
              full_name
              dependants
              occupation
            ]
          )
        ).values
        .map(&:to_s)

      # byebug

      expect(page.body).to include(*expected_user_values)

      # TODO
      # expect formatted rates_bill and total_income
      # expect conditional text:
      # {lived_in_property_1_July ? ' I lived here on' : ' I have not lived here'}  1 July {ratingYear}.
      # {moved_within_rating_year ? ' I have moved ' : ' I have not moved'} within this rating year.
      # {spouse_or_partner ?
      #                <p>
      #     Our combined income (before tax) for the {taxYear} tax year is <strong>{total_income_formatted}</strong>.
      # </p>
      #     :
      # <p>My income (before tax) for the {taxYear} tax year is <strong>{total_income_formatted}</strong>.</p>
      # }
      # {income_less_than_5k && <p>
      #     I supported myself on less than $5,000 by {income_less_than_5k}
      # </p>}
    end
  end
end
