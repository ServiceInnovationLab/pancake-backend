# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateForm, type: :model do
  describe 'Unsigned form' do
    let(:form) { FactoryBot.create :rebate_form }
    describe 'has no signatures' do
      it { expect(form.signatures.size).to eq 0 }
    end
  end
  describe 'Signed form' do
    let(:form) { FactoryBot.create :signed_form }
    describe 'has both signatures' do
      it { expect(form.signatures.size).to eq 2 }
    end
  end

  describe 'signatures' do
    let(:form) { FactoryBot.create :rebate_form }
    let!(:applicant) { FactoryBot.create :applicant_signature, rebate_form: form }
    let!(:witness) { FactoryBot.create :witness_signature, rebate_form: form }
    it { expect(form.applicant_signature).to eq(applicant) }
    it { expect(form.witness_signature).to eq(witness) }
  end
end
