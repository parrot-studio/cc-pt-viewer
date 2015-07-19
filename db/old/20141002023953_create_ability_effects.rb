class CreateAbilityEffects < ActiveRecord::Migration
  def change
    create_table :ability_effects do |t|
      t.string  :condition_type, null: false, limit: 100
      t.string  :effect_type,    null: false, limit: 100
      t.timestamps
    end
    add_index :ability_effects, :condition_type
    add_index :ability_effects, :effect_type
    add_index :ability_effects, [:condition_type, :effect_type]
  end
end
