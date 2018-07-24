class RebateCompletedDefaultToFalse < ActiveRecord::Migration[5.2]
  def up
    change_column :rebate_forms, :completed, :boolean, default: true
  end

  def down
    change_column :rebate_forms, :completed, :boolean, default: nil
  end
end
