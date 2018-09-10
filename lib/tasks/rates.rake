# frozen_string_literal: true

namespace :rates do
  desc 'Import rates'
  task tauranga: :environment do
    council = Council.find_or_create_by(name: 'Tauranga')
    rates_file = Rails.root.join('db', 'seeds', 'rates_2019.csv')
    Property.transaction do
      importer.clear!(rating_year, council)
      row_num = 0
      puts "Loading rates from #{rates_file}..."
      CSV.foreach(rates_file) do |row|
        importer.import(row, rating_year, council) if row_num.positive?
        row_num += 1
        puts "======================= #{row_num} ====================="
      end
    end
    puts 'Finished loading rates'
  end

  task auckland: :environment do
    council = Council.find_or_create_by(name: 'Auckland')
    rates_file = Rails.root.join('db', 'seeds', 'rates_auckland_2019.csv')
    
    Property.transaction do
      importer.clear!(rating_year, council)
      row_num = 0
    #   puts "Loading rates from #{rates_file}..."
      CSV.foreach(rates_file) do |row|
        row[0] = "#{row[0]}-#{row_num}"
        importer.import(row, rating_year, council) if row_num.positive?
        row_num += 1
        puts "======================= #{row_num} ====================="
      end
    end
    puts 'Finished loading rates'
  end

  private

  def rating_year
    ENV['YEAR']
  end

  def importer
    RatesImporterService.new
  end
end
