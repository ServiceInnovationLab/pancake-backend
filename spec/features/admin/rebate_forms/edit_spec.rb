# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RebateForm', type: :feature do
  let(:property) { FactoryBot.create :property_with_rates, rating_year: ENV['YEAR'] }
  let!(:rebate_form) { FactoryBot.create :rebate_form, completed: false, property: property }

  context 'anonymous' do
    it "can't see it" do
      visit "/admin/rebate_forms/#{rebate_form.id}"
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
    end
  end

  shared_examples 'can edit' do
    describe '#edit' do
      xit 'can modify the rebate_form' do
        visit "/admin/rebate_forms/#{rebate_form.id}/edit"
        expect(page).to have_text('Name')
        fill_in 'rebate_form_fields[full_name]', with: 'New name'
        click_button 'Save'
        expect(page).not_to have_text 'errors'
        expect(page).to have_text 'New name'
        rebate_form.reload
        expect(rebate_form.full_name).to eq 'New name'
      end
    end

    describe '#show' do
      xit 'can see edit link' do
        visit "/admin/rebate_forms/#{rebate_form.id}"
        expect(page).to have_text(rebate_form.fields['full_name'])
        click_link 'Edit'
        expect(page).to have_text('Customer Details')
      end
    end

    describe 'header buttons' do
      context 'when the back button is clicked' do
        it 'goes to the right place' do
          visit "/admin/rebate_forms/#{rebate_form.id}/edit"
          click_link('back')
          expect(page).to have_text('Rates Rebate 2018/2019')
          expect(page).to have_text('Customer applications')
        end
      end

      context 'when the reload button is clicked' do
        it 'goes to the right place' do
          visit "/admin/rebate_forms/#{rebate_form.id}/edit"
          click_link('reload')
          expect(page).to have_http_status :ok
        end
      end
    end

    describe 'edit banner message for completed rebate forms' do
      context 'when the rebate form is not completed' do
        it 'does not show the banner' do
          visit "/admin/rebate_forms/#{rebate_form.id}/edit"
          expect(page).to_not have_text('Are you sure you want to edit?')
          expect(page).to_not have_text('If you make any changes, the customer will have to sign the declaration again')
        end
      end

      context 'when the rebate form is completed' do
        let!(:rebate_form) { FactoryBot.create :signed_form, completed: true, property: property }

        it 'shows the banner' do
          visit "/admin/rebate_forms/#{rebate_form.id}/edit"
          expect(page).to have_text('Are you sure you want to edit?')
          expect(page).to have_text('If you make any changes, the customer will have to sign the declaration again')
        end
      end
    end
  end

  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }

    before { login_as(user, scope: :user) }

    include_examples 'can edit'
  end

  context 'signed in as council' do
    let(:user) { FactoryBot.create :user, council_id: rebate_form.property.council_id }

    before { login_as(user, scope: :user) }

    include_examples 'can edit'
  end
end
