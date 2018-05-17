class AddRebateToApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :rebate_forms, :rebate, :decimal, precision: 8, scale: 2

    rename_column :rates_bills, :total_rates, :old_total_rates
    rename_column :rates_bills, :total_water_rates, :old_total_water_rates
    add_column :rates_bills, :total_rates, :decimal, precision: 8, scale: 2
    add_column :rates_bills, :total_water_rates, :decimal, precision: 8, scale: 2
    ActiveRecord::Base.connection.execute(
      "UPDATE rates_bills SET
      total_rates=cast(old_total_rates as double precision), total_water_rates=cast(old_total_water_rates as double precision)")

  end
end

