# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Batch', type: :feature, js: true do
  let(:property) { FactoryBot.create(:property_with_rates) }
  let(:user) { FactoryBot.create(:admin_user, council: property.council) }
  let!(:batched_form) { FactoryBot.create(:batched_form, property: property) }

  describe 'show pdf' do
    before { login_as(user, scope: :user) }

    context 'when the download button is clicked' do
      it 'opens the pdf' do
        visit '/admin/batches'
        expect(page).to have_content("Batches for #{property.council.name}")
        click_link('Download')
        find('.batches-heading')
        expect(page).to have_content("COVER PAGE for Batch #{batched_form.batch_id}")
        expect(page).to have_content(batched_form.batch.name)
      end
    end
  end
end
