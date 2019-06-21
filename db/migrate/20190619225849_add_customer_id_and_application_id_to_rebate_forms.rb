class AddCustomerIdAndApplicationIdToRebateForms < ActiveRecord::Migration[5.2]
  def change
    add_column :rebate_forms, :customer_id, :string
    add_column :rebate_forms, :application_id, :string
  end
end
