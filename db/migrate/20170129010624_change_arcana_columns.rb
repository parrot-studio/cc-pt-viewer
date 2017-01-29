class ChangeArcanaColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :arcanas, :owner_code, :link_code
    add_column :arcanas, :wiki_name, :string,
      null: false, limit: 50, after: :illustrator_id
  end
end
