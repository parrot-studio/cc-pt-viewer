class SkillEffect < ActiveRecord::Base
  belongs_to :skill

  validates :order,
            presence: true,
            numericality: { only_integer: true }
  validates :category,
            presence: true,
            length: { maximum: 100 }
  validates :subcategory,
            presence: true,
            length: { maximum: 100 }
  validates :subeffect1,
            length: { maximum: 100 }
  validates :subeffect2,
            length: { maximum: 100 }
  validates :subeffect3,
            length: { maximum: 100 }

  def serialize
    se = attributes
    se.delete('id')
    se.delete('created_at')
    se.delete('updated_at')
    se
  end

end
