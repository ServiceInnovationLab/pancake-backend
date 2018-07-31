class CreateCouncils < ActiveRecord::Migration[5.2]
  def change
    create_table :councils do |t|
      t.string :name
      t.string :short_name
      t.boolean :active
      t.timestamps
    end
    add_column :rebate_forms, :council_id, :integer
    add_column :properties, :council_id, :integer
    # Associate all existing records with Tauranga
    tauranga = Council.create name: 'Tauranga City Council'
    Property.update_all(council_id: tauranga.id)
    RebateForm.update_all(council_id: tauranga.id)
  end
end
