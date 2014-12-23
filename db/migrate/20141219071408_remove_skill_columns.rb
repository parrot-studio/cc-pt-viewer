class RemoveSkillColumns < ActiveRecord::Migration
  def change
    remove_index :skills, :category
    remove_index :skills, [:category, :subcategory]
    remove_index :skills, :subeffect1
    remove_index :skills, :subeffect2
    remove_column :skills, :category
    remove_column :skills, :subcategory
    remove_column :skills, :subeffect1
    remove_column :skills, :subeffect2
  end
end
