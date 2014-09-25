class Arcana < ActiveRecord::Base

  default_scope { includes([:voice_actor, :illustrator, :skill, :first_ability, :second_ability]) }

  JOB_TYPES = ServerSettings.job_types.freeze
  RARITYS = (1..(ServerSettings.rarity)).freeze
  WEAPON_TYPES = ServerSettings.weapon_types.freeze
  GROWTH_TYPES = ServerSettings.growth_types.freeze

  belongs_to :voice_actor
  belongs_to :illustrator
  belongs_to :skill
  belongs_to :first_ability,  class_name: "Ability"
  belongs_to :second_ability, class_name: "Ability"

  validates :name,
    presence: true,
    length: {maximum: 100}
  validates :title,
    length: {maximum: 200}
  validates :rarity,
    presence: true,
    inclusion: {in: RARITYS}
  validates :cost,
    presence: true,
    numericality: {only_integer: true}
  validates :weapon_type,
    presence: true,
    inclusion: {in: WEAPON_TYPES}
  validates :source_category,
    presence: true,
    length: {maximum: 100}
  validates :source,
    presence: true,
    length: {maximum: 100}
  validates :growth_type,
    presence: true,
    inclusion: {in: GROWTH_TYPES}
  validates :job_type,
    presence: true,
    inclusion: {in: JOB_TYPES}
  validates :job_index,
    presence: true,
    numericality: {only_integer: true}
  validates :job_code,
    presence: true,
    uniqueness: true,
    length: {maximum: 20}
  validates :max_atk,
    allow_nil: true,
    numericality: {only_integer: true}
  validates :max_hp,
    allow_nil: true,
    numericality: {only_integer: true}
  validates :limit_atk,
    allow_nil: true,
    numericality: {only_integer: true}
  validates :limit_hp,
    allow_nil: true,
    numericality: {only_integer: true}
  validates :job_detail,
    allow_nil: true,
    length: {maximum: 50}

  def serialize
    ret = self.attributes
    vname = self.voice_actor ? self.voice_actor.name : ''
    ret['voice_actor'] = vname
    ret.delete('voice_actor_id')
    iname = self.illustrator ? self.illustrator.name : ''
    ret['illustrator'] = iname
    ret.delete('illustrator_id')

    sk = (self.skill ? self.skill.serialize : {})
    ret['skill'] = sk
    ret.delete('skill_id')

    fb = (self.first_ability ? self.first_ability.serialize : {})
    ret['first_ability'] = fb
    ret.delete('first_ability_id')
    sb = (self.second_ability ? self.second_ability.serialize : {})
    ret['second_ability'] = sb
    ret.delete('second_ability_id')

    ret
  end

end
