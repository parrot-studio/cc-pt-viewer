class AddVoiceActorId < ActiveRecord::Migration
  def change
    add_column :arcanas, :voice_actor_id, :integer, null: false
    add_index  :arcanas, :voice_actor_id
  end
end
