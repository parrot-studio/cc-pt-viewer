class AddAbilityId < ActiveRecord::Migration
  def change
    add_column :arcanas, :first_ability_id,  :integer, null: false
    add_index  :arcanas, :first_ability_id
    add_column :arcanas, :second_ability_id, :integer, null: false
    add_index  :arcanas, :second_ability_id
  end
end
