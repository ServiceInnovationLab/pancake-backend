# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Batch', type: :feature do
  let!(:batch) { FactoryBot.create :batch }
  let!(:batch_other_council) { FactoryBot.create :batch }

  context 'anonymous' do
    it "can't see it" do
      visit '/admin/batches'
      expect(page).to have_text('Forgot your password?')
    end
  end

  context 'signed in as dia' do
    let(:user) { FactoryBot.create :admin_user }
    before { login_as(user, scope: :user) }

    it ' Can see all batches' do
      visit '/admin/batches'
      expect(page).to have_link(href: admin_batch_path(batch, format: :pdf))
      expect(page).to have_link(href: admin_batch_path(batch_other_council, format: :pdf))
    end
  end

  context 'signed in as council' do
    let(:user) { FactoryBot.create :user, council: batch.council }
    before { login_as(user, scope: :user) }

    it 'ca see batches from my council' do
      visit '/admin/batches'
      expect(page).to have_link(href: admin_batch_path(batch, format: :pdf))
      expect(page).not_to have_link(href: admin_batch_path(batch_other_council, format: :pdf))
    end
  end
end
