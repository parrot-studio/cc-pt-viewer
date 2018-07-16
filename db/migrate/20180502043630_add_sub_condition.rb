class AddSubCondition < ActiveRecord::Migration[5.2]
  def change
    add_column :ability_effects, :sub_condition, :string,
               null: false, limit: 100, after: :condition
    add_column :ability_effects, :sub_effect, :string,
               null: false, limit: 100, after: :effect
    add_column :ability_effects, :sub_target, :string,
               null: false, limit: 100, after: :target
  end
end
