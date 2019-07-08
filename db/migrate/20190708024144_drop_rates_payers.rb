class DropRatesPayers < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :rates_payers, :properties
    drop_table :rates_payers
  end
end
