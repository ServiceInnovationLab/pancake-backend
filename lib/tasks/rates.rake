# frozen_string_literal: true

namespace :rates do
  desc 'Import rates'
  task import: :environment do
    rating_year = '2019'

    council = Council.first
    rates_file = Rails.root.join('db', 'seeds', 'rates_2019.csv')
    importer = RatesImporterService.new
    Property.transaction do
      RatesBill.joins(:property).where("properties.rating_year": rating_year).delete_all
      RatesPayer.joins(:property).where("properties.rating_year": rating_year).delete_all
      Property.where(rating_year: rating_year).delete_all

      row_num = 0
      puts "Loading rates from #{rates_file}..."
      CSV.foreach(rates_file) do |row|
        importer.import(row, council) if row_num.positive?
        row_num += 1
        puts "======================= #{row_num} ====================="
      end
    end
    puts 'Finished loading rates'
  end
end
