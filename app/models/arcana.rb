# == Schema Information
#
# Table name: arcanas
#
#  id                :integer          not null, primary key
#  name              :string(100)      not null
#  title             :string(200)
#  rarity            :integer          not null
#  cost              :integer          not null
#  weapon_type       :string(10)       not null
#  job_type          :string(10)       not null
#  job_index         :integer          not null
#  job_code          :string(20)       not null
#  job_detail        :string(50)
#  source_category   :string(100)      not null
#  source            :string(100)      not null
#  union             :string(100)      not null
#  max_atk           :integer
#  max_hp            :integer
#  limit_atk         :integer
#  limit_hp          :integer
#  first_skill_id    :integer          default(0), not null
#  second_skill_id   :integer          default(0), not null
#  third_skill_id    :integer          default(0), not null
#  first_ability_id  :integer          default(0), not null
#  second_ability_id :integer          default(0), not null
#  weapon_ability_id :integer          default(0), not null
#  chain_ability_id  :integer          default(0), not null
#  chain_cost        :integer          default(0), not null
#  voice_actor_id    :integer          default(0), not null
#  illustrator_id    :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_arcanas_on_chain_ability_id                   (chain_ability_id)
#  index_arcanas_on_chain_cost                         (chain_cost)
#  index_arcanas_on_cost                               (cost)
#  index_arcanas_on_first_ability_id                   (first_ability_id)
#  index_arcanas_on_first_skill_id                     (first_skill_id)
#  index_arcanas_on_illustrator_id                     (illustrator_id)
#  index_arcanas_on_job_code                           (job_code) UNIQUE
#  index_arcanas_on_job_type                           (job_type)
#  index_arcanas_on_job_type_and_job_index             (job_type,job_index)
#  index_arcanas_on_job_type_and_rarity                (job_type,rarity)
#  index_arcanas_on_job_type_and_rarity_and_job_index  (job_type,rarity,job_index)
#  index_arcanas_on_limit_atk                          (limit_atk)
#  index_arcanas_on_limit_hp                           (limit_hp)
#  index_arcanas_on_max_atk                            (max_atk)
#  index_arcanas_on_max_hp                             (max_hp)
#  index_arcanas_on_name                               (name)
#  index_arcanas_on_rarity                             (rarity)
#  index_arcanas_on_rarity_and_weapon_type             (rarity,weapon_type)
#  index_arcanas_on_second_ability_id                  (second_ability_id)
#  index_arcanas_on_second_skill_id                    (second_skill_id)
#  index_arcanas_on_source                             (source)
#  index_arcanas_on_source_category                    (source_category)
#  index_arcanas_on_source_category_and_source         (source_category,source)
#  index_arcanas_on_third_skill_id                     (third_skill_id)
#  index_arcanas_on_union                              (union)
#  index_arcanas_on_voice_actor_id                     (voice_actor_id)
#  index_arcanas_on_weapon_ability_id                  (weapon_ability_id)
#  index_arcanas_on_weapon_type                        (weapon_type)
#

class Arcana < ApplicationRecord
  default_scope do
    includes(
      [
        :voice_actor, :illustrator, :first_skill, :second_skill, :third_skill,
        :first_ability, :second_ability, :chain_ability, :weapon_ability
      ]
    )
  end

  belongs_to :voice_actor
  belongs_to :illustrator
  belongs_to :first_skill,    class_name: 'Skill',   optional: true
  belongs_to :second_skill,   class_name: 'Skill',   optional: true
  belongs_to :third_skill,    class_name: 'Skill',   optional: true
  belongs_to :first_ability,  class_name: 'Ability', optional: true
  belongs_to :second_ability, class_name: 'Ability', optional: true
  belongs_to :weapon_ability, class_name: 'Ability', optional: true
  belongs_to :chain_ability,                         optional: true

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
    dawnsea: '大海',
    beasts: 'ケ者',
    criminal: '罪の大陸',
    life: '薄命',
    machine: '鉄煙',
    chronicle: '年代記の大陸',
    remless: 'レムレス島',
    volunteers: '義勇軍',
    demon: '魔神',
    sakurawar: '華劇団',
    others: '旅人',
    unknown: '（調査中）'
  }.freeze

  SOURCE_TABLE = {
    yggd: {
      name: 'ユグド大陸',
      details: {
        guildtown: '副都・酒場',
        holytown: '聖都・酒場',
        academy: '賢者の塔・酒場',
        mountain: '迷宮山脈・酒場',
        oasis: '湖都・酒場',
        forest: '精霊島・酒場',
        volcano: '九領・酒場',
        forest_sea: '海風の港・酒場',
        other: 'その他'
      }
    },
    cross: {
      name: '交鎖の海域',
      details: {
        dawnsea: '夜明けの大海・酒場',
        beasts: 'ケ者の大陸・酒場',
        criminal: '罪の大陸・酒場',
        life: '薄命の大陸・酒場',
        other: 'その他'
      }
    },
    origin: {
      name: '起源の海域',
      details: {
        machine: '鉄煙の大陸・酒場',
        chronicle: '年代記の大陸・酒場',
        bookshelf: '書架・酒場',
        other: 'その他'
      }
    },
    faraway: {
      name: '彼方の海域',
      details: {
        remless: 'レムレス島・酒場',
        other: 'その他'
      }
    },
    new_generation: {
      name: '3部',
      details: {
        guildtown3: '副都・酒場（3部）',
        academy3: '賢者の塔・酒場（3部）',
        oasis3: '湖都・酒場（3部）',
        forest3: '精霊島・酒場（3部）',
        volcano3: '九領・酒場（3部）',
        pub: '酒場全般（3部）',
        quest: 'クエスト報酬'
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
        score: '踏破',
        war: '討伐戦',
        whirlpool: '深淵の渦',
        other: 'その他'
      }
    },
    collaboration: {
      name: 'コラボ',
      details: {
        persona5: 'ペルソナ5',
        magica: 'まどか☆マギカ',
        taiko: '太鼓の達人',
        sakurawar: 'サクラ大戦',
        danmachi: 'ダンまち',
        utaware: 'うたわれるもの',
        valkyria: '戦場のヴァルキュリア',
        falcom_sorasc: '閃の軌跡II',
        seiken: '聖剣伝説',
        atelier_arland: 'アトリエ・アーランドシリーズ',
        shiningresonance: 'シャイニング・レゾナンス',
        brave: 'ブレイブフロンティア',
        sevensins: '七つの大罪',
        falcom_sen2: '閃の軌跡II',
        monokuma: '絶対絶望少女',
        atelier_twilight: 'アトリエ・黄昏シリーズ',
        loghorizon: 'ログ・ホライズン',
        hardgirls: 'セガ・ハード・ガールズ',
        mediafactory: 'メディアファクトリー',
        trefle: 'Trefle',
        maoyu: 'まおゆう',
        shiningblade: 'シャイニング・ブレイド',
        other: 'その他'
      }
    },
    first: {
      name: '1部酒場',
      details: {
        guildtown: '副都・酒場',
        holytown: '聖都・酒場',
        academy: '賢者の塔・酒場',
        mountain: '迷宮山脈・酒場',
        oasis: '湖都・酒場',
        forest: '精霊島・酒場',
        volcano: '九領・酒場'
      }
    },
    second: {
      name: '2部酒場',
      details: {
        forest_sea: '海風の港・酒場',
        dawnsea: '夜明けの大海・酒場',
        beasts: 'ケ者の大陸・酒場',
        criminal: '罪の大陸・酒場',
        life: '薄命の大陸・酒場',
        machine: '鉄煙の大陸・酒場',
        chronicle: '年代記の大陸・酒場',
        bookshelf: '書架・酒場'
      }
    }
  }.freeze

  SOURCE_CATEGORYS = lambda do
    ret = []
    SOURCE_TABLE.each do |k, v|
      ret << [k, v[:name]]
    end
    ret
  end.call.freeze

  SOURCE_CONDS = lambda do
    ret = {}
    SOURCE_TABLE.each do |k, v|
      ret[k] = v[:details].to_a
    end
    ret
  end.call.freeze

  SOURCE_GROUP_CATEGORYS = [:first, :second].freeze

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
    excepts = %w(voice_actor_id illustrator_id first_skill_id
                 second_skill_id third_skill_id chain_ability_id
                 first_ability_id second_ability_id weapon_ability_id)
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
    ret['first_skill'] = (first_skill ? first_skill.serialize : {})
    ret['second_skill'] = (second_skill ? second_skill.serialize : {})
    ret['third_skill'] = (third_skill ? third_skill.serialize : {})
    ret['first_ability'] = (first_ability ? first_ability.serialize : {})
    ret['second_ability'] = (second_ability ? second_ability.serialize : {})
    ret['weapon_ability'] = (weapon_ability ? weapon_ability.serialize : {})
    ret['chain_ability'] = (chain_ability ? chain_ability.serialize : {})

    ret
  end
end
