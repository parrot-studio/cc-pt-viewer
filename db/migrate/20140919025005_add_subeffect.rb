class AddSubeffect < ActiveRecord::Migration
  def change
    add_column :skills, :subeffect1, :string, null: true, limit: 100
    add_column :skills, :subeffect2, :string, null: true, limit: 100
    add_index  :skills, :subeffect1
    add_index  :skills, :subeffect2
  end
end
