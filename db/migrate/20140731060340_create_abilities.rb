class CreateAbilities < ActiveRecord::Migration
  def change
    create_table :abilities do |t|
      t.string  :name,           null: false, limit: 100
      t.string  :condition_type, null: false, limit: 100
      t.string  :effect_type,    null: false, limit: 100
      t.string  :explanation,                 limit: 500
      t.timestamps
    end
    add_index :abilities, :name, unique: true
    add_index :abilities, :condition_type
    add_index :abilities, :effect_type
    add_index :abilities, [:condition_type, :effect_type]
  end
end
