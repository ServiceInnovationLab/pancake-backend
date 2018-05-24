class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.references :rebate_form
      t.references :user
      t.text :body
      t.timestamps
    end
    add_foreign_key :notes, :rebate_forms
  end
end
