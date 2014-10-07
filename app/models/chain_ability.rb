class ChainAbility < ActiveRecord::Base

  default_scope { includes(:chain_ability_effects) }

  has_many :chain_ability_relations
  has_many :chain_ability_effects, through: :chain_ability_relations

  validates :name,
    presence: true,
    length: {maximum: 100}
  validates :explanation,
    length: {maximum: 500}

  def serialize
    ab = self.attributes
    ab.delete('id')
    ab.delete('created_at')
    ab.delete('updated_at')
    ab['effects'] = self.chain_ability_effects.map(&:serialize) || []
    ab
  end

end
