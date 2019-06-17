require "rails_helper"

RSpec.describe RatesImporterService do
  let!(:existing_property) { FactoryBot.create(:property_with_rates) }
  
  describe 'import taurange data' do
    subject { described_class.new(update_data) }
    let(:update_data) do
      StringIO.new <<~CSV
      valuation,Rating year,Location,Suburb,Town/City,Total Rates,Total Water Rates,Order
      06601*004*01*,2018,6/51 CLIFF ROAD,TAURANGA CENTRAL,TAURANGA,3100,355.32,1
      06601*246*02*AA,2018,B/12/50 CROSS ROAD,SULPHUR POINT,TAURANGA,4374,0,2
      CSV
    end

    context "with tauranga2018 data" do
      it "imports records" do
        expect { subject }.to change(Property, :count).by(2)
      end
    end

    context "kapiti import data" do
      let(:import_data) do
        StringIO.new <<~CSV
        valuation,Rating year,Location,Suburb,Town/City,Total Rates
        1486100100,2018,"""83 Reay MacKay Grove, Waikawa Beach""",,,5120.81
        1486100200,2018,"""Row Otaki Golf Links, Otaki""",,,200.23
        1486100300,2018,"""Row Otaki Golf Links, Otaki""",,,952.25
        
        CSV
      end

      it "imports records" do
        expect { subject }.to change(Property, :count).by(3)
      end
    end

    context "with malformed import data" do
      let(:import_data) { StringIO.new("1,\"23\"4\"5\", 6") }
      it "raises an import error" do
        expect { subject }.to raise_error do |import_err|
          expect(import_err).to be_a CellularDeviceCountImporter::ImportFailed
          expect(import_err.cause).to be_a CsvReader::MalformedCsvError
        end
      end
    end

    context "with missing import columns" do
      let(:import_data) { StringIO.new("Hour,AU2017 Code,Count,Accuracy,SA2 Code\n") }
      it "raises an import error" do
        expect { subject }.to raise_error(
          CellularDeviceCountImporter::ImportFailed,
          "CSV file was missing columns: date"
        )
      end
    end

    context "with the wrong au2017 code" do
      let(:import_data) do
        StringIO.new <<~CSV
          Date,Hour,AU2017 Code,AU2017 Label,Count,Accuracy,SA2 Code
          2018-01-01,0,105,Test AU,100,50
        CSV
      end

      it "raises an import error" do
        expect { subject }.to raise_error do |import_err|
          expect(import_err).to be_a PrecalculatedPopulationDensityImporter::ImportFailed
          expect(import_err.cause).to be_a ActiveRecord::InvalidForeignKey
        end
      end
    end

    context "with the wrong SA2 code" do
      let(:import_data) do
        StringIO.new <<~CSV
          Date,Hour,SA2 Code,Count,Accuracy,AU2017 Code
          2018-01-01,0,0,100,50
        CSV
      end

      it "raises an import error" do
        expect { subject }.to raise_error do |import_err|
          expect(import_err).to be_a PrecalculatedPopulationDensityImporter::ImportFailed
          expect(import_err.cause).to be_a ActiveRecord::InvalidForeignKey
        end
      end
    end

    context "with both AU2017 and SA2 code values" do
      let(:import_data) do
        StringIO.new <<~CSV
          Date,Hour,SA2 Code,Count,Accuracy,AU2017 Code
          2018-01-01,0,0,100,50,0
        CSV
      end

      it "raises an import error" do
        expect { subject }.to raise_error do |import_err|
          expect(import_err).to be_a CellularDeviceCountImporter::ImportFailed
          expect(import_err.message).to start_with "Row contains references to multiple geographic area types"
        end
      end
    end

    context "with invalid records" do
      let(:import_data) do
        StringIO.new <<~CSV
          Date,Hour,AU2017 Code,AU2017 Label,Count,Accuracy,SA2 Code
          2018-01-01,0,#{area_unit.code},Test AU,100,
        CSV
      end

      it "raises an import error" do
        expect { subject }.to raise_error do |import_err|
          expect(import_err).to be_a PrecalculatedPopulationDensityImporter::ImportFailed
          expect(import_err.cause).to be_a ActiveRecord::RecordInvalid
        end
      end
    end
  end
end
