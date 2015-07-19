class AddAbilityEffect < ActiveRecord::Migration
  def change
    add_column :abilities, :condition_type_second, :string, null: true, limit: 100
    add_column :abilities, :effect_type_second,    :string, null: true, limit: 100
    add_index  :abilities, :condition_type_second
    add_index  :abilities, :effect_type_second
    add_index  :abilities, [:condition_type_second, :effect_type_second]
  end
end
