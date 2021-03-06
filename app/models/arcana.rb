# == Schema Information
#
# Table name: arcanas
#
#  id              :bigint(8)        not null, primary key
#  name            :string(100)      not null
#  title           :string(100)      not null
#  arcana_type     :string(20)       not null
#  rarity          :integer          not null
#  cost            :integer          default(0), not null
#  chain_cost      :integer          default(0), not null
#  weapon_type     :string(10)       not null
#  job_type        :string(10)       not null
#  job_index       :integer          not null
#  job_code        :string(10)       not null
#  job_detail      :string(50)
#  source_category :string(50)       not null
#  source          :string(50)       not null
#  union           :string(20)       not null
#  person_code     :string(10)       not null
#  link_code       :string(10)
#  max_atk         :integer
#  max_hp          :integer
#  limit_atk       :integer
#  limit_hp        :integer
#  voice_actor_id  :integer          default(0), not null
#  illustrator_id  :integer          default(0), not null
#  wiki_name       :string(50)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_arcanas_on_arcana_type                 (arcana_type)
#  index_arcanas_on_chain_cost                  (chain_cost)
#  index_arcanas_on_cost                        (cost)
#  index_arcanas_on_illustrator_id              (illustrator_id)
#  index_arcanas_on_job_code                    (job_code) UNIQUE
#  index_arcanas_on_job_type                    (job_type)
#  index_arcanas_on_job_type_and_job_index      (job_type,job_index) UNIQUE
#  index_arcanas_on_job_type_and_rarity         (job_type,rarity)
#  index_arcanas_on_name                        (name)
#  index_arcanas_on_person_code                 (person_code)
#  index_arcanas_on_rarity                      (rarity)
#  index_arcanas_on_source_category             (source_category)
#  index_arcanas_on_source_category_and_source  (source_category,source)
#  index_arcanas_on_title                       (title)
#  index_arcanas_on_union                       (union)
#  index_arcanas_on_union_and_job_type          (union,job_type)
#  index_arcanas_on_voice_actor_id              (voice_actor_id)
#  index_arcanas_on_weapon_type                 (weapon_type)
#

# rubocop:disable Metrics/ClassLength, Metrics/MethodLength
# rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
class Arcana < ApplicationRecord
  belongs_to :voice_actor, inverse_of: :arcanas
  belongs_to :illustrator, inverse_of: :arcanas
  has_many   :skills,      inverse_of: :arcana
  has_many   :abilities,   inverse_of: :arcana

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

  ARCANA_TYPE_NAMES = {
    first: '旧世代（1部・2部）',
    third: '新世代（3部）',
    demon: '魔神',
    demon_newgene: '魔神（新世代）',
    buddy: 'バディ',
    collaboration: 'コラボ',
    collabo_newgene: 'コラボ（新世代）'
  }.freeze

  ARCANA_TYPES = ARCANA_TYPE_NAMES.keys.map(&:to_s).freeze

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
    chronicle: '年代記',
    remless: 'レムレス島',
    volunteers: '義勇軍',
    demon: '魔神',
    spirit: '幻霊',
    others: '旅人',
    unknown: '（調査中）'
  }.freeze

  SOURCE_TABLE = {
    yggd: {
      name: 'ユグド大陸（1・2部）',
      details: {
        guildtown: '副都・酒場（1・2部）',
        holytown: '聖都・酒場（1・2部）',
        academy: '賢者の塔・酒場（1・2部）',
        mountain: '迷宮山脈・酒場（1・2部）',
        oasis: '湖都・酒場（1・2部）',
        forest: '精霊島・酒場（1・2部）',
        volcano: '九領・酒場（1・2部）',
        forest_sea: '海風の港・酒場（1・2部）',
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
    third: {
      name: '3部',
      details: {
        guildtown3: '聖王国・酒場（3部）',
        academy3: '賢者の塔・酒場（3部）',
        oasis3: '湖都・酒場（3部）',
        forest3: '精霊島・酒場（3部）',
        volcano3: '九領・酒場（3部）',
        pub: '酒場全般（3部）',
        quest: 'クエスト報酬',
        gunki: '義勇軍記'
      }
    },
    random: {
      name: 'ガチャ系',
      details: {
        coin: 'アルカナコイン',
        ring: 'リング',
        spirit: '幻霊'
      }
    },
    event: {
      name: 'イベント限定',
      details: {
        festival: 'フェス',
        legend: 'レジェンドフェス',
        demon: '魔神戦',
        score: '踏破',
        war: '討伐戦',
        hunting: '狩猟戦',
        medal: 'メダルハント',
        warfare: '大出撃',
        whirlpool: '深淵の渦',
        other: 'その他'
      }
    },
    collaboration: {
      name: 'コラボ',
      details: {
        ojisan: '異世界おじさん',
        sakurawar_new: '新サクラ大戦',
        sonic_movie: 'ソニック・ザ・ムービー',
        utaware_hakuoro: 'うたわれるもの・二人の白皇',
        railgun: 'とある科学の超電磁砲T',
        puyo: 'ぷよぷよ',
        shield_hero: '盾の勇者の成り上がり',
        friends2: 'けものフレンズ2',
        slime: '転生したらスライムだった件',
        index3: 'とある魔術の禁書目録III',
        persona3: 'ペルソナ3',
        utaware_requiem: 'うたわれるもの・散りゆく者への子守唄',
        bloodbeyond: '血界戦線＆BEYOND',
        overload2: 'オーバーロードII',
        swordoratoria: 'ソード・オラトリア',
        nanoha: 'リリカルなのは',
        guiltygear: 'ギルティギア',
        twinangel: 'ツインエンジェル',
        titan: '進撃の巨人',
        konosuba: 'このすば',
        persona5: 'ペルソナ5',
        haecceitas: 'アニメ（ヘクセイタスの閃）',
        magica: 'まどか☆マギカ',
        taiko: '太鼓の達人',
        sakurawar: 'サクラ大戦',
        danmachi: 'ダンまち',
        utaware: 'うたわれるもの・偽りの仮面',
        valkyria: '戦場のヴァルキュリア',
        falcom_sorasc: '空の軌跡SC',
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
    },
    other: {
      name: 'その他',
      details: {
        quest: '探索',
        ring: 'リング交換'
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

  SOURCE_GROUP_CATEGORYS = %i[first second].freeze

  NOT_INHERITABLE_TYPES = %i[buddy third demon_newgene collabo_newgene].freeze
  NOT_INHERITABLE_ARCANAS = %w[F211 F156 M288 F484 F494].freeze # ミョルン, ホーク, リムル, ソニック
  NOT_INHERITABLE_COLLABORATIONS = %w[
    sakurawar_new magica taiko sakurawar falcom_sorasc brave monokuma
    atelier_twilight hardgirls trefle shiningblade other
  ].freeze

  scope :with_tables, -> { includes(%i[voice_actor illustrator skills abilities]) }
  scope :sr_and_over, -> { where(arel_table[:rarity].gteq(4)) }
  scope :inheritable_candidates, lambda {
    sr_and_over
      .where.not(arcana_type: NOT_INHERITABLE_TYPES)
      .where.not(job_code: NOT_INHERITABLE_ARCANAS)
  }

  validates :name,
            presence: true,
            length: { maximum: 100 }
  validates :title,
            length: { maximum: 100 }
  validates :arcana_type,
            presence: true,
            inclusion: { in: ARCANA_TYPES }
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
            length: { maximum: 50 }
  validates :source,
            presence: true,
            length: { maximum: 50 }
  validates :union,
            presence: true,
            length: { maximum: 50 }
  validates :job_type,
            presence: true,
            inclusion: { in: JOB_TYPES }
  validates :job_index,
            presence: true,
            numericality: { only_integer: true }
  validates :job_code,
            presence: true,
            uniqueness: true,
            length: { maximum: 10 }
  validates :job_detail,
            presence: true,
            length: { maximum: 50 }
  validates :person_code,
            presence: true,
            length: { maximum: 10 }
  validates :link_code,
            allow_nil: true,
            length: { maximum: 10 }
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

  class << self
    def inheritables
      self.inheritable_candidates.select do |a|
        next true unless a.arcana_type == 'collaboration'
        next true unless NOT_INHERITABLE_COLLABORATIONS.include?(a.source)

        false
      end
    end
  end

  def skill_for(stype)
    skills.find { |a| a.skill_type == stype }
  end

  def ability_for(atype)
    abilities.find { |a| a.ability_type == atype }
  end

  def wiki_link_name
    return self.wiki_name if self.wiki_name.present?
    return '' if self.title.match?(/調査中/)

    "#{self.title}#{self.name}"
  end

  def origin_name
    return wiki_link_name unless self.arcana_type == 'buddy'

    "#{self.title}#{self.name}"
  end

  def linked_arcana
    return if self.link_code.blank?

    Arcana.find_by(job_code: self.link_code)
  end

  def data_updated_at
    [
      self.updated_at,
      self.skills.map(&:updated_at).max,
      self.skills.map(&:skill_effects).flatten.compact.map(&:updated_at).max,
      self.abilities.map(&:updated_at).max,
      self.abilities.map(&:ability_effects).flatten.compact.map(&:updated_at).max
    ].flatten.compact.max
  end

  def serialize(nolink: false) # rubocop:disable Metrics/PerceivedComplexity, Metrics/AbcSize
    excepts = %w[id voice_actor_id illustrator_id wiki_name created_at updated_at]
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
    ret['wiki_link_name'] = wiki_link_name

    ret['first_skill'] = skill_for('1')&.serialize || {}
    ret['second_skill'] = skill_for('2')&.serialize || {}
    ret['third_skill'] = skill_for('3')&.serialize || {}
    ret['inherit_skill'] = skill_for('d')&.serialize || {}
    ret['heroic_skill'] = skill_for('h')&.serialize || {}
    ret['decisive_order'] = skill_for('kg')&.serialize || {}
    ret['decisive_skill'] = skill_for('ks')&.serialize || {}

    ret['first_ability'] = ability_for('1')&.serialize || {}
    ret['second_ability'] = ability_for('2')&.serialize || {}
    ret['party_ability'] = ability_for('p')&.serialize || {}
    ret['chain_ability'] = ability_for('c')&.serialize || {}
    ret['weapon_ability'] = ability_for('w')&.serialize || {}
    ret['passive_ability'] = ability_for('pa')&.serialize || {}
    ret['extra_ability'] = ability_for('e')&.serialize || {}

    ret['gunki_abilites'] = Ability::TYPE_GUNKI.map do |gc|
      ability_for(gc)&.serialize
    end.reject(&:blank?)

    linked = linked_arcana
    ret['linked_arcana'] = (!nolink && linked ? linked.serialize(nolink: true) : {})

    ret
  end
end
# rubocop:enable Metrics/ClassLength, Metrics/MethodLength
# rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity
