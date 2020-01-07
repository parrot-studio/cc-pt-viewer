# == Schema Information
#
# Table name: skills
#
#  id         :bigint(8)        not null, primary key
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
#  index_skills_on_arcana_id   (arcana_id)
#  index_skills_on_cost        (cost)
#  index_skills_on_job_code    (job_code)
#  index_skills_on_name        (name)
#  index_skills_on_skill_type  (skill_type)
#

class Skill < ApplicationRecord
  belongs_to :arcana, inverse_of: :skills
  has_many   :skill_effects, inverse_of: :skill

  default_scope { includes(:skill_effects) }

  COSTS = (0..3).to_a
  # 伝授スキル
  INHERITABLE_SKILL_TYPE = 'd'.freeze
  # ヒロイックスキル
  HEROIC_SKILL_TYPE = 'h'.freeze
  # 決戦号令
  DECISIVE_ORDER_TYPE = 'kg'.freeze
  # 決戦スキル
  DECISIVE_SKILL_TYPE = 'ks'.freeze

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
  scope :decisive_only, -> { where(skill_type: [DECISIVE_ORDER_TYPE, DECISIVE_SKILL_TYPE]) }

  def serialize
    excepts = %w[id created_at updated_at]
    sk = self.as_json(except: excepts)
    sk['effects'] = skill_effects.sort_by(&:order).map(&:serialize)
    sk
  end
end
