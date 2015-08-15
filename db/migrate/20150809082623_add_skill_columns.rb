class AddSkillColumns < ActiveRecord::Migration
  def change
    add_column :skill_effects, :multi_type, :string, limit: 100, null: true, after: :subcategory
    add_column :skill_effects, :multi_condition, :string, limit: 100, null: true, after: :multi_type
    add_column :skill_effects, :subeffect4, :string, limit: 100, null: true, after: :subeffect3
    add_column :skill_effects, :subeffect5, :string, limit: 100, null: true, after: :subeffect4
    add_column :skill_effects, :note,       :string, limit: 100, null: true, after: :subeffect5
    add_index  :skill_effects, :subeffect4
    add_index  :skill_effects, :subeffect5
  end
end
