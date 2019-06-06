class AddNameToBatch < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :name, :string
  end
end
