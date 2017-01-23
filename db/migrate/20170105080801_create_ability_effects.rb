class CreateAbilityEffects < ActiveRecord::Migration[5.0]
  def change
    create_table :ability_effects do |t|
      t.integer :ability_id, null: false
      t.integer :order,      null: false
      t.string  :category,   null: false, limit: 100
      t.string  :condition,  null: false, limit: 100
      t.string  :effect,     null: false, limit: 100
      t.string  :target,     null: false, limit: 100
      t.string  :note,       null: false, limit: 300, default: ''
      t.timestamps

      t.index :ability_id
      t.index :category
      t.index [:category, :condition]
      t.index [:category, :effect]
      t.index [:category, :condition, :effect]
    end
  end
end
