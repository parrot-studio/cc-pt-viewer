class CreateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :skills do |t|
      t.integer :arcana_id,    null: false
      t.string  :job_code,     null: false, limit: 10
      t.string  :skill_type,   null: false, limit: 20
      t.string  :name,         null: false, limit: 100
      t.integer :cost,         null: false, default: 0
      t.timestamps

      t.index :arcana_id
      t.index :job_code
      t.index :name
      t.index :cost
      t.index :skill_type
    end
  end
end
