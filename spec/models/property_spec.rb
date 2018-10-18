# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Property, type: :model do
  let(:council) { FactoryBot.create :council }
  let(:property) { FactoryBot.create :property, location: '123 Lambton Quay', council: council }

  it { expect(property.location).to eq '123 Lambton Quay' }
  it { expect(property.council).to eq council }

  describe 'validation' do
    it 'is not valid without rating_year' do
      property = FactoryBot.build(:property)
      property.rating_year = nil
      expect(property).to_not be_valid
    end
  end
end
