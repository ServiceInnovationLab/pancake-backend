class AllPropertiesInTauranga < ActiveRecord::Migration[5.2]
  def change
    remove_column(:rebate_forms, :council_id, :integer)
    add_column(:properties, :rating_year, :text)

    tauranga = Council.first
    if tauranga
      Property.update_all(council_id: tauranga.id, rating_year: '2018')
      User.update_all(council_id: tauranga.id)
    end

    remove_index :properties, :valuation_id
    add_index :properties, [:valuation_id, :rating_year], unique: true
  end
end
