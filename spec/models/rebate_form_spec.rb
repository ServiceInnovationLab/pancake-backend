# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RebateForm, type: :model do
  let(:valuation_id) { 'abc' }
  let(:property) { FactoryBot.create :property, valuation_id: valuation_id }

  describe 'Unsigned form' do
    let(:form) { FactoryBot.create :rebate_form, property: property, valuation_id: valuation_id }

    describe 'has no signatures' do
      it { expect(form.signatures.size).to eq 0 }
    end
  end

  describe 'Signed form' do
    let(:form) { FactoryBot.create :signed_form, property: property, valuation_id: valuation_id }
    describe 'factorybot makes both signatures' do
      it { expect(form.signatures.size).to eq 2 }
    end
    it { expect(form.completed).to eq true }
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
    let!(:rates_bill) { FactoryBot.create :rates_bill, total_rates: 3450, total_water_rates: 5, property: property, rating_year: ENV['YEAR'] }
    let(:form) { FactoryBot.create :rebate_form, property: property, valuation_id: valuation_id, fields: fields }
    let(:fields) { { "income": 39_900.00, "dependants": 1, "full_name": 'Edith' } }

    before { form.calc_rebate_amount! }

    it { expect(form.rebate).to eq 370.67 }
  end

  describe 'signed scopes' do
    let!(:signed_form) do
      FactoryBot.create :rebate_form, property: property, valuation_id: valuation_id,
                                      signatures: [FactoryBot.create(:applicant_signature)]
    end
    let!(:witnessed_form) do
      FactoryBot.create :rebate_form, property: property, valuation_id: valuation_id,
                                      signatures: [FactoryBot.create(:witness_signature)]
    end
    let!(:fully_signed_form) do
      FactoryBot.create :rebate_form, property: property, valuation_id: valuation_id,
                                      signatures: [FactoryBot.create(:applicant_signature), FactoryBot.create(:witness_signature)]
    end
    # describe "signed" do
    #   it { expect(RebateForm.signed).to include(signed_form)}
    #   it { expect(RebateForm.signed).to include(fully_signed_form)}
    #   it { expect(RebateForm.signed).not_to include(witnessed_form)}
    # end
    # describe "witnessed" do
    #   it { expect(RebateForm.witnessed).to include(witnessed_form)}
    #   it { expect(RebateForm.witnessed).to include(fully_signed_form)}
    #   it { expect(RebateForm.witnessed).not_to include(signed_form)}
    # end
    # describe "fully signed" do
    #   it { expect(RebateForm.signed_and_witnessed).to include(fully_signed_form)}
    #   it { expect(RebateForm.signed_and_witnessed).not_to include(signed_form)}
    #   it { expect(RebateForm.signed_and_witnessed).not_to include(witnessed_form)}
    # end
  end
end
