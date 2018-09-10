class AddEmailAddressToCouncil < ActiveRecord::Migration[5.2]
  def change
    add_column :councils, :email, :text
  end
end
