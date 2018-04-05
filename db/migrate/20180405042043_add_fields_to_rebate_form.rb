# frozen_string_literal: true

class AddFieldsToRebateForm < ActiveRecord::Migration[5.1]
  def change
    change_table :rebate_forms do |t|
      t.json :fields
    end
  end
end
