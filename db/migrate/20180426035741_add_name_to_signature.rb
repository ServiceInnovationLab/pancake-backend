class AddNameToSignature < ActiveRecord::Migration[5.1]
  def change
    add_column :signatures, :name, :text
    add_column :signatures, :role, :text

    add_index :signature_types, :name, unique: true
  end
end
