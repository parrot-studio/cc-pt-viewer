# == Schema Information
#
# Table name: illustrators
#
#  id         :integer          not null, primary key
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

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 100 }

end
