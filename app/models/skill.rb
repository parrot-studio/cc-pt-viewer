class Skill < ActiveRecord::Base

  COSTS = (1..3).to_a

  validates :name,
    presence: true,
    length: {maximum: 100}
  validates :category,
    presence: true,
    length: {maximum: 100}
  validates :subcategory,
    presence: true,
    length: {maximum: 100}
  validates :explanation,
    length: {maximum: 500}
  validates :cost,
    presence: true,
    numericality: {only_integer: true}
  validates :subeffect1,
    length: {maximum: 100}
  validates :subeffect2,
    length: {maximum: 100}

  def serialize
    sk = self.attributes
    sk.delete('id')
    sk.delete('created_at')
    sk.delete('updated_at')
    sk
  end

end
