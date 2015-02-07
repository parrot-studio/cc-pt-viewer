class AddSkillSubEffect < ActiveRecord::Migration
  def change
    add_column :skill_effects, :subeffect3, :string, null: true, limit: 100
    add_index  :skill_effects, :subeffect3
  end
end
