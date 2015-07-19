class AddIllustratorId < ActiveRecord::Migration
  def change
    add_column :arcanas, :illustrator_id, :integer, null: false
    add_index  :arcanas, :illustrator_id
  end
end
