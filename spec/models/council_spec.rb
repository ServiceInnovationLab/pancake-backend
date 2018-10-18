# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Council, type: :model do
  let(:year) { '2018' }
  let(:council) { FactoryBot.create :council, name: 'Tauranga' }
  let(:properties) { FactoryBot.create_list :property, 10, council: council, rating_year: year }

  before do
    FactoryBot.create :rates_bill, property: properties.first, rating_year: year
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

  describe 'has batches' do
    let!(:batch) { FactoryBot.create :batch, council: council }

    it { expect(council.batches).to include batch }
  end

  describe 'has users' do
    let!(:user) { FactoryBot.create :user, council: council }

    it { expect(council.users).to include user }
  end

  describe 'has valid name, short_name, email' do

    it 'is not valid without name' do
      council = FactoryBot.build(:council)
      council.name = nil
      expect(council).to_not be_valid
    end

    it 'is not valid without email' do
      council = FactoryBot.build(:council)
      council.email = nil
      expect(council).to_not be_valid
    end

    it 'is not valid without short_name' do
      council = FactoryBot.build(:council)
      council.short_name = nil
      expect(council).to_not be_valid
    end

  end

  describe 'when name and short_name are already taken' do
    it 'should not be valid' do
      council_a = FactoryBot.create(:council)
      council_b = Council.create(council_a.as_json.except('id'))
      expect(council_b).to_not be_valid
    end
  end

end
