class AddArcanaProperty < ActiveRecord::Migration
  def change
    add_column :arcanas, :max_atk,    :integer, null: true, limit: 6
    add_column :arcanas, :max_hp,     :integer, null: true, limit: 6
    add_column :arcanas, :limit_atk,  :integer, null: true, limit: 6
    add_column :arcanas, :limit_hp,   :integer, null: true, limit: 6
    add_column :arcanas, :job_detail, :string,  null: true, limit: 50
    add_index  :arcanas, :max_atk
    add_index  :arcanas, :max_hp
    add_index  :arcanas, :limit_atk
    add_index  :arcanas, :limit_hp
  end
end
