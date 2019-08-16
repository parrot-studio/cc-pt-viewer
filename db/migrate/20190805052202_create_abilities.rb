class CreateAbilities < ActiveRecord::Migration[6.0]
  def change
    create_table :abilities do |t|
      t.integer :arcana_id,    null: false
      t.string  :job_code,     null: false, limit: 10
      t.string  :ability_type, null: false, limit: 20
      t.string  :name,         null: false, limit: 100
      t.string  :weapon_name,  null: true,  limit: 100
      t.timestamps

      t.index :arcana_id
      t.index :job_code
      t.index [:job_code, :ability_type], unique: true
      t.index :name
    end
  end
end
