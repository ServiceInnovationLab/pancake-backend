# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateForm, type: :model do
  let(:year) { '2018' }
  let(:valuation_id) { 'abc' }
  let(:property) { FactoryBot.create :property, valuation_id: valuation_id, rating_year: year }

  describe 'Unsigned form' do
    let(:form) { FactoryBot.create :rebate_form, property: property, valuation_id: valuation_id }

    describe 'has no signatures' do
      it { expect(form.signatures.size).to eq 0 }
    end

    it { expect(form.not_signed_state?).to eq true }
  end

  describe 'Signed form' do
    let(:form) { FactoryBot.create :signed_form, property: property, valuation_id: valuation_id }

    describe 'factorybot makes both signatures' do
      it { expect(form.signatures.size).to eq 2 }
    end

    it { expect(form.signed_state?).to eq true }
  end

  describe 'signatures' do
    let(:form) { FactoryBot.create :rebate_form, property: property, valuation_id: valuation_id }
    let!(:applicant) { FactoryBot.create :applicant_signature, rebate_form: form }
    let!(:witness) { FactoryBot.create :witness_signature, rebate_form: form }

    it { expect(form.applicant_signature).to eq(applicant) }
    it { expect(form.witness_signature).to eq(witness) }
  end

  describe 'tokens' do
    describe 'sets a token' do
      let(:form) { FactoryBot.create :rebate_form, property: property, valuation_id: valuation_id }

      it { expect(form.token.present?).to eq true }
      it { expect(form.token.length).to be >= 40 }
    end

    it 'generates long tokens' do
      100.times do
        expect(RebateForm.new.token.length).to be >= 40
      end
    end
  end

  describe 'calculates rebate' do
    let!(:rates_bill) { FactoryBot.create :rates_bill, total_rates: 3450, total_water_rates: 5, property: property, rating_year: year }
    let(:form) { FactoryBot.create :rebate_form, property: property, valuation_id: valuation_id, fields: fields }
    let(:fields) { { "income": 39_900.00, "dependants": 1, "full_name": 'Edith' } }

    before { form.calc_rebate_amount! }

    xit { expect(form.rebate).to eq 370.67 }
  end

  describe 'rebate form state machine' do
    let!(:form) { FactoryBot.create :rebate_form, property: property, valuation_id: valuation_id }

    it 'transitions the rebate form between its different states' do
      expect(form.not_signed_state?).to eq true

      form.transition_to_signed_state
      expect(form.signed_state?).to eq true
      expect(form.not_signed_state?).to eq false

      form.transition_to_processed_state
      expect(form.processed_state?).to eq true
      expect(form.signed_state?).to eq false

      form.transition_to_signed_state
      expect(form.signed_state?).to eq true
      expect(form.processed_state?).to eq false

      form.transition_to_not_signed_state
      expect(form.not_signed_state?).to eq true
      expect(form.signed_state?).to eq false
    end
  end
end
