class ChainAbility < ApplicationRecord

  default_scope { includes(:chain_ability_effects) }

  has_many :chain_ability_effects

  validates :name,
            presence: true,
            length: { maximum: 100 }
  validates :explanation,
            length: { maximum: 500 }

  def serialize
    excepts = %w(id created_at updated_at)
    ab = self.as_json(except: excepts)
    ab['effects'] = chain_ability_effects.sort_by(&:order).map(&:serialize)
    ab
  end

end
