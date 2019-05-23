# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RebateForm', type: :feature, js: true do
  let(:council) { FactoryBot.create :council, name: 'Tauranga' }
  let!(:rebate_form) do
    FactoryBot.create(:rebate_form, property: FactoryBot.create(:property, council: council))
  end
  let(:expected_name) { rebate_form.full_name }

  context 'anonymous' do
    it "can't see it" do
      visit '/admin'
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
    end
    include_examples 'percy snapshot'
  end

  shared_examples 'rebate_forms' do
    before do
      # Set up some data. 33 properties in Tauranga with data
      FactoryBot.create_list(:property, 33, council: council).each do |property|
        FactoryBot.create(:rebate_form, property: property)
      end
      login_as(user, scope: :user)
      visit '/admin'
    end
    describe 'searching with blank' do
      it 'should see all rebate forms' do
        click_button 'Search'
        expect(page).to have_text('Signed')
        expect(page).to have_text('Not Signed')
        expect(page).to have_text(expected_name)
      end
      include_examples 'percy snapshot'
    end

    describe 'searching by name' do
      before do
        fill_in 'Name', with: expected_name
        click_button 'Search'
      end
      it { expect(page).to have_text(expected_name) }
      include_examples 'percy snapshot'
    end
  end

  context 'signed in as admin (dia user)' do
    let(:user) { FactoryBot.create :admin_user }
    include_examples 'rebate_forms'
  end
  context 'signed in as council' do
    let(:user) { FactoryBot.create :user, council_id: council.id }
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
