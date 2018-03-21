class CreateRebates < ActiveRecord::Migration[5.1]
  def change
    create_table :rebate_forms do |t|
      t.text :valuation_id
      t.text :token
      t.json :payload
      t.timestamps
    end
    create_table :signature_types do |t|
      t.text :name
      t.text :description
      t.timestamps
    end
    create_table :signatures do |t|
      t.references :signature_type
      t.references :rebate_form
      t.timestamps
    end
    add_foreign_key :signatures, :signature_types
    add_foreign_key :signatures, :rebate_forms
  end
end
