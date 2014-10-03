class CreateAbilityRelations < ActiveRecord::Migration
  def change
    create_table :ability_relations do |t|
      t.integer :ability_id       , null: false
      t.integer :ability_effect_id, null: false
      t.timestamps
    end
  end
end
