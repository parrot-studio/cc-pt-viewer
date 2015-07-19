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

  def serialize
    excepts = %w(id created_at updated_at)
    sk = self.as_json(except: excepts)
    sk['effects'] = skill_effects.sort_by(&:order).map(&:serialize)
    sk
  end

end
