class AbilityEffect < ActiveRecord::Base
  has_many :ability_relations
  has_many :abilities, through: :ability_relations

  validates :condition_type,
            presence: true,
            length: { maximum: 100 }
  validates :effect_type,
            presence: true,
            length: { maximum: 100 }

  def serialize
    ae = attributes
    ae.delete('id')
    ae.delete('created_at')
    ae.delete('updated_at')
    ae
  end

end
