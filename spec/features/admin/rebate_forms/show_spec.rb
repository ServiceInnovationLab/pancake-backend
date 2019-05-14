# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RebateForm', type: :feature do
  let!(:rebate_form) { FactoryBot.create :rebate_form }

  it "Anonymous can't see it" do
    visit "/admin/rebate_forms/#{rebate_form.id}"
    expect(page).to have_text('Forgot your password?')
  end

  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }

    before { login_as(user, scope: :user) }

    context 'when the rebate form is not completed' do
      it ' Can see customer details' do
        visit "/admin/rebate_forms/#{rebate_form.id}"
        expect(page).to have_text('Customer details')
        expect(page).to have_text('Signature required')
        expect(page).to have_text(rebate_form.fields['full_name'])
        expect(page).to have_text(rebate_form.fields['email'])
        expect(page).to have_text(rebate_form.fields['occupation'])
      end

      context 'when the back button is clicked' do
        it 'goes to the right place' do
          visit "/admin/rebate_forms/#{rebate_form.id}"
          click_link('back')
          expect(page).to have_text('Rates Rebate 2018/2019')
        end
      end

      context 'when the reload button is clicked' do
        it 'goes to the right place' do
          visit "/admin/rebate_forms/#{rebate_form.id}"
          click_link('reload')
          expect(page).to have_http_status :ok
        end
      end

      context 'when the edit button is clicked' do
        it 'goes to the right place' do
          visit "/admin/rebate_forms/#{rebate_form.id}"
          click_link('edit')
          expect(page).to_not have_text('EDIT')
        end
      end
    end

    context 'when the rebate form is completed' do
      before { rebate_form.update(completed: true) }

      it ' Can see customer details' do
        visit "/admin/rebate_forms/#{rebate_form.id}"
        expect(page).to have_text('Customer details')
        expect(page).to have_text('Signed and ready to process')
        expect(page).to have_text(rebate_form.fields['full_name'])
        expect(page).to have_text(rebate_form.fields['email'])
        expect(page).to have_text(rebate_form.fields['occupation'])
      end
    end
  end
end
