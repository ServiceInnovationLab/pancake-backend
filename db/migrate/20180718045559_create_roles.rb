class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :council_id, :integer

    create_table :roles do |t|
      t.string :name, null: false
      t.string :friendly_name, null: false
      t.timestamps null: false
    end

    add_index :roles, :name, unique: true

    create_table :roles_users do |t|
      t.belongs_to :user, index: true, null: false
      t.belongs_to :role, index: true, null: false
    end

    dia_role = Role.find_or_create_by name: 'dia', friendly_name: 'Te Tari Taiwhenua'
    rates_team = Role.find_or_create_by name: 'rates', friendly_name: 'Council rates staff'
    frontline = Role.find_or_create_by name: 'frontline', friendly_name: 'Council frontline staff'
  end
end
