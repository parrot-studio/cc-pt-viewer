# == Schema Information
#
# Table name: voice_actors
#
#  id         :bigint(8)        not null, primary key
#  name       :string(100)      not null
#  count      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_voice_actors_on_count  (count)
#  index_voice_actors_on_name   (name) UNIQUE
#

class VoiceActor < ApplicationRecord
  has_many :arcanas, inverse_of: :voice_actor

  class << self
    def conditions
      ret = []
      self.order(:name).each do |act|
        ret << [act.id, act.name]
      end
      ret
    end
  end

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 100 }
end
