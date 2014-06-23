class Arcana < ActiveRecord::Base
  default_scope { order('job_type, rarity DESC, job_index DESC') }

  JOB_TYPES = %w|F K P A M|.freeze
  RARITYS = (1..5).freeze

  validates :name,
    presence: true,
    length: {maximum: 100}
  validates :title,
    length: {maximum: 200}
  validates :rarity,
    presence: true,
    inclusion: {in: RARITYS}
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
