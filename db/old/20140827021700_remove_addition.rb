class RemoveAddition < ActiveRecord::Migration
  def change
    remove_index  :arcanas, :addition
    remove_column :arcanas, :addition
  end
end
