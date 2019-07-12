# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RebateForm', type: :feature, js: true do
  let(:council) { FactoryBot.create :council, name: 'Tauranga' }
  let!(:rebate_form) do
    FactoryBot.create(:rebate_form, property: FactoryBot.create(:property_with_rates, council: council))
  end
  let(:expected_name) { rebate_form.full_name }
  let(:expected_location) { rebate_form.location }

  let!(:signed_form) do
    FactoryBot.create(:signed_form, property: FactoryBot.create(:property_with_rates, council: council))
  end
  let(:signed_name) { signed_form.full_name }
  let(:signed_location) { signed_form.location }

  let!(:processed_form) do
    FactoryBot.create(:processed_form, property: FactoryBot.create(:property_with_rates, council: council))
  end
  let(:processed_name) { processed_form.full_name }
  let(:processed_valuation_id) { processed_form.valuation_id }

  # discarded forms should not be visible in this view. We create some in the
  # database so that if they're not hidden properly it will be noticable
  let!(:discarded_rebate_forms) do
    FactoryBot.create_list(:rebate_form, 5, discarded_at: Time.now.utc)
  end

  context 'anonymous' do
    it "can't see it" do
      visit '/admin'
      expect(page).to have_text('Rates Rebate')
      expect(page).to have_text('Log in')
    end
    include_examples 'percy snapshot'
  end

  shared_examples 'rebate_forms' do
    before do
      # Set up some data. 33 properties in Tauranga with data
      FactoryBot.create_list(:property_with_rates, 33, council: council).each do |property|
        FactoryBot.create(:rebate_form, property: property)
      end
      login_as(user, scope: :user)
      visit '/admin'
    end
    describe 'on initial load' do
      it 'no applications should be visible' do
        expect(page).to have_text('Signed')
        expect(page).to have_text('Not Signed')
        expect(page).to have_text('Processed')
        expect(page).to have_text('Batched')
        expect(page).to have_field('name')
        expect(page).not_to have_text(expected_name)
        expect(page).not_to have_selector('.rebate-form--completed')
      end
      include_examples 'percy snapshot'
    end
    describe 'searching with blank' do
      it 'should see all un-signed rebate forms' do
        click_button 'Search'
        expect(page).to have_text('Signed')
        expect(page).to have_text('Not Signed')
        expect(page).to have_text('Processed')
        expect(page).to have_text('Batched')
        expect(page).to have_field('name')
        expect(page).to have_text(expected_name)
        expect(page).to have_text(expected_location)
        expect(page).to_not have_text('Application ID')

        expect(page).to have_selector(
          '.rebate-form--completed',
          count: RebateForm.kept.select(&:not_signed_state?).count
        )
      end
      include_examples 'percy snapshot'
    end

    describe 'searching by name' do
      before do
        fill_in 'Name', with: expected_name
        click_button 'Search'
      end
      it 'finds the person with matching name' do
        expect(page).to have_text(expected_name)
        expect(page).to have_selector('.rebate-form--completed', count: 1)
      end
      include_examples 'percy snapshot'
    end

    describe 'no search results' do
      before do
        fill_in 'Name', with: '123'
        click_button 'Search'
      end
      it 'does not find the person with matching name' do
        expect(page).to have_text("We couldn't find anyone named \"123\"")
        expect(page).to have_text('Search tips:')
        expect(page).to have_text('Check the spelling')
        expect(page).to have_text('Try using a first name or last name')
        expect(page).to have_text('Search on all customers by leaving the field blank')
        expect(page).not_to have_selector('.rebate-form--completed')
      end
    end

    describe 'get all signed forms' do
      before do
        click_button 'Signed'
      end
      it 'should see all signed rebate forms' do
        expect(page).to have_text('Signed')
        expect(page).to have_text('Not Signed')
        expect(page).to have_text('Processed')
        expect(page).to have_text('Batched')
        expect(page).not_to have_field('name')
        expect(page).to have_text(signed_name)
        expect(page).to have_text(signed_location)
        expect(page).to_not have_text('Application ID')
        expect(page).to have_selector('.rebate-form--completed', count: 1)
      end
      include_examples 'percy snapshot'
    end

    describe 'get all processed forms' do
      before do
        click_button 'Processed'
      end
      it 'should see all processed rebate forms' do
        expect(page).to have_text('Signed')
        expect(page).to have_text('Not Signed')
        expect(page).to have_text('Processed')
        expect(page).to have_text('Batched')
        expect(page).to have_text(processed_name)
        expect(page).to have_text('Application ID')
        expect(page).to have_text(processed_form.application_id)
        expect(page).to have_selector('.rebate-form--completed', count: 1)
      end
      include_examples 'percy snapshot'
    end

    describe 'unprocess some processed forms' do
      it 'should remove unprocessed rebate forms' do
        click_button 'Processed'
        expect(page).to have_text('Signed')
        expect(page).to have_text('Not Signed')
        expect(page).to have_text('Processed')
        expect(page).to have_text('Batched')
        expect(page).to have_text('UNPROCESS')
        expect(page).to have_text('CREATE BATCH')
        expect(page).to have_text(processed_name)
        expect(page).to have_text(processed_valuation_id)
        check(`#{processed_name}-checkbox`)
        click_button 'UNPROCESS'
        expect(page).not_to have_text(processed_name)
      end
      include_examples 'percy snapshot'
    end

    describe 'batch some processed forms' do
      it 'should remove batched rebate forms' do
        click_button 'Processed'
        expect(page).to have_text('Signed')
        expect(page).to have_text('Not Signed')
        expect(page).to have_text('Processed')
        expect(page).to have_text('Batched')
        expect(page).to have_text('UNPROCESS')
        expect(page).to have_text('CREATE BATCH')
        expect(page).to have_text(processed_name)
        check(`#{processed_name}-checkbox`)
        click_button 'CREATE BATCH'
        expect(page).not_to have_text(processed_name)
      end
      include_examples 'percy snapshot'
    end
  end

  context 'signed in as admin (dia user)' do
    let(:user) { FactoryBot.create :admin_user, email: 'somebody.important@dia.govt.nz' }
    include_examples 'rebate_forms'
  end
  context 'signed in as council' do
    let(:user) { FactoryBot.create :user, council_id: council.id, email: 'somebody.important@somecouncil.govt.nz' }
    include_examples 'rebate_forms'

    describe "can't see rebate_forms from other councils" do
      let(:other_councils_form) { FactoryBot.create :rebate_form }
      before do
        visit '/admin'
        fill_in 'Name', with: other_councils_form.full_name
        click_button 'Search'
      end
      # it { expect(page).not_to have_text other_councils_form.full_name }
      it 'does not find the person with matching name' do
        expect(page).to have_text("We couldn't find anyone named \"#{other_councils_form.full_name}\"")
        expect(page).to have_text('Search tips:')
        expect(page).to have_text('Check the spelling')
        expect(page).to have_text('Try using a first name or last name')
        expect(page).to have_text('Search on all customers by leaving the field blank')
      end
    end
  end
end
