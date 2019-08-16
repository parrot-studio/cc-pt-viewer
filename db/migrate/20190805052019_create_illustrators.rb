class CreateIllustrators < ActiveRecord::Migration[6.0]
  def change
    create_table :illustrators do |t|
      t.string  :name,  null: false, limit: 100
      t.integer :count, null: false, default: 0
      t.timestamps

      t.index :name, unique: true
    end
  end
end
