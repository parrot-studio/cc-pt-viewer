class Ability < ActiveRecord::Base

  default_scope { includes(:ability_effects) }

  has_many :ability_relations
  has_many :ability_effects, through: :ability_relations

  validates :name,
            presence: true,
            length: { maximum: 100 }
  validates :explanation,
            length: { maximum: 500 }

  def serialize
    ab = attributes
    ab.delete('id')
    ab.delete('created_at')
    ab.delete('updated_at')
    ab['effects'] = ability_effects.map(&:serialize).sort_by { |e| e['condition_type'] } || []
    ab
  end

end
