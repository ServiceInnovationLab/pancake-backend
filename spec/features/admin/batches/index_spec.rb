# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Batch', type: :feature do
  let(:property) { FactoryBot.create :property_with_rates }
  let!(:batch_other_council) { FactoryBot.create :batch }
  let!(:batched_form) { FactoryBot.create :batched_form, property: property }

  context 'anonymous' do
    it "can't see it" do
      visit '/admin/batches'
      expect(page).to have_text('Rates Rebate - The Future and Beyond')
      expect(page).to have_text('Log in')
    end
  end

  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }

    before { login_as(user, scope: :user) }

    it ' Can see all batches' do
      visit '/admin/batches'
      expect(page).to have_text(batched_form.batch.name)
      expect(page).to have_text('Header sheet required')
      expect(page).to have_text(batch_other_council.name)
      expect(page).not_to have_text('EDIT')
    end

    context 'when there is a header sheet' do
      before do
        batched_form.batch.update!(header_sheet_attached: true)
        batch_other_council.update!(header_sheet_attached: true)
      end

      it 'updates the display accordingly' do
        visit '/admin/batches'
        expect(page).to_not have_text('Header sheet required')
        expect(page).to have_text('HEADER SHEET')
        expect(page).to have_css('#header-sheet')
      end
    end

    it ' opens a new window when the BATCH button is clicked' do
      visit '/admin/batches'
      expect(page.windows.count).to eq 1
      find('.batches-applications-button', match: :first).click
      expect(page.windows.count).to eq 2
    end
    include_examples 'percy snapshot'
  end

  context 'signed in as council' do
    let(:user) { FactoryBot.create :council_user, council: property.council }

    before { login_as(user, scope: :user) }

    it 'can only see batches from my council' do
      visit '/admin/batches'
      expect(page).to have_text(batched_form.batch.name)
      expect(page).to have_text('Header sheet required')
      expect(page).not_to have_text(batch_other_council.name)
      expect(page).to have_text('EDIT')
    end

    context 'when there is a header sheet' do
      before do
        batched_form.batch.update!(header_sheet_attached: true)
      end

      it 'updates the display accordingly' do
        visit '/admin/batches'
        expect(page).to_not have_text('Header sheet required')
        expect(page).to have_text('HEADER SHEET')
      end
    end
    include_examples 'percy snapshot'
  end
end
