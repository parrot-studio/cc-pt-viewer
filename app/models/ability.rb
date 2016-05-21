class Ability < ApplicationRecord

  default_scope { includes(:ability_effects) }

  has_many :ability_effects

  validates :name,
            presence: true,
            length: { maximum: 100 }
  validates :explanation,
            length: { maximum: 500 }
  validates :weapon_name,
            length: { maximum: 100 }

  def serialize
    excepts = %w(id created_at updated_at)
    ab = self.as_json(except: excepts)
    ab['effects'] = ability_effects.sort_by(&:order).map(&:serialize)
    ab
  end

end
