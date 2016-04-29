class AddThirdSkill < ActiveRecord::Migration
  def change
    remove_index  :arcanas, :skill2_id
    remove_index  :arcanas, :skill_id
    rename_column :arcanas, :skill_id,  :first_skill_id
    rename_column :arcanas, :skill2_id, :second_skill_id
    add_column    :arcanas, :third_skill_id, :integer, null: false, default: 0, after: :second_skill_id
    add_index     :arcanas, :first_skill_id
    add_index     :arcanas, :second_skill_id
    add_index     :arcanas, :third_skill_id
  end
end
