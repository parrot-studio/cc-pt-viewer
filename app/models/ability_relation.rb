class AbilityRelation < ActiveRecord::Base
  belongs_to :ability
  belongs_to :ability_effect
end
