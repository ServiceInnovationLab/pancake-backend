class AddIncludeInAutoSuggestToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :include_in_address_lookups, :boolean, default: false
  end
end
