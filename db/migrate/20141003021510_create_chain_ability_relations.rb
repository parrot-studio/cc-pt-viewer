class CreateChainAbilityRelations < ActiveRecord::Migration
  def change
    create_table :chain_ability_relations do |t|
      t.integer :chain_ability_id,  null: false
      t.integer :chain_ability_effect_id, null: false
      t.timestamps
    end
    add_index  :chain_ability_relations, :chain_ability_id
    add_index  :chain_ability_relations, :chain_ability_effect_id
    add_index  :chain_ability_relations,
               [:chain_ability_id, :chain_ability_effect_id],
               name: 'chain_ability_relations_index'
  end
end
