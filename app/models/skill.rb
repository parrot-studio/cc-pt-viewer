# == Schema Information
#
# Table name: skills
#
#  id         :integer          not null, primary key
#  arcana_id  :integer          not null
#  job_code   :string(10)       not null
#  order      :integer          not null
#  name       :string(100)      not null
#  cost       :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_skills_on_arcana_id  (arcana_id)
#  index_skills_on_cost       (cost)
#  index_skills_on_job_code   (job_code)
#  index_skills_on_name       (name)
#

class Skill < ApplicationRecord
  default_scope { includes(:skill_effects) }
  has_many :skill_effects

  COSTS = (1..3).to_a

  validates :job_code,
            presence: true,
            length: { maximum: 10 }
  validates :order,
            presence: true,
            numericality: { only_integer: true }
  validates :name,
            presence: true,
            length: { maximum: 100 }
  validates :cost,
            presence: true,
            numericality: { only_integer: true }

  def serialize
    excepts = %w(id created_at updated_at)
    sk = self.as_json(except: excepts)
    sk['effects'] = skill_effects.sort_by(&:order).map(&:serialize)
    sk
  end
end
