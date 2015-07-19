class RemoveEffectsInAbility < ActiveRecord::Migration
  def change
    remove_index :abilities, :condition_type
    remove_index :abilities, :effect_type
    remove_index :abilities, :condition_type_second
    remove_index :abilities, :effect_type_second
    remove_index :abilities, [:condition_type, :effect_type]
    remove_index :abilities, [:condition_type_second, :effect_type_second]
    remove_column :abilities, :condition_type
    remove_column :abilities, :effect_type
    remove_column :abilities, :condition_type_second
    remove_column :abilities, :effect_type_second
  end
end
