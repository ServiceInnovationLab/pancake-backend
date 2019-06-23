class AddTotalRatesLocationToRebateForm < ActiveRecord::Migration[5.2]
  def up
    add_column :rebate_forms, :location, :string
    add_column :rebate_forms, :total_rates, :decimal, precision: 8, scale: 2
    update_existing_rebate_forms_up
  end

  def down
    remove_column :rebate_forms, :location, :string
    remove_column :rebate_forms, :total_rates, :decimal, precision: 8, scale: 2
  end
end
