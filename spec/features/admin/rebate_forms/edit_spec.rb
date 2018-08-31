# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RebateForm', type: :feature do
  let(:property) { FactoryBot.create :property_with_rates, rating_year: '2018' }
  let!(:rebate_form) { FactoryBot.create :rebate_form, property: property }

  context 'anonymous' do
    it "can't see it" do
      visit "/admin/rebate_forms/#{rebate_form.id}"
      expect(page).to have_text('Forgot your password?')
    end
  end

  shared_examples 'can edit' do
    describe '#edit' do
      it 'can modify the rebate_form' do
        visit "/admin/rebate_forms/#{rebate_form.id}/edit"
        expect(page).to have_text('Full name')
        fill_in 'rebate_form_fields[full_name]', with: 'New name'
        click_button 'Save'
        expect(page).not_to have_text 'errors'
        expect(page).to have_text 'New name'
        rebate_form.reload
        expect(rebate_form.full_name).to eq 'New name'
      end
    end

    describe '#index' do
      it 'can see edit link' do
        visit '/admin/rebate_forms'
        expect(page).to have_text(rebate_form.fields['full_name'])

        click_link 'Edit'
        expect(page).to have_text('Full name')
        expect(page).not_to have_text('error')
      end
    end

    describe '#show' do
      it 'can see edit link' do
        visit "/admin/rebate_forms/#{rebate_form.id}"
        expect(page).to have_text(rebate_form.fields['full_name'])

        click_link 'Edit'
        expect(page).to have_text('Full name')
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
