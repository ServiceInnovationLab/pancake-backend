# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignatureType, type: :model do
  let(:signature_type) { FactoryBot.create(:signature_type, name: 'witness') }
  it { expect(signature_type.name).to eq 'witness' }
end
