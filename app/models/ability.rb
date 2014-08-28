class Ability < ActiveRecord::Base

  validates :name,
    presence: true,
    length: {maximum: 100}
  validates :condition_type,
    presence: true,
    length: {maximum: 100}
  validates :effect_type,
    presence: true,
    length: {maximum: 100}
  validates :condition_type_second,
    length: {maximum: 100}
  validates :effect_type_second,
    length: {maximum: 100}
  validates :explanation,
    length: {maximum: 500}

  def serialize
    ab = self.attributes
    ab.delete('id')
    ab.delete('created_at')
    ab.delete('updated_at')
    ab
  end

end
