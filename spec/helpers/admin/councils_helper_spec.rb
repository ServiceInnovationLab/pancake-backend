# frozen_string_literal: true

# # frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the Admin::UsersHelper. For example:
#
RSpec.describe Admin::CouncilsHelper, type: :helper do
  let(:council) { FactoryBot.create :council }
  let(:batch) { FactoryBot.create :batch, council: council }

  before do
    # uncompleted
    10.times do
      property = FactoryBot.create(:property, council: council)
      FactoryBot.create(:rebate_form, rebate: 100, property: property, valuation_id: property.valuation_id)
    end

    # completed
    10.times do
      property = FactoryBot.create(:property, council: council)
      FactoryBot.create(:signed_form, rebate: 100, property: property, valuation_id: property.valuation_id)
    end

    # in a batch
    10.times do
      property = FactoryBot.create(:property, council: council)
      form = FactoryBot.create(:signed_form, rebate: 100, property: property, valuation_id: property.valuation_id)
      form.update(batch: batch)
    end
  end

  describe 'council_forms_count(council)' do
    it { expect(council_forms_count(council)).to eq 30 }
  end

  describe 'council_forms_sum(council)' do
    it { expect(council_forms_sum(council)).to eq '$3000.00' }
  end

  describe 'council_signed_forms_count(council)' do
    it { expect(council_signed_forms_count(council)).to eq 20 }
  end

  describe 'council_percentage_signed(council)' do
    it { expect(council_percentage_signed(council)).to eq '66%' }
  end

  describe 'council_signed_forms_sum(council)' do
    it { expect(council_signed_forms_sum(council)).to eq '$2000.00' }
  end

  describe 'council_signed_batched_forms_count(council)' do
    it { expect(council_signed_batched_forms_count(council)).to eq 10 }
  end

  describe 'council_signed_batched_forms_sum(council)' do
    it { expect(council_signed_batched_forms_sum(council)).to eq '$1000.00' }
  end
end
