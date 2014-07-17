class AddSkillId < ActiveRecord::Migration
  def change
    add_column :arcanas, :skill_id, :integer, null: false
    add_index  :arcanas, :skill_id
  end
end
