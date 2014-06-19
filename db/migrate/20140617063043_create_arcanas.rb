class CreateArcanas < ActiveRecord::Migration
  def change
    create_table :arcanas do |t|
      t.string  :name,      null: false, limit: 100
      t.string  :title,                  limit: 200
      t.integer :rarity,    null: false, limit: 3
      t.string  :job_type,  null: false, limit: 10
      t.integer :job_index, null: false
      t.string  :job_code,  null: false
      t.timestamps
    end
    add_index :arcanas, :name
    add_index :arcanas, :rarity
    add_index :arcanas, :job_type
    add_index :arcanas, :job_code
    add_index :arcanas, [:job_type, :job_index]
    add_index :arcanas, [:job_type, :rarity]
    add_index :arcanas, [:job_type, :rarity, :job_index]
  end
end
