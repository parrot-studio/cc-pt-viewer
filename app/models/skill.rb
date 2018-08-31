# == Schema Information
#
# Table name: skills
#
#  id         :integer          not null, primary key
#  arcana_id  :integer          not null
#  job_code   :string(10)       not null
#  skill_type :string(20)       not null
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

  COSTS = (0..3).to_a
  INHERITABLE_SKILL_TYPE = 'd'.freeze
  HEROIC_SKILL_TYPE = 'h'.freeze

  validates :job_code,
            presence: true,
            length: { maximum: 10 }
  validates :skill_type,
            presence: true,
            length: { maximum: 20 }
  validates :name,
            presence: true,
            length: { maximum: 100 }
  validates :cost,
            presence: true,
            numericality: { only_integer: true }

  scope :inheritable_only, -> { where(skill_type: INHERITABLE_SKILL_TYPE) }
  scope :heroic_only, -> { where(skill_type: HEROIC_SKILL_TYPE) }

  def serialize
    excepts = %w[id created_at updated_at]
    sk = self.as_json(except: excepts)
    sk['effects'] = skill_effects.sort_by(&:order).map(&:serialize)
    sk
  end
end
