class ReplaceAbilityTables < ActiveRecord::Migration
  def change
    drop_table :ability_relations do
    end
    drop_table :chain_ability_relations do
    end

    add_column :ability_effects, :ability_id, :integer, null: false, after: :id
    add_column :ability_effects, :order,      :integer, null: false, after: :ability_id
    add_column :ability_effects, :category,   :string,  limit: 100, null: false, after: :order
    add_column :ability_effects, :target,     :string,  limit: 100, null: false, after: :effect_type
    add_column :ability_effects, :note,       :string,  limit: 300, null: true,  default: '', after: :target

    add_index  :ability_effects, :ability_id
    add_index  :ability_effects, :category
    add_index  :ability_effects, :target
    add_index  :ability_effects, [:category, :condition_type]
    add_index  :ability_effects, [:category, :effect_type]

    rename_column :ability_effects, :condition_type, :condition
    rename_column :ability_effects, :effect_type,    :effect

    add_column :chain_ability_effects, :chain_ability_id, :integer, null: false, after: :id
    add_column :chain_ability_effects, :order,      :integer, null: false, after: :chain_ability_id
    add_column :chain_ability_effects, :category,   :string,  limit: 100, null: false, after: :order
    add_column :chain_ability_effects, :target,     :string,  limit: 100, null: false, after: :effect_type
    add_column :chain_ability_effects, :note,       :string,  limit: 300, null: true,  default: '', after: :target

    add_index  :chain_ability_effects, :chain_ability_id
    add_index  :chain_ability_effects, :category
    add_index  :chain_ability_effects, :target
    add_index  :chain_ability_effects, [:category, :condition_type]
    add_index  :chain_ability_effects, [:category, :effect_type]

    rename_column :chain_ability_effects, :condition_type, :condition
    rename_column :chain_ability_effects, :effect_type,    :effect
  end
end
