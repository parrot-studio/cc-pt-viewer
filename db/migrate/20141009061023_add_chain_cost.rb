class AddChainCost < ActiveRecord::Migration
  def change
    add_column :arcanas, :chain_cost, :integer, null: false, default: 0
    add_index  :arcanas, :chain_cost
  end
end
