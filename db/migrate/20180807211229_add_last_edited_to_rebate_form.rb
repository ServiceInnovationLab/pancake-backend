class AddLastEditedToRebateForm < ActiveRecord::Migration[5.2]
  def change
    add_column :rebate_forms, :last_edited, :string
  end
end
