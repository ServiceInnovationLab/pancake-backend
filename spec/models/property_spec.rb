# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Property, type: :model do
  let(:property) { FactoryBot.create :property, location: '123 Lambton Quay' }

  it { expect(property.location).to eq '123 Lambton Quay' }
end
