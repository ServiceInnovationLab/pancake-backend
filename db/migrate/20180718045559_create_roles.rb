class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    add_column :users, :role_id, :integer
    add_column :users, :council_id, :integer

    Role.create name: 'dia'
    User.with_deleted.update_all(
      role_id: (Role.create name: 'council').id,
      council_id: (Council.find_by(name: 'Tauranga City Council').id)
    )
  end
end
