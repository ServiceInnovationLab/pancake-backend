# frozen_string_literal: true

class RatesImporterService
  def import(row, council)
    puts row
    valuation, _rating_year, location, suburb, town_city,
      total_rates, total_water_rates, _order, _council_owner_id,
      _surname, _first_names, _confidential, current_owner_start_date = row

    if total_rates.blank?
      puts 'SKIPPING blank rates record'
      return
    end

    rating_year = '2019'

    property = Property.find_by(valuation_id: valuation, rating_year: rating_year)
    if property.blank?
      property = Property.create!(
        council: council,
        valuation_id: valuation,
        location: location,
        suburb: suburb,
        town_city: town_city,
        rating_year: rating_year,
        meta: row.to_s
      )
    end

    rates_bill = RatesBill.find_by(property: property, rating_year: rating_year)
    if rates_bill.present?
      raise 'mismatch total_rates' unless rates_bill.total_rates.to_f == total_rates.to_f
      raise 'mismatch total_water_rates' unless rates_bill.total_water_rates.to_f == total_water_rates.to_f
      raise 'mismatch current_owner_start_date' unless rates_bill.current_owner_start_date == current_owner_start_date
    else
      RatesBill.create!(
        property: property,
        rating_year: rating_year,
        total_rates: total_rates,
        total_water_rates: total_water_rates,
        current_owner_start_date: current_owner_start_date
      )
    end
  end
end
