class Arcana < ActiveRecord::Base

  default_scope do
    includes([
      :voice_actor, :illustrator, :skill,
      :first_ability, :second_ability, :chain_ability, :weapon_ability
    ])
  end

  belongs_to :voice_actor
  belongs_to :illustrator
  belongs_to :skill
  belongs_to :first_ability,  class_name: 'Ability'
  belongs_to :second_ability, class_name: 'Ability'
  belongs_to :chain_ability
  belongs_to :weapon_ability, class_name: 'Ability'

  RARITYS = (1..5).freeze

  JOB_NAMES = {
    F: '戦士',
    K: '騎士',
    A: '弓使い',
    M: '魔法使い',
    P: '僧侶'
  }.freeze

  JOB_TYPES = JOB_NAMES.keys.map(&:to_s).freeze

  CLASS_NAMES = {
    F: 'fighter',
    K: 'knight',
    A: 'archer',
    M: 'magician',
    P: 'priest'
  }.freeze

  WEAPON_NAMES = {
    Sl: '斬',
    Bl: '打',
    Pi: '突',
    Ar: '弓',
    Ma: '魔',
    He: '聖',
    Pu: '拳',
    Gu: '銃',
    Sh: '狙'
  }.freeze

  WEAPON_TYPES = WEAPON_NAMES.keys.map(&:to_s).freeze

  UNION_NAMES = {
    guildtown: '副都',
    holytown: '聖都',
    academy: '賢者の塔',
    mountain: '迷宮山脈',
    oasis: '湖都',
    forest: '精霊島',
    volcano: '九領',
    forest_sea: '海風の港',
    dawnsea: '大海',
    beasts: 'ケ者',
    criminal: '罪の大陸',
    life: '薄命',
    machine: '鉄煙',
    volunteers: '義勇軍',
    demon: '魔神',
    others: '旅人',
    unknown: '（調査中）'
  }.freeze

  SOURCE_TABLE = {
    first: {
      name: '1部',
      details: {
        guildtown: '副都・酒場',
        holytown: '聖都・酒場',
        academy: '賢者の塔・酒場',
        mountain: '迷宮山脈・酒場',
        oasis: '湖都・酒場',
        forest: '精霊島・酒場',
        volcano: '九領・酒場',
        other: 'その他'
      }
    },
    second: {
      name: '2部',
      details: {
        forest_sea: '海風の港・酒場',
        dawnsea: '夜明けの大海・酒場',
        beasts: 'ケ者の大陸・酒場',
        criminal: '罪の大陸・酒場',
        life: '薄命の大陸・酒場',
        machine: '鉄煙の大陸・酒場',
        other: 'その他'
      }
    },
    ring: {
      name: 'リング系',
      details: {
        trade: '交換',
        random: 'ガチャ'
      }
    },
    event: {
      name: 'イベント限定',
      details: {
        festival: 'フェス',
        demon: '魔神戦',
        score: '戦の年代記',
        war: '討伐戦',
        other: 'その他'
      }
    },
    collaboration: {
      name: 'イベント限定',
      details: {
        shiningblade: 'シャイニング・ブレイド',
        maoyu: 'まおゆう',
        trefle: 'Trefle',
        mediafactory: 'メディアファクトリー',
        loghorizon: 'ログ・ホライズン',
        bakidou: '刃牙道',
        atelier_twilight: 'アトリエ・黄昏シリーズ',
        monokuma: '絶対絶望少女',
        falcom_sen2: '閃の軌跡II',
        sevensins: '七つの大罪',
        brave: 'ブレイブフロンティア',
        shiningresonance: 'シャイニング・レゾナンス',
        atelier_arland: 'アトリエ・アーランドシリーズ',
        other: 'その他'
      }
    }
  }.freeze

  SOURCE_CONDS = lambda do
    ret = {}
    SOURCE_TABLE.each do |k, v|
      ret[k] = v[:details].to_a
    end
    ret
  end.call.freeze

  validates :name,
            presence: true,
            length: { maximum: 100 }
  validates :title,
            length: { maximum: 200 }
  validates :rarity,
            presence: true,
            inclusion: { in: RARITYS }
  validates :cost,
            presence: true,
            numericality: { only_integer: true }
  validates :chain_cost,
            presence: true,
            numericality: { only_integer: true }
  validates :weapon_type,
            presence: true,
            inclusion: { in: WEAPON_TYPES }
  validates :source_category,
            presence: true,
            length: { maximum: 100 }
  validates :source,
            presence: true,
            length: { maximum: 100 }
  validates :union,
            presence: true,
            length: { maximum: 100 }
  validates :job_type,
            presence: true,
            inclusion: { in: JOB_TYPES }
  validates :job_index,
            presence: true,
            numericality: { only_integer: true }
  validates :job_code,
            presence: true,
            uniqueness: true,
            length: { maximum: 20 }
  validates :max_atk,
            allow_nil: true,
            numericality: { only_integer: true }
  validates :max_hp,
            allow_nil: true,
            numericality: { only_integer: true }
  validates :limit_atk,
            allow_nil: true,
            numericality: { only_integer: true }
  validates :limit_hp,
            allow_nil: true,
            numericality: { only_integer: true }
  validates :job_detail,
            allow_nil: true,
            length: { maximum: 50 }

  def serialize
    excepts = %w(voice_actor_id illustrator_id skill_id first_ability_id second_ability_id chain_ability_id weapon_ability_id)
    ret = self.as_json(except: excepts)

    ret['weapon_name'] = WEAPON_NAMES.fetch(self.weapon_type.to_sym, '')
    ret['job_name'] = JOB_NAMES.fetch(self.job_type.to_sym, '')
    ret['job_class'] = CLASS_NAMES.fetch(self.job_type.to_sym, '')
    st = SOURCE_TABLE.fetch(self.source_category.to_sym, {})
    ret['source_category'] = st.fetch(:name, '')
    ret['source'] = st.fetch(:details).fetch(self.source.to_sym, '')
    ret['union'] = UNION_NAMES.fetch(self.union.to_sym, '')

    ret['voice_actor'] = (voice_actor ? voice_actor.name : '')
    ret['illustrator'] = (illustrator ? illustrator.name : '')
    ret['skill'] = (skill ? skill.serialize : {})
    ret['first_ability'] = (first_ability ? first_ability.serialize : {})
    ret['second_ability'] = (second_ability ? second_ability.serialize : {})
    ret['chain_ability'] = (chain_ability ? chain_ability.serialize : {})
    ret['weapon_ability'] = (weapon_ability ? weapon_ability.serialize : {})

    ret
  end

end
