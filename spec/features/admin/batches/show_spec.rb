# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Batch', type: :feature, js: true do
  let(:property) { FactoryBot.create(:property_with_rates) }
  let(:user) { FactoryBot.create(:admin_user, council: property.council) }

  describe 'show batch' do
    before { login_as(user, scope: :user) }

    context 'when I visit the batch link' do
      let!(:batched_form) { FactoryBot.create(:batched_form, property: property) }

      it 'displays all of the correct information' do
        visit "/admin/batches/#{batched_form.batch_id}"
        expect(page).to have_content(batched_form.batch.name)
        expect(page).to have_content(batched_form.batch.rebate_forms.count)
        expect(page).to have_content(batched_form.fields['full_name'])
        expect(page).to have_content(batched_form.fields['phone_number'])
        expect(page).to have_content(batched_form.fields['email'])
        expect(page).to have_content(batched_form.valuation_id)
        expect(page).to have_content(batched_form.location)
        expect(page).to have_content(batched_form.fields['occupation'])
        expect(page).to have_content(batched_form.council.name)
        expect(page).to have_content(batched_form.signatures.witness.last.name)
        expect(page).to have_content('Customer ID')
        expect(page).to have_content(batched_form.customer_id)
        expect(page).to have_content('Application ID')
        expect(page).to have_content(batched_form.application_id)
        expect(page).to_not have_content('What is the address of your previous property?')
        expect(page).to_not have_content('What was the settlement date of the home you sold?')
        expect(page).to_not have_content('How did you support yourself on less than $5,000?')
      end
    end

    context 'when there are conditional fields' do
      context 'moved within rating year' do
        let!(:batched_form) do
          FactoryBot.create(:batched_form,
                            :moved_within_rating_year,
                            property: property)
        end

        it 'displays the extra questions and answers' do
          visit "/admin/batches/#{batched_form.batch_id}"
          expect(page).to have_content('What is the address of your previous property?')
          expect(page).to have_content('What was the settlement date of the home you sold?')
          expect(page).to have_content(batched_form.fields['previous_address'])
        end
      end

      context 'no customer or application id' do
        let!(:batched_form) do
          FactoryBot.create(:batched_form,
                            property: property,
                            customer_id: nil,
                            application_id: nil)
        end

        it 'does not display them' do
          visit "/admin/batches/#{batched_form.batch_id}"
          expect(page).to_not have_content('Customer ID')
          expect(batched_form.customer_id).to eq nil
          expect(page).to_not have_content('Application ID')
          expect(batched_form.application_id).to eq nil
        end
      end

      context 'income less than $5k' do
        let!(:batched_form) do
          FactoryBot.create(:batched_form,
                            :income_less_than_5k,
                            property: property)
        end

        it 'displays the extra question and answer' do
          visit "/admin/batches/#{batched_form.batch_id}"
          expect(page).to have_content('How did you support yourself on less than $5,000?')
          expect(page).to have_content(batched_form.fields['income_less_than_5k'])
        end
      end
    end
  end
end
