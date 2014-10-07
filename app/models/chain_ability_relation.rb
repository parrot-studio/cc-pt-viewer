class ChainAbilityRelation < ActiveRecord::Base
  belongs_to :chain_ability
  belongs_to :chain_ability_effect
end
