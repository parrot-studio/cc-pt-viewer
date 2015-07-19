class RemoveHometown < ActiveRecord::Migration
  def change
    remove_index  :arcanas, :hometown
    remove_index  :arcanas, [:job_type, :hometown]
    remove_index  :arcanas, [:hometown, :rarity]
    remove_column :arcanas, :hometown
  end
end
