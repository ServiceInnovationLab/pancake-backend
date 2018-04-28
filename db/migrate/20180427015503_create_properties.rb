class CreateProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :properties do |t|
      t.text :valuation_id
      t.text :location
      t.text :suburb
      t.text :town_city
      t.text :meta
    end

    create_table :rates_bills do |t|
      t.integer :property_id
      t.text :rating_year
      t.text :total_rates
      t.text :total_water_rates
      t.text :order
      t.text :current_owner_start_date
      t.text :meta
    end

    create_table :rates_payers do |t|
      t.integer :property_id
      t.text :council_owner_id
      t.text :surname
      t.text :first_names
      t.text :meta
    end

    add_index :rates_bills, [:property_id, :rating_year], unique: true
    add_index :properties, :valuation_id, unique: true

    add_foreign_key :rates_bills, :properties
    add_foreign_key :rates_payers, :properties
  end
end
