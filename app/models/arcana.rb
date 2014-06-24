class Arcana < ActiveRecord::Base
  default_scope { order('job_type, rarity DESC, job_index DESC') }

  JOB_TYPES = ServerSettings.jobs.split(' ').reject(&:blank?).uniq.compact.freeze
  RARITYS = (1..(ServerSettings.rarity)).freeze

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
  validates :job_type,
    presence: true,
    inclusion: {in: JOB_TYPES}
  validates :job_index,
    presence: true,
    numericality: {only_integer: true}
  validates :job_index,
    presence: true,
    length: {maximum: 20}

end
