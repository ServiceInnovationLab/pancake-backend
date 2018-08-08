class AddUpdatedByToRebateForm < ActiveRecord::Migration[5.2]
  def change
    add_column :rebate_forms, :updated_by, :integer
    add_foreign_key :rebate_forms, :users, column: :updated_by
  end
end
