class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string  :name,        null: false, limit: 100
      t.string  :category,    null: false, limit: 100
      t.string  :subcategory, null: false, limit: 100
      t.string  :explanation,              limit: 500
      t.integer :cost,        null: false, limit: 3
      t.timestamps
    end
    add_index :skills, :name, unique: true
    add_index :skills, :category
    add_index :skills, [:category, :subcategory]
    add_index :skills, :cost
  end
end
