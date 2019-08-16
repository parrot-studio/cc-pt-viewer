class CreateSkillEffects < ActiveRecord::Migration[6.0]
  def change
    create_table :skill_effects do |t|
      t.integer :skill_id, null: false
      t.integer :order,    null: false
      t.string  :category,        null: false, limit: 100
      t.string  :subcategory,     null: false, limit: 100
      t.string  :multi_type,      null: true,  limit: 100
      t.string  :multi_condition, null: true,  limit: 100
      t.string  :subeffect1, null: true,  limit: 100
      t.string  :subeffect2, null: true,  limit: 100
      t.string  :subeffect3, null: true,  limit: 100
      t.string  :subeffect4, null: true,  limit: 100
      t.string  :subeffect5, null: true,  limit: 100
      t.string  :note,       null: true,  limit: 100
      t.timestamps

      t.index :skill_id
      t.index :category
      t.index [:category, :subcategory]
      t.index :subeffect1
      t.index :subeffect2
      t.index :subeffect3
      t.index :subeffect4
      t.index :subeffect5
    end
  end
end
