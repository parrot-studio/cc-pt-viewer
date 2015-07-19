class CreateSkillEffects < ActiveRecord::Migration
  def change
    create_table :skill_effects do |t|
      t.integer :skill_id,    null: false
      t.integer :order,       null: false
      t.string  :category,    null: false, limit: 100
      t.string  :subcategory, null: false, limit: 100
      t.string  :subeffect1,  null: true,  limit: 100
      t.string  :subeffect2,  null: true,  limit: 100
      t.timestamps
    end
    add_index :skill_effects, :skill_id
    add_index :skill_effects, :category
    add_index :skill_effects, :subcategory
    add_index :skill_effects, [:category, :subcategory]
    add_index :skill_effects, :subeffect1
    add_index :skill_effects, :subeffect2
  end
end
