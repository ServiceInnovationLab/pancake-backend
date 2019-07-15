# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DeclinedRebateFormsController, type: :feature, js: true do
  let(:user) { FactoryBot.create :admin_user_with_name }
  let(:council) { FactoryBot.create :council }
  let(:property) { FactoryBot.create :property, council: council }
  let!(:kept_rebate_forms) do
    FactoryBot.create_list(:rebate_form, 8)
  end
  let!(:discarded_rebate_forms) do
    FactoryBot.create_list(:rebate_form, 5).each do |f|
      Audited.audit_class.as_user(user) do
        f.discard(audit_comment: 'RSpec decline')
      end
    end
  end

  before do
    login_as(user, scope: :user)
  end

  describe 'GET #index' do
    it 'the show links go to the show page' do
      visit admin_rebate_forms_declined_path
      first('.rebate-results-table-cell .rebate-form-blue-arrow').click
      expect(page).to have_text('Application details')
    end

    it 'shows exactly the declined rebate forms' do
      visit admin_rebate_forms_declined_path

      expect(page).to have_selector('.rebate-form--completed', count: 5)

      # Look for all expected values from the expected models
      discarded_rebate_forms
        .map { |f| [f.fields['full_name'], f.location] }
        .flatten
        .map { |v| expect(page).to have_text(v) }
    end

    context 'when a form is declined' do
      it 'appears in the list' do
        declined_form = kept_rebate_forms.first
        Audited.audit_class.as_user(user) do
          declined_form.discard(audit_comment: 'RSpec decline')
        end

        visit admin_rebate_forms_declined_path

        expect(page).to have_selector('.rebate-form--completed', count: 6)
        expect(page).to have_text(declined_form.fields['full_name'])
        expect(page).to have_text(declined_form.audits.last.user.name)
        expect(page).to have_text(declined_form.location)
      end
    end

    context 'when a form is restored' do
      it 'is removed from the list' do
        restored_form = discarded_rebate_forms.first
        restored_form.undiscard(audit_comment: 'RSpec restore')

        visit admin_rebate_forms_declined_path

        expect(page).to have_selector('.rebate-form--completed', count: 4)
        # these expectations would be nice but would cause intermittent failures
        # because our test data might not contain unique values (another record
        # on the page could have the same text we expect to be removed)
        #
        # expect(page).not_to have_text(restored_form.fields['full_name'])
        # expect(page).not_to have_text(restored_form.location)
      end
    end
  end
end
