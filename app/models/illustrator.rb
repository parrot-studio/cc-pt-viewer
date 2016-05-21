class Illustrator < ApplicationRecord

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 100 }

end
