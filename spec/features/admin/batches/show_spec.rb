# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Batch', type: :feature, js: true do
  let(:property) { FactoryBot.create(:property_with_rates) }
  let(:user) { FactoryBot.create(:admin_user, council: property.council) }
  let!(:batched_form) { FactoryBot.create(:batched_form, property: property) }

  describe 'show pdf' do
    before { login_as(user, scope: :user) }

    context 'when I visit the pdf link' do
      it 'displays all of the correct information' do
        visit "/admin/batches/#{batched_form.batch_id}.pdf?debug=true"
        expect(page).to have_content(batched_form.batch.name)
        expect(page).to have_content(batched_form.fields['full_name'])
        expect(page).to have_content(batched_form.property.valuation_id)
        expect(page).to have_content(batched_form.fields['income']['total_income'])
        expect(page).to have_content(batched_form.fields['occupation'])
        expect(page).to have_content(batched_form.council.name)
        expect(page).to have_content(batched_form.signatures.witness.last.name)
      end
    end
  end
end
