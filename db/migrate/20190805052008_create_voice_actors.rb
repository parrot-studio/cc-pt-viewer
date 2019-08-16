class CreateVoiceActors < ActiveRecord::Migration[6.0]
  def change
    create_table :voice_actors do |t|
      t.string  :name,  null: false, limit: 100
      t.integer :count, null: false, default: 0
      t.timestamps

      t.index :name, unique: true
      t.index :count
    end
  end
end
