# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Batch', type: :feature, js: true do
  let(:property) { FactoryBot.create(:property_with_rates) }
  let!(:batched_form) { FactoryBot.create :batched_form, property: property }

  shared_examples 'can edit' do
    describe '#edit' do
      it 'can modify the batch name' do
        visit "/admin/batches/#{batched_form.batch_id}/edit"
        expect(page).to have_text('Name')
        expect(batched_form.batch.name).to eq "TEMP-BATCH-ID##{batched_form.batch_id}"
        fill_in('Name', with: 'BB8-123-456-789', fill_options: { clear: :backspace })
        click_button 'Save'
        batched_form.reload
        expect(batched_form.batch.name).to eq 'BB8-123-456-789'
      end
    end
  end

  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }

    before { login_as(user, scope: :user) }

    include_examples 'can edit'
  end

  context 'signed in as council' do
    let(:user) { FactoryBot.create :user, council_id: property.council_id }

    before { login_as(user, scope: :user) }

    include_examples 'can edit'
  end
end
