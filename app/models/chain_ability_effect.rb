class ChainAbilityEffect < ActiveRecord::Base
  belongs_to :chain_abilities

  validates :order,
            presence: true,
            numericality: { only_integer: true }
  validates :category,
            presence: true,
            length: { maximum: 100 }
  validates :condition,
            presence: true,
            length: { maximum: 100 }
  validates :effect,
            presence: true,
            length: { maximum: 100 }
  validates :target,
            presence: true,
            length: { maximum: 100 }
  validates :note,
            length: { maximum: 300 }

  def serialize
    excepts = %w(id chain_ability_id created_at updated_at)
    ef = self.as_json(except: excepts)

    ef['category'] = AbilityEffect::CATEGORYS.fetch(self.category.to_sym, {}).fetch(:name, '')
    ef['condition'] = AbilityEffect::CONDITIONS.fetch(self.condition.to_sym, '')
    ef['effect'] = AbilityEffect::EFFECTS.fetch(self.effect.to_sym, '')
    ef['target'] = AbilityEffect::TARGETS.fetch(self.target.to_sym, '')

    ef
  end

end
