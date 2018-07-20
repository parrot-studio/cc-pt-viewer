class AddAbilitiesNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :ability_effects, :condition_note, :string,
               null: false, limit: 100, after: :sub_condition
    add_column :ability_effects, :effect_note, :string,
               null: false, limit: 100, after: :sub_effect
    add_column :ability_effects, :target_note, :string,
               null: false, limit: 100, after: :sub_target
  end
end
