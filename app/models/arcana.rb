class Arcana < ActiveRecord::Base

  default_scope { includes([:voice_actor, :illustrator, :skill]) }

  JOB_TYPES = ServerSettings.job_types.freeze
  RARITYS = (1..(ServerSettings.rarity)).freeze
  WEAPON_TYPES = ServerSettings.weapon_types.freeze
  HOMETOWN_NAMES = ServerSettings.hometown_names.freeze
  SOURCE_NAMES = ServerSettings.source_names.freeze
  GROWTH_TYPES = ServerSettings.growth_types.freeze
  ADDITION_TYPES = ServerSettings.addition_types.freeze

  belongs_to :voice_actor
  belongs_to :illustrator
  belongs_to :skill

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
  validates :hometown,
    presence: true,
    inclusion: {in: HOMETOWN_NAMES}
  validates :source,
    presence: true,
    inclusion: {in: SOURCE_NAMES}
  validates :growth_type,
    presence: true,
    inclusion: {in: GROWTH_TYPES}
  validates :addition,
    presence: true,
    inclusion: {in: ADDITION_TYPES}
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

  def serialize
    ret = self.attributes
    ret['voice_actor'] = self.voice_actor.name
    ret.delete('voice_actor_id')
    ret['illustrator'] = self.illustrator.name
    ret.delete('illustrator_id')

    sk = self.skill
    ret['skill_name'] = sk.name
    ret['skill_category'] = sk.category
    ret['skill_subcategory'] = sk.subcategory
    ret['skill_explanation'] = sk.explanation
    ret['skill_cost'] = sk.cost

    ret
  end

end
