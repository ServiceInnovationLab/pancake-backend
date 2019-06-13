class AddCoverSheetAttachedFieldToBatch < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :cover_sheet_attached, :boolean, default: false
  end
end
