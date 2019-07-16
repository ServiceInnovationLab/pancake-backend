# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch, type: :model do
  describe 'default factory is valid' do
    subject { FactoryBot.create(:batch) }

    it { is_expected.to be_valid }
  end

  describe 'deleting batches'  do
    let(:council) { FactoryBot.create :council }
    let(:batch) { FactoryBot.create :batch, council: council }
    let(:rebate_form) { FactoryBot.create :signed_form }

    it 'does not delete the rebate_form when we delete a batch' do
      rebate_form.update(batch: batch)
      batch.delete
      expect(RebateForm.all).to include rebate_form
    end
  end

  describe 'temporary name' do
    let(:batch) { FactoryBot.create(:batch) }

    it 'should have a temporary name' do
      expect(batch.name).to eq "TEMP-BATCH-ID##{batch.id}"
    end
  end

  describe 'batch validation' do
    describe 'rebate form is from the same council' do
      let(:council) { FactoryBot.create :council }
      let(:batch) { FactoryBot.build(:batch, council: council) }
      let(:property) { FactoryBot.create(:property_with_rates, council: council) }
      let(:rebate_form) { FactoryBot.build(:rebate_form, property: property) }

      before { batch.rebate_forms << rebate_form }

      subject { batch }

      it { is_expected.to be_valid }
    end

    describe 'rebate form is from a different council' do
      # Factorybot will naturally generate a batch and rebate form with
      # different councils
      let(:batch) { FactoryBot.build(:batch) }
      let(:rebate_form) { FactoryBot.build(:rebate_form) }

      before { batch.rebate_forms << rebate_form }

      subject { batch }

      it { is_expected.not_to be_valid }
    end
  end
end
