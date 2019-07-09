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

    context 'can visit an ipad signing url' do
      before do
        visit signing_url.sub(ENV['APP_URL'], test_host)
      end

      it 'shows the Application summary title and "Next" button' do
        expect(page).to have_text('Application summary')

        # expect 'Next' button
        expect(page).to have_css('button.next.ga-appsum-next')
      end

      it 'shows the summary of the rebate form' do
        # look for the page title - this seems to prevent the rest of the test
        # from failing due to timing issues
        expect(page).to have_text('Application summary')

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

      context 'when we go to the next page' do

        before do
          # look for the page title - this seems to prevent the rest of the test
          # from failing due to timing issues
          expect(page).to have_text('Application summary')
          click_on 'NEXT'
        end

        it 'shows the Applicant Signature page and nav' do
          expect(page).to have_text('Applicant signature')

          # expect 'Next' button
          expect(page).to have_css('button.next.ga-appsig-next')

          # expect 'Back' button
          expect(page).to have_css('button.back.ga-appsig-goback')
        end

        it 'warns if we try to proceed without signing' do
          click_on 'NEXT'
          expect(page).to have_text('Please sign before you proceed')
        end

        context 'when we go to the next page' do

          before do
            # look for the page title - this seems to prevent the rest of the test
            # from failing due to timing issues
            expect(page).to have_text('Applicant signature')
            find('canvas.sigCanvas').click
            click_on 'NEXT'
          end

          it 'shows the Witness Signature page and nav' do
            expect(page).to have_text('Witness signature')

            # expect 'Submit' button
            expect(page).to have_css('button.next.ga-witsig-submit')

            # expect 'Back' button
            expect(page).to have_css('button.back.ga-witsig-goback')
          end

          it 'warns if we try to proceed without signing' do
            click_on 'SUBMIT'
            expect(page).to have_text('Please sign before you proceed')
          end

          it 'submits successfully after we sign' do
            find('canvas.sigCanvas').click
            click_on 'SUBMIT'
            expect(page).to have_text('Thank you')

            rebate_form.reload
            expect(rebate_form.signed_state?).to be true
          end
        end
      end
    end
  end
end
