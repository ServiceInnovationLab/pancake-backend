# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatesBill, type: :model do
  describe 'calculates entire bill' do
    let(:council) { FactoryBot.create :council }
    let(:property) { FactoryBot.create :property, council: council, rating_year: '2018' }
    let(:bill) do
      FactoryBot.create :rates_bill, total_rates: 100, total_water_rates: 10.4, property: property, rating_year: property.rating_year
    end

    it { expect(bill.total_bill).to eq '110.40' }
    it { expect(bill.council).to eq council }
  end

end
