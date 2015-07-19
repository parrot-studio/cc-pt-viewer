class AddSourceCategory < ActiveRecord::Migration
  def change
    add_column :arcanas, :source_category, :string, null: false, limit: 100
    add_index  :arcanas, :source_category
    add_index  :arcanas, [:source_category, :source]
  end
end
