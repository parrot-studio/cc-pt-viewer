class CreateVoiceActors < ActiveRecord::Migration
  def change
    create_table :voice_actors do |t|
      t.string  :name,  null: false, limit: 100
      t.integer :count, null: false, default: 0
      t.timestamps
    end
    add_index :voice_actors, :name, unique: true
    add_index :voice_actors, :count
  end
end
