# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatesPayer, type: :model do
  let(:rates_payer) { FactoryBot.create :rates_payer }

  describe 'belongs to a council' do
    it { expect(rates_payer.council).to eq(rates_payer.property.council) }
  end
end
