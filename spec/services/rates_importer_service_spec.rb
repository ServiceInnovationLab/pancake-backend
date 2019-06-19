require "rails_helper"

RSpec.describe RatesImporterService do
  let!(:existing_property) { FactoryBot.create(:property_with_rates) }
  let(:tauranga_2018_row) { ["06601*004*01*", "2018", "6/51 CLIFF ROAD", "TAURANGA CENTRAL", "TAURANGA", "3100", "355.32", "1", nil, nil, nil, nil, nil] }
  let(:kapiti_2018_row) { ["1486100100", "2018", "\"83 Reay MacKay Grove, Waikawa Beach\"", nil, nil, "5120.81"] }
  let!(:council) { FactoryBot.create(:council) }
  let!(:rating_year) { '2018' }

  describe 'import data' do
    context "with tauranga2018 data" do
      subject { described_class.new.import(tauranga_2018_row, rating_year, council) }
      it "imports records" do
        expect(Property.count).to eq 1
        expect(RatesBill.count).to eq 1
        subject
        expect(Property.count).to eq 2
        expect(RatesBill.count).to eq 2
      end
    end

    context "kapiti import data" do
      subject { described_class.new.import(kapiti_2018_row, rating_year, council) }
      it "imports records" do
        expect(Property.count).to eq 1
        expect(RatesBill.count).to eq 1
        subject
        expect(Property.count).to eq 2
        expect(RatesBill.count).to eq 2
      end
    end
  end
end
