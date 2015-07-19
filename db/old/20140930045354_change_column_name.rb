class ChangeColumnName < ActiveRecord::Migration
  def change
    remove_index  :arcanas, :growth_type
    rename_column :arcanas, :growth_type, :union
    change_column :arcanas, :union, :string, null: false, limit: 100
    add_index     :arcanas, :union
  end
end
