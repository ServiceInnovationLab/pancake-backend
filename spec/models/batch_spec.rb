# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch, type: :model do
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
end
