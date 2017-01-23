class CreateArcanas < ActiveRecord::Migration[5.0]
  def change
    create_table :arcanas do |t|
      t.string  :name,        null: false, limit: 100
      t.string  :title,       null: false, limit: 100
      t.string  :arcana_type, null: false, limit: 20
      t.integer :rarity,      null: false
      t.integer :cost,        null: false, default: 0
      t.integer :chain_cost,  null: false, default: 0
      t.string  :weapon_type, null: false, limit: 10
      t.string  :job_type,    null: false, limit: 10
      t.integer :job_index,   null: false
      t.string  :job_code,    null: false, limit: 10
      t.string  :job_detail,  null: true,  limit: 50
      t.string  :source_category, null: false, limit: 50
      t.string  :source,          null: false, limit: 50
      t.string  :union,           null: false, limit: 20
      t.string  :person_code,     null: false, limit: 10
      t.string  :owner_code,      null: true,  limit: 10
      t.integer :max_atk,   null: true
      t.integer :max_hp,    null: true
      t.integer :limit_atk, null: true
      t.integer :limit_hp,  null: true
      t.integer :voice_actor_id,    null: false, default: 0
      t.integer :illustrator_id,    null: false, default: 0
      t.timestamps

      t.index :name
      t.index :title
      t.index :arcana_type
      t.index :rarity
      t.index :cost
      t.index :chain_cost
      t.index :weapon_type
      t.index :job_type
      t.index :job_code, unique: true
      t.index [:job_type, :job_index], unique: true
      t.index [:job_type, :rarity]
      t.index :source_category
      t.index [:source_category, :source]
      t.index :union
      t.index [:union, :job_type]
      t.index :person_code
      t.index :voice_actor_id
      t.index :illustrator_id
    end
  end
end
