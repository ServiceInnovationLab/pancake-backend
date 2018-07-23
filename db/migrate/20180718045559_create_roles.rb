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

    dia_role = Role.create name: 'dia', friendly_name: 'Te Tari Taiwhenua'
    rates_team = Role.create name: 'rates', friendly_name: 'Council rates staff'
    frontline = Role.create name: 'frontline', friendly_name: 'Council frontline staff'

    tauranga = Council.find_by(name: 'Tauranga City Council')

    # Put all of Tauranga in Tauranga
    User.where("email like '%@tauranga.govt.nz'").each do |user|
      #user is in Tauranga
      user.update(council: tauranga)
      user.roles << rates_team
    end

    # Give DIA people the DIA role
    User.where("email like '%@dia.govt.nz'").each do |user|
      user.roles << dia_role
    end
  end
end
