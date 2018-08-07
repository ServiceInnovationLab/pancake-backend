class AddUpdatedByToRebateForm < ActiveRecord::Migration[5.2]
  def change
    add_column :rebate_forms, :updated_by, :string
  end
end
