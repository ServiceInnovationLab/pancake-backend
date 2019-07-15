# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ProcessedRebateForms', type: :feature, js: true do
  let(:council) { FactoryBot.create :council, name: 'Tauranga' }
  let(:property) { FactoryBot.create(:property_with_rates, council: council) }
  let!(:processed_forms) { FactoryBot.create_list(:processed_form, 3, property: property) }

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

  shared_examples 'processed rebate forms' do
    before do
      login_as(user, scope: :user)
    end

    context 'when I visit the processed tab' do
      before { visit '/admin/rebate_forms/processed' }

      it ' I can see all processed application forms' do
        expect(page).to have_selector('.rebate-form--completed', count: 3)
        expect(page).to have_text(processed_forms.first.fields['full_name'])
        expect(page).to have_text(processed_forms.second.fields['full_name'])
        expect(page).to have_text(processed_forms.third.fields['full_name'])
        expect(page).to have_text(processed_forms.first.valuation_id)
        expect(page).to have_text(processed_forms.second.valuation_id)
        expect(page).to have_text(processed_forms.third.valuation_id)
      end

      context 'when there is no valuation id' do
        before do
          processed_forms.first.update!(valuation_id: '')
        end

        it 'the cell is left blank' do
          expect(processed_forms.first.valuation_id).to eq ''
          expect(page).to have_css('#valuation-id', text: '')
        end
      end
      include_examples 'percy snapshot'
    end
  end

  context 'signed in as admin (dia user)' do
    let(:user) { FactoryBot.create :admin_user, email: 'somebody.important@dia.govt.nz' }
    include_examples 'processed rebate forms'
  end
  context 'signed in as council' do
    let(:user) { FactoryBot.create :user, council_id: council.id, email: 'somebody.important@somecouncil.govt.nz' }
    include_examples 'processed rebate forms'
  end
end
