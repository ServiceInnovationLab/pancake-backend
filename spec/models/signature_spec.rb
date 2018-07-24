# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Signature, type: :model do
  let!(:rebate_form) { FactoryBot.create :rebate_form }

  context 'forms is signed' do
    let!(:witness) { FactoryBot.create :witness_signature, rebate_form: rebate_form }
    let!(:applicant) { FactoryBot.create :applicant_signature, rebate_form: rebate_form }

    describe 'signature type' do
      it { expect(witness.signature_type.name).to eq 'witness' }
      it { expect(applicant.signature_type.name).to eq 'applicant' }
    end

    describe 'scopes' do
      it { expect(Signature.applicant).to eq [applicant] }
      it { expect(Signature.witness).to eq [witness] }
    end

    describe 'image' do
      it { expect(witness.image.present?).to eq true }
    end
  end
  it 'updated form gets marked completed' do
    expect(rebate_form.completed).to eq false

    # applicant signs
    FactoryBot.create :applicant_signature, rebate_form: rebate_form
    expect(rebate_form.completed).to eq false

    # witness signs
    witness = FactoryBot.create :witness_signature, rebate_form: rebate_form
    expect(rebate_form.completed).to eq true

    witness.destroy
    expect(rebate_form.completed).to eq false
  end
end
