class RebateFormHasProperty < ActiveRecord::Migration[5.1]
  def change
    add_column :rebate_forms, :property_id, :integer
    add_foreign_key :rebate_forms, :properties
  end
end
