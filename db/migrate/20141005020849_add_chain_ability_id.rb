class AddChainAbilityId < ActiveRecord::Migration
  def change
    add_column :arcanas, :chain_ability_id,  :integer, null: false, default: 0
    add_index  :arcanas, :chain_ability_id
  end
end
