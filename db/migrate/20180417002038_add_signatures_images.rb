class AddSignaturesImages < ActiveRecord::Migration[5.1]
  def change
    add_column :signatures, :image, :binary
    remove_column :signatures, :path, :text
  end
end
