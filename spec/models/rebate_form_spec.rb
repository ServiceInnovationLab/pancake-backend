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
end
