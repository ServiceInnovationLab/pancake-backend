# frozen_string_literal: true

namespace :rates do
  desc 'Import rates'
  task tauranga: :environment do
    council = Council.find_or_create_by(name: 'Tauranga City Council')
    rates_file = Rails.root.join('db', 'seeds', 'tauranga.csv')
    Property.transaction do
      row_num = 0
      puts "Loading rates from #{rates_file}..."

      CSV.foreach(rates_file) do |row|
        importer.import(row, rating_year, council) if row_num.positive?
        row_num += 1
        puts "======================= #{row_num} ====================="
      end
    end
    puts 'Finished loading rates'
    council.update(has_address_lookups: true)
  end

  task kapiti: :environment do
    council = Council.find_or_create_by!(name: 'Kāpiti Coast District Council', short_name: 'kcd', email: '123fake@email.com')
    rates_file = Rails.root.join('db', 'seeds', 'kapiti.csv')

    Property.transaction do
      row_num = 0

      CSV.foreach(rates_file) do |row|
        row[0] = "#{row[0]}-#{row_num}"
        importer.import(row, rating_year, council) if row_num.positive?
        row_num += 1
        puts "======================= #{row_num} ====================="
      end
    end
    puts 'Finished loading rates'
    council.update(has_address_lookups: true)
  end

  private

  def rating_year
    ENV['YEAR']
  end

  def importer
    RatesImporterService.new
  end
end
