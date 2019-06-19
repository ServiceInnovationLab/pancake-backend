class AddHasAddressLookupsToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :has_address_lookups, :boolean, default: false
  end
end
