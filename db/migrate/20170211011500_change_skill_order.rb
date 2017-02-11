class ChangeSkillOrder < ActiveRecord::Migration[5.0]
  def change
    rename_column :skills, :order, :skill_type
    change_column :skills, :skill_type, :string, null: false, limit: 20
  end
end
