# frozen_string_literal: true

require 'csv'

SignatureType.find_or_create_by! name: 'applicant'
SignatureType.find_or_create_by! name: 'witness'

['brenda.wallace', 'dana.iti'].each do |name|
  email = "#{name}@dia.govt.nz"
  User.invite! email: email unless User.find_by(email: email)
end

def load_rates!
  rates_file = Rails.root.join('db', 'seeds', 'rates.csv')

  Property.transaction do
    row_num = 0
    puts "Loading rates from #{rates_file}..."
    CSV.foreach(rates_file) do |row|
      RatesImporter.new.import(row) if row_num.positive?
      row_num += 1
    end
  end
  puts 'Finished loading rates'
end

class RatesImporter
  def import(row) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    valuation, rating_year, location, suburb, town_city,
      total_rates, total_water_rates, order, council_owner_id,
      surname, first_names, current_owner_start_date = row
    property = Property.find_by(valuation_id: valuation)
    if property.blank?
      property = Property.create!(
        valuation_id: valuation,
        location: location,
        suburb: suburb,
        town_city: town_city,
        meta: row.to_s
      )
    end

    rates_bill = RatesBill.find_by(property: property, rating_year: rating_year)
    if rates_bill.present?
      raise 'mismatch' unless rates_bill.total_rates == total_rates
      raise 'mismatch' unless rates_bill.total_water_rates == total_water_rates
      raise 'mismatch' unless rates_bill.current_owner_start_date == current_owner_start_date
    else
      RatesBill.create!(
        property: property,
        rating_year: rating_year,
        total_rates: total_rates,
        total_water_rates: total_water_rates,
        current_owner_start_date: current_owner_start_date
      )
    end

    # rate_payer = RatesPayer.find_by(
    #   council_owner_id: council_owner_id,
    #   first_names: first_names,
    #   surname: surname,
    #   property: property
    # )
    # if rate_payer.blank? # rubocop:disable Style/GuardClause
    #   RatesPayer.create!(
    #     council_owner_id: council_owner_id,
    #     first_names: first_names,
    #     surname: surname,
    #     property: property
    #   )
    # end
  end
end

load_rates!
