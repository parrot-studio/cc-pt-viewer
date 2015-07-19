class AddIdDefault < ActiveRecord::Migration
  def change
    change_column_default :arcanas, :voice_actor_id, 0
    change_column_default :arcanas, :illustrator_id, 0
    change_column_default :arcanas, :skill_id,       0
    change_column_default :arcanas, :first_ability_id,  0
    change_column_default :arcanas, :second_ability_id, 0
  end
end
