class CreateAbilityEffects < ActiveRecord::Migration[6.0]
  def change
    create_table :ability_effects do |t|
      t.integer :ability_id,     null: false
      t.integer :order,          null: false
      t.string  :category,       null: false, limit: 100
      t.string  :condition,      null: false, limit: 100
      t.string  :sub_condition,  null: false, limit: 100
      t.string  :condition_note, null: false, limit: 100, default: ''
      t.string  :effect,         null: false, limit: 100
      t.string  :sub_effect,     null: false, limit: 100
      t.string  :effect_note,    null: false, limit: 100, default: ''
      t.string  :target,         null: false, limit: 100
      t.string  :sub_target,     null: false, limit: 100
      t.string  :target_note,    null: false, limit: 100, default: ''
      t.string  :note,           null: false, limit: 300, default: ''
      t.timestamps

      t.index :ability_id
      t.index [:category, :condition, :sub_condition], name: :condition
      t.index [:category, :effect, :sub_effect], name: :effect
      t.index [:category, :target, :sub_target], name: :target
      t.index [:category, :condition, :effect, :target], name: :full
    end
  end
end

