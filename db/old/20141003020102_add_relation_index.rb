class AddRelationIndex < ActiveRecord::Migration
  def change
    add_index  :ability_relations, :ability_id
    add_index  :ability_relations, :ability_effect_id
    add_index  :ability_relations, [:ability_id, :ability_effect_id]
  end
end
