class AddGrowthType < ActiveRecord::Migration
  def change
    add_column :arcanas, :growth_type, :string, null: false, limit: 20
    add_index  :arcanas, :growth_type
  end
end
