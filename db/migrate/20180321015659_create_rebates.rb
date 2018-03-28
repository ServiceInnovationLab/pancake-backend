class CreateRebates < ActiveRecord::Migration[5.1]
  def change
    create_table :signature_types do |t|
      t.string :name
      t.timestamps
    end

    create_table :signatures do |t|
      t.string :path
      t.references :signature_type
      t.references :rebate_form
      t.timestamps
    end

    create_table :rebate_forms do |t|
      t.string :valuation_id
      t.string :token
      t.timestamps
    end
    add_foreign_key :signatures, :signature_types
    add_foreign_key :signatures, :rebate_forms

  end
end
