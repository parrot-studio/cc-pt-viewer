# == Schema Information
#
# Table name: chain_ability_effects
#
#  id               :integer          not null, primary key
#  chain_ability_id :integer          not null
#  order            :integer          not null
#  category         :string(100)      not null
#  condition        :string(100)      not null
#  effect           :string(100)      not null
#  target           :string(100)      not null
#  note             :string(300)      default("")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_chain_ability_effects_on_category                (category)
#  index_chain_ability_effects_on_category_and_condition  (category,condition)
#  index_chain_ability_effects_on_category_and_effect     (category,effect)
#  index_chain_ability_effects_on_chain_ability_id        (chain_ability_id)
#  index_chain_ability_effects_on_condition               (condition)
#  index_chain_ability_effects_on_condition_and_effect    (condition,effect)
#  index_chain_ability_effects_on_effect                  (effect)
#  index_chain_ability_effects_on_target                  (target)
#

class ChainAbilityEffect < ApplicationRecord
  belongs_to :chain_ability

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
