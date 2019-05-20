class RemoveUniqueConstraintFromPropertyIndexes < ActiveRecord::Migration[5.2]
  def change
    remove_index :properties, [:valuation_id, :rating_year]
    add_index :properties, [:valuation_id, :rating_year], unique: false
  end
end
