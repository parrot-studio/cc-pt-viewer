class CreateChainAbilities < ActiveRecord::Migration
  def change
    create_table :chain_abilities do |t|
      t.string  :name,           null: false, limit: 100
      t.string  :explanation,                 limit: 500
      t.timestamps
    end
    add_index :chain_abilities, :name, unique: true
  end
end
