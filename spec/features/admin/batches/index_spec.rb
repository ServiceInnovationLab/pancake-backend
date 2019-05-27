# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Batch', type: :feature do
  let(:council) { FactoryBot.create :council, name: 'Tauranga' }
  let!(:batch) { FactoryBot.create :batch, council: council }
  let!(:batch_other_council) { FactoryBot.create :batch }

  before do
    # make sure there are unbatched forms
    10.times do
      property = FactoryBot.create(:property, council: batch.council)
      FactoryBot.create(:signed_form, rebate: 100, property: property, valuation_id: property.valuation_id)
    end
  end

  context 'anonymous' do
    it "can't see it" do
      visit '/admin/batches'
      expect(page).to have_text('Rates Rebate 2018/2019')
      expect(page).to have_text('Log in')
    end
  end

  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }

    before { login_as(user, scope: :user) }

    it ' Can see all batches' do
      visit '/admin/batches'
      expect(page).to have_link(href: admin_batch_path(batch, format: :pdf))
      expect(page).to have_link(href: admin_batch_path(batch_other_council, format: :pdf))

      expect(page).not_to have_button('Make next Batch')
    end
    include_examples 'percy snapshot'
  end

  context 'signed in as council' do
    let(:user) { FactoryBot.create :user, council: council }

    before { login_as(user, scope: :user) }

    it 'can see batches from my council' do
      visit '/admin/batches'
      expect(page).to have_link(href: admin_batch_path(batch, format: :pdf))
      expect(page).not_to have_link(href: admin_batch_path(batch_other_council, format: :pdf))

      expect(page).to have_text 'Tauranga have 10 fully signed forms not in a batch yet.'
      expect(page).to have_button('Make next Batch')
    end
    include_examples 'percy snapshot'
  end
end
