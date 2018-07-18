# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Property, type: :model do
  let(:council) { FactoryBot.create :council }
  let(:property) { FactoryBot.create :property, location: '123 Lambton Quay', council: council }

  it { expect(property.location).to eq '123 Lambton Quay' }
  it { expect(property.council).to eq council }
end
