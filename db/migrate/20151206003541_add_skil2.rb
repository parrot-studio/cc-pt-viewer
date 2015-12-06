class AddSkil2 < ActiveRecord::Migration
  def change
    add_column :arcanas, :skill2_id, :integer, null: false, default: 0,  after: :skill_id
    add_index  :arcanas, :skill2_id
  end
end
