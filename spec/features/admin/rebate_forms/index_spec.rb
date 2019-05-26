# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RebateForm', type: :feature, js: true do
  let!(:rebate_form) { FactoryBot.create :rebate_form }
  let(:expected_name) { rebate_form.full_name }

  context 'anonymous' do
    it "can't see it" do
      visit '/admin'
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
    end
  end

  shared_examples 'rebate_forms' do
    before { login_as(user, scope: :user) }
    describe ' Can see all rebate forms' do
      before do
        visit '/admin'
        click_button 'Search'
      end
      it { expect(page).to have_text('Signed') }
      it { expect(page).to have_text('Not Signed') }
      it { expect(page).to have_text(expected_name) }
    end

    describe 'searching for rebate forms by name' do
      before do
        visit '/admin'
        fill_in 'Name', with: expected_name
        click_button 'Search'
      end
      it { expect(page).to have_text(expected_name) }
    end
  end

  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }
    include_examples 'rebate_forms'
  end
  context 'signed in as council' do
    let(:user) { FactoryBot.create :user, council_id: rebate_form.property.council_id }
    include_examples 'rebate_forms'

    describe "can't see rebate_forms from other councils" do
      let(:other_councils_form) { FactoryBot.create :rebate_form }
      before do
        visit '/admin'
        fill_in 'Name', with: other_councils_form.full_name
        click_button 'Search'
      end
      it { expect(page).not_to have_text other_councils_form.full_name }
    end
  end
end
