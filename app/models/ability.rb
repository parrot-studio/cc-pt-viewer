# == Schema Information
#
# Table name: abilities
#
#  id           :bigint(8)        not null, primary key
#  arcana_id    :integer          not null
#  job_code     :string(10)       not null
#  ability_type :string(20)       not null
#  name         :string(100)      not null
#  weapon_name  :string(100)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_abilities_on_arcana_id                  (arcana_id)
#  index_abilities_on_job_code                   (job_code)
#  index_abilities_on_job_code_and_ability_type  (job_code,ability_type) UNIQUE
#  index_abilities_on_name                       (name)
#

class Ability < ApplicationRecord
  belongs_to :arcana, inverse_of: :abilities
  has_many   :ability_effects, inverse_of: :ability

  default_scope { includes(:ability_effects) }

  TYPE_NORMAL = %w[1 2 p].freeze
  TYPE_CHAIN = 'c'.freeze
  TYPE_GUNKI = (1..7).map { |n| "g#{n}" }.freeze # デフォルト2＋各ルートクリア5
  TYPE_PASSIVE = 'pa'.freeze
  TYPE_EXTRA = 'e'.freeze

  scope :normal_abilities, -> { where(ability_type: TYPE_NORMAL) }
  scope :chain_abilities, -> { where(ability_type: TYPE_CHAIN) }
  scope :gunki_abilities, -> { where(ability_type: TYPE_GUNKI) }
  scope :passive_abilities, -> { where(ability_type: TYPE_PASSIVE) }
  scope :extra_abilities, -> { where(ability_type: TYPE_EXTRA) }

  validates :job_code,
            presence: true,
            length: { maximum: 10 }
  validates :ability_type,
            presence: true,
            length: { maximum: 20 }
  validates :name,
            length: { maximum: 100 }
  validates :weapon_name,
            allow_nil: true,
            length: { maximum: 100 }

  def serialize
    excepts = %w[id arcana_id job_code ability_type created_at updated_at]
    ab = self.as_json(except: excepts)
    ab['effects'] = ability_effects.sort_by(&:order).map(&:serialize)
    ab
  end
end
