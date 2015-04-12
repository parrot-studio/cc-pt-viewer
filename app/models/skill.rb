class Skill < ActiveRecord::Base
  default_scope { includes(:skill_effects) }
  has_many :skill_effects

  COSTS = (1..3).to_a

  validates :name,
            presence: true,
            length: { maximum: 100 }
  validates :explanation,
            length: { maximum: 500 }
  validates :cost,
            presence: true,
            numericality: { only_integer: true }

  def effects
    skill_effects.sort_by(&:order)
  end

  def serialize
    sk = attributes
    sk.delete('id')
    sk.delete('created_at')
    sk.delete('updated_at')
    sk['effects'] = effects.map(&:serialize)
    sk
  end

end
