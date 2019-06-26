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
      end
    end

    context 'when there are conditional fields' do
      let!(:batched_form) do
        FactoryBot.create(:batched_form,
                          :moved_within_rating_year,
                          property: property,
                          customer_id: nil,
                          application_id: nil)
      end

      it 'displays the extra questions and answers' do
        visit "/admin/batches/#{batched_form.batch_id}"
        expect(page).to have_content('What is the address of your previous property?')
        expect(page).to have_content('What was the settlement date of the home you sold?')
        expect(page).to have_content(batched_form.fields['previous_address'])
        expect(page).to_not have_content('Customer ID')
        expect(batched_form.customer_id).to eq nil
        expect(page).to_not have_content('Application ID')
        expect(batched_form.application_id).to eq nil
      end
    end
  end
end
