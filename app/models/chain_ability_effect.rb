class ChainAbilityEffect < ActiveRecord::Base
  has_many :chain_ability_relations
  has_many :chain_abilities, through: :chain_ability_relations

  validates :condition_type,
    presence: true,
    length: {maximum: 100}
  validates :effect_type,
    presence: true,
    length: {maximum: 100}

  def serialize
    ae = self.attributes
    ae.delete('id')
    ae.delete('created_at')
    ae.delete('updated_at')
    ae
  end

end
