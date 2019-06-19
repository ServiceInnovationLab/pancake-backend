class RemoveAddresLookupsColumnFromPropertyAndAddToCouncil < ActiveRecord::Migration[5.2]
  def change
    remove_column :properties, :has_address_lookups, :boolean, default: false
    add_column :councils, :has_address_lookups, :boolean, default: false
  end
end
