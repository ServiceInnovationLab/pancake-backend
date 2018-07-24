class CreateBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :batches do |t|
      t.float :amount
      t.integer :claim_count
      t.text :download_link
      t.references :council
      t.datetime :batch_date

      t.timestamps
    end

    add_column :rebate_forms, :batch_id, :integer
    add_foreign_key :rebate_forms, :batches

    add_index :properties, :council_id
  end
end
