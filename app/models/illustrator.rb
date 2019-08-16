# == Schema Information
#
# Table name: illustrators
#
#  id         :bigint(8)        not null, primary key
#  name       :string(100)      not null
#  count      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_illustrators_on_name  (name) UNIQUE
#

class Illustrator < ApplicationRecord
  has_many :arcanas, inverse_of: :illustrator

  class << self
    def conditions
      ret = []
      self.order(:name).each do |ill|
        ret << [ill.id, ill.name]
      end
      ret
    end
  end

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 100 }
end
