# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignatureType, type: :model do
  let!(:applicant_type) { FactoryBot.create(:signature_type, name: 'applicant') }
  let!(:witness_type) { FactoryBot.create(:signature_type, name: 'witness') }
  it { expect(witness_type.name).to eq 'witness' }
  describe 'scopes' do
    it { expect(SignatureType.applicant).to eq [applicant_type] }
    it { expect(SignatureType.witness).to eq [witness_type] }
  end
end
