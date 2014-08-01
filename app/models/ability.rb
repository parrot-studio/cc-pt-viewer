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
  validates :explanation,
    length: {maximum: 500}

end
