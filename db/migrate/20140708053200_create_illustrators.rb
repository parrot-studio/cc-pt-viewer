class CreateIllustrators < ActiveRecord::Migration
  def change
    create_table :illustrators do |t|
      t.string  :name,  null: false, limit: 100
      t.integer :count, null: false, default: 0
      t.timestamps
    end
    add_index :illustrators, :name, unique: true
  end
end
