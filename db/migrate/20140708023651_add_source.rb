class AddSource < ActiveRecord::Migration
  def change
    add_column :arcanas, :source, :string, null: false, limit: 100
    add_index  :arcanas, :source
  end
end
