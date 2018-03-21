class CreateRebates < ActiveRecord::Migration[5.1]
  def change
    create_table :rebate_forms do |t|
      t.text :valuation_id
      t.text :token
      t.json :payload
      t.timestamps
    end
    create_table :signatures do |t|
      t.references :rebate
      t.timestamps
    end
  end
end
