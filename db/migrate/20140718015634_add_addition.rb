class AddAddition < ActiveRecord::Migration
  def change
    add_column :arcanas, :addition, :string, null: false, limit: 20
    add_index  :arcanas, :addition
  end
end
