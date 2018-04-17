class AddSignaturesImages < ActiveRecord::Migration[5.1]
  def change
    change_table :signatures do |t|
      t.binary :image
    end
    remove_column :signatures, :path
  end
end
