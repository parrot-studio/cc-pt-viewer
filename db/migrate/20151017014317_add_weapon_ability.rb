class AddWeaponAbility < ActiveRecord::Migration
  def change
    add_column :arcanas, :weapon_ability_id, :integer, null: false, default: 0, after: :second_ability_id
    add_column :abilities, :weapon_name, :string, null: true, limit: 100, after: :explanation
    add_index  :arcanas, :weapon_ability_id
  end
end
