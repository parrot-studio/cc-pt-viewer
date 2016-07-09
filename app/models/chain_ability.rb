# == Schema Information
#
# Table name: chain_abilities
#
#  id          :integer          not null, primary key
#  name        :string(100)      not null
#  explanation :string(500)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_chain_abilities_on_name  (name) UNIQUE
#

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
