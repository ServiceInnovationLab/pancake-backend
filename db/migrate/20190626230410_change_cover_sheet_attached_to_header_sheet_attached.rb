class ChangeCoverSheetAttachedToHeaderSheetAttached < ActiveRecord::Migration[5.2]
  def change
    rename_column :batches, :cover_sheet_attached, :header_sheet_attached
  end
end
