class Arcana < ActiveRecord::Base

  default_scope { includes(:voice_actor) }

  JOB_TYPES = ServerSettings.job_types.freeze
  RARITYS = (1..(ServerSettings.rarity)).freeze
  WEAPON_TYPES = ServerSettings.weapon_types.freeze
  HOMETOWN_NAMES = ServerSettings.hometown_names.freeze
  SOURCE_NAMES = ServerSettings.source_names.freeze

  belongs_to :voice_actor

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
    ret
  end

end
