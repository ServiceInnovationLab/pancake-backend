# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RebateForm', type: :feature, js: true do
  let(:property) { FactoryBot.create :property_with_rates, rating_year: ENV['YEAR'] }
  let!(:rebate_form) { FactoryBot.create :rebate_form, status: RebateForm::NOT_SIGNED_STATUS, property: property }

  context 'anonymous' do
    it "can't see it" do
      visit "/admin/rebate_forms/#{rebate_form.id}"
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
    end
  end

  shared_examples 'can edit' do
    describe '#edit' do
      it 'can modify the rebate_form' do
        visit "/admin/rebate_forms/#{rebate_form.id}/edit"
        expect(page).to have_text('Name')
        fill_in('fields.full_name', with: 'arnold', fill_options: { clear: :backspace })
        click_button 'Submit'
        expect(find_field('fields.full_name').value).to have_text 'arnold'
        rebate_form.reload
        expect(rebate_form.full_name).to eq 'arnold'
      end
    end

    describe '#show' do
      it 'can see edit link' do
        visit "/admin/rebate_forms/#{rebate_form.id}"
        expect(page).to have_field(with: rebate_form.full_name)
        click_link 'EDIT'
        expect(page).to have_text('Customer details')
        expect(page).to have_field(with: rebate_form.full_name)
      end
      include_examples 'percy snapshot'
    end

    describe 'header buttons' do
      context 'when the back button is clicked' do
        it 'goes to the right place' do
          visit "/admin/rebate_forms/#{rebate_form.id}/edit"
          click_link('back')
          expect(page).to have_text('Rates Rebate 2018/2019')
          expect(page).to have_text('Customer search')
        end
      end

      context 'when the reload button is clicked' do
        it 'goes to the right place' do
          visit "/admin/rebate_forms/#{rebate_form.id}/edit"
          click_link('reload')
          expect(page).to have_current_path("/admin/rebate_forms/#{rebate_form.id}/edit")
          expect(page).to have_text('Customer details')
          expect(page).to have_text('Income declaration (before tax)')
        end
      end
    end

    describe 'edit banner message for signed rebate forms' do
      context 'when the rebate form is not signed' do
        it 'does not show the banner' do
          visit "/admin/rebate_forms/#{rebate_form.id}/edit"
          expect(page).to_not have_text('Are you sure you want to edit?')
          expect(page).to_not have_text('If you make any changes, the customer will have to sign the declaration again')
        end
      end

      context 'when the rebate form is signed' do
        let!(:rebate_form) { FactoryBot.create :signed_form, status: RebateForm::SIGNED_STATUS, property: property }

        it 'shows the banner' do
          visit "/admin/rebate_forms/#{rebate_form.id}/edit"
          expect(page).to have_text('Are you sure you want to edit?')
          expect(page).to have_text('If you make any changes, the customer will have to sign the declaration again')
        end
        include_examples 'percy snapshot'
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
