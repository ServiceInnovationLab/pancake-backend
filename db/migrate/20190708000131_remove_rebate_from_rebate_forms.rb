class RemoveRebateFromRebateForms < ActiveRecord::Migration[5.2]
  def change
    remove_column :rebate_forms, :rebate, :decimal, precision: 8, scale: 2
  end
end
