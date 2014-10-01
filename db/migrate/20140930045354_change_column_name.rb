class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :arcanas, :growth_type, :union
    change_column :arcanas, :union, :string, null: false, limit: 100
  end
end
