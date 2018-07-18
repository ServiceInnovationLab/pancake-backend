# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Council, type: :model do
  let(:council) { FactoryBot.create :council, name: 'Tauranga' }
  let(:properties) { FactoryBot.create_list :property, 10, council: council }
  before do
    FactoryBot.create :rates_bill, property: properties.first
    FactoryBot.create :rates_payer, property: properties.first
  end
  describe 'names' do
    it { expect(council.name).to eq 'Tauranga' }
  end
  describe 'has properties' do
    it { expect(council.properties).to eq properties }
  end
  describe 'has rates_bills' do
    it { expect(council.rates_bills).to eq properties.first.rates_bills }
  end
  describe 'has rates_payers' do
    it { expect(council.rates_payers).to eq properties.first.rates_payers }
  end
end
