class AddDiscardedToRebateForms < ActiveRecord::Migration[5.2]
  def change
    add_column :rebate_forms, :discarded_at, :datetime
    add_index :rebate_forms, :discarded_at
  end
end
