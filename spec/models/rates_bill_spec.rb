# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatesBill, type: :model do
  describe 'calculates entire bill' do
    let(:council) { FactoryBot.create :council }
    let(:property) { FactoryBot.create :property, council: council }
    let(:bill) { FactoryBot.create :rates_bill, total_rates: 100, total_water_rates: 10.4, property: property }

    it { expect(bill.total_bill).to eq '110.40' }
    it { expect(bill.council).to eq council }
  end
end
