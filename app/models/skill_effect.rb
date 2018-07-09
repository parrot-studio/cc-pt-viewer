# == Schema Information
#
# Table name: skill_effects
#
#  id              :integer          not null, primary key
#  skill_id        :integer          not null
#  order           :integer          not null
#  category        :string(100)      not null
#  subcategory     :string(100)      not null
#  multi_type      :string(100)
#  multi_condition :string(100)
#  subeffect1      :string(100)
#  subeffect2      :string(100)
#  subeffect3      :string(100)
#  subeffect4      :string(100)
#  subeffect5      :string(100)
#  note            :string(100)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_skill_effects_on_category                  (category)
#  index_skill_effects_on_category_and_subcategory  (category,subcategory)
#  index_skill_effects_on_skill_id                  (skill_id)
#  index_skill_effects_on_subeffect1                (subeffect1)
#  index_skill_effects_on_subeffect2                (subeffect2)
#  index_skill_effects_on_subeffect3                (subeffect3)
#  index_skill_effects_on_subeffect4                (subeffect4)
#  index_skill_effects_on_subeffect5                (subeffect5)
#

class SkillEffect < ApplicationRecord
  belongs_to :skill

  CATEGORYS = {
    attack: {
      name: '攻撃',
      sub: {
        one_short: '単体・目前',
        one_line: '単体・直線',
        one_combo: '単体・連続',
        one_dash: '単体・ダッシュ',
        one_rear: '単体・最後列',
        one_jump: '単体・ジャンプ',
        one_random: '単体・ランダム',
        one_combination: '単体・コンビネーション',
        one_nearest: '単体・一番近い対象',
        one_most: '単体・HPが一番多い対象',
        contact_combo: '接触・連続',
        contact_combination: '接触・コンビネーション',
        range_line: '範囲・直線',
        range_dash: '範囲・ダッシュ',
        range_forward: '範囲・前方',
        range_forward_combo: '範囲・前方/連続',
        range_self: '範囲・自分中心',
        range_self_combo: '範囲・自分中心/連続',
        range_explosion: '範囲・自爆',
        range_drop: '範囲・落下物',
        range_drop_combo: '範囲・落下物/連続',
        range_jump: '範囲・ジャンプ',
        range_jump_combo: '範囲・ジャンプ/連続',
        range_blast: '範囲・爆発',
        range_random: '範囲・ランダム',
        range_random_blast: '範囲・ランダム/爆発',
        range_line2: '範囲・直線2ライン',
        range_short: '範囲・接触',
        range_shortline: '範囲・前方直線',
        range_redash: '範囲・後方ダッシュ',
        range_dash_combo: '範囲・ダッシュ/連続',
        range_all: '範囲・広域',
        laser: 'レーザー',
        summon: '召喚',
        cycle_shoot: '定期的に射撃',
        bullets: '連射',
        chain: '周囲に連鎖',
        bombard: '砲撃',
        bombshoot: '爆弾付与',
        boomerang: 'ブーメラン',
        slicer: 'スライサー',
        random: 'ランダム効果',
        wire_action: 'ワイヤーアクション'
      },
      effect: {
        add_blind: '暗闇追加',
        add_curse: '呪い追加',
        add_down: 'ダウン追加',
        add_freeze: '凍結追加',
        add_poison: '毒追加',
        add_slow: 'スロウ追加',
        add_push: '弾き飛ばし',
        add_tumble: '転倒付与',
        add_defdown: '防御力低下',
        add_atkdefdown: '攻撃力/防御力低下',
        add_defspeeddown: '防御力/移動速度低下',
        fire: '火属性',
        ice: '氷属性',
        charge: '溜め',
        kill_pierce: '倒したら貫通',
        kill_mana: '倒したらマナドロップ',
        shield_break: '盾破壊',
        heal_all: '全員を回復',
        absorb: '与えたダメージを吸収',
        create_scrap: 'スクラップ生成',
        destroy_scrap: 'スクラップ破壊',
        super_skill: '超必殺技',
        pain: '自分もダメージ',
        return_position: '元の位置に戻る',
        chain: '周辺の敵に広がる',
        cure_blind: '暗闇解除',
        cure_freeze: '凍結解除',
        cure_weaken: '衰弱解除'
      }
    },
    heal: {
      name: '回復',
      sub: {
        all_instant: '全体・即時',
        all_cycle: '全体・徐々に回復',
        all_reaction: '全体・ダメージ反応',
        one_self: '単体・自分',
        one_worst: '単体・一番HPが低い対象'
      },
      effect: {
        cure_blind: '暗闇解除',
        cure_down: 'ダウン解除',
        cure_freeze: '凍結解除',
        cure_poison: '毒解除',
        cure_seal: '封印解除',
        cure_slow: 'スロウ解除',
        cure_weaken: '衰弱解除',
        cure_curse: '呪い解除',
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        acup: '攻撃力/クリティカル率上昇上昇',
        scup: '移動速度/クリティカル率上昇上昇',
        restoration: '返還',
        create_scrap: 'スクラップ生成',
        destroy_scrap: 'スクラップ破壊',
        super_skill: '超必殺技',
        excess: '超過'
      }
    },
    song_dance: {
      name: '歌/舞',
      sub: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        dsup: '防御力/移動速度上昇',
        scup: '移動速度/クリティカル率上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        add_blind: '暗闇追加',
        add_poison: '毒追加',
        add_slow: 'スロウ追加',
        heal_cycle: '徐々に回復'
      },
      effect: {
        guard_blind: '暗闇耐性',
        guard_freeze: '凍結耐性',
        guard_slow: 'スロウ耐性',
        guard_poison: '毒耐性',
        guard_weaken: '衰弱耐性',
        guard_debuff: '状態異常耐性',
        guard_fire: '炎属性軽減',
        guard_ice: '氷属性軽減',
        guard_element: '属性軽減',
        cure_down: 'ダウン解除',
        super_skill: '超必殺技'
      }
    },
    buff: {
      name: '強化',
      sub: {
        self: '自身',
        all: '全体',
        others: '自分以外の全員',
        fighter: '戦士',
        archer: '弓使い',
        front: '先頭の一人',
        far: '一番遠い一人',
        nearest: '一番近い一人',
        hp_worst: '一番HPが低い一人',
        random: 'ランダム',
        restoration: '返還'
      },
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        dsup: '防御力/移動速度上昇',
        acup: '攻撃力/クリティカル率上昇',
        arup: '攻撃力/クリティカルダメージ上昇',
        crup: 'クリティカル率/クリティカルダメージ上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        delayoff: '攻撃速度上昇',
        atkdown: '攻撃力低下',
        defdown: '防御力低下',
        add_fire: '炎属性付与',
        add_ice: '氷属性付与',
        create_scrap: 'スクラップ生成',
        destroy_scrap: 'スクラップ破壊',
        super_skill: '超必殺技',
        add_resurrection: '復活付与'
      }
    },
    barrier: {
      name: 'バリア',
      sub: {
        self: '自身',
        all: '全体',
        knight: '騎士'
      },
      effect: {
        guard_poison: '毒耐性',
        guard_blind: '暗闇耐性',
        guard_freeze: '凍結耐性',
        guard_slow: 'スロウ耐性',
        guard_down: 'ダウン耐性',
        guard_weaken: '衰弱耐性',
        guard_debuff: '状態異常耐性',
        guard_fire: '火属性軽減',
        guard_ice: '氷属性軽減',
        invincible: '無敵',
        aup: '攻撃力上昇',
        reflect_attack: '攻撃反射',
        super_skill: '超必殺技'
      }
    },
    field: {
      name: 'フィールド変更',
      sub: {
        forest: '森林',
        desert: '砂漠',
        beach: '砂浜',
        wasteland: '荒地',
        town: '市街',
        battlefield: '戦場',
        sea: '海中',
        ship: '船上',
        night: '夜間',
        snow: '雪山',
        dimension: '異空間'
      },
      effect: {
        aup: '攻撃力上昇',
        super_skill: '超必殺技'
      }
    },
    area: {
      name: '領域展開/設置',
      sub: {
        buff: '[領域] ステータス上昇',
        debuff: '[領域] ステータス低下',
        continual: '[領域] 継続ダメージ',
        echo: '[領域] 反響',
        obstacle: '[設置] 障害物',
        trap: '[設置] 罠'
      },
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        adup: '攻撃力/防御力上昇',
        defdown: '防御力低下',
        add_blind: '暗闇追加',
        add_poison: '毒追加',
        add_slow: 'スロウ追加',
        add_down: 'ダウン追加',
        add_freeze: '凍結追加',
        add_tumble: '転倒付与',
        fire: '火属性',
        ice: '氷属性',
        heal_cycle: '徐々に回復',
        against_dropout: '戦闘不能にならない',
        create_scrap: 'スクラップ生成',
        super_skill: '超必殺技'
      }
    },
    metamorphose: {
      name: '変身',
      sub: {
        self: '自身'
      },
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        acup: '攻撃力/クリティカル率上昇',
        dsup: '防御力/移動速度上昇',
        scup: '移動速度/クリティカル率上昇',
        crup: 'クリティカル率/クリティカルダメージ上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        adrup: '攻撃力/防御力/クリティカルダメージ上昇',
        ascup: '攻撃力/移動速度/クリティカル率上昇',
        asrup: '攻撃力/移動速度/クリティカルダメージ上昇',
        acrup: '攻撃力/クリティカル率/クリティカルダメージ上昇',
        adscup: '攻撃力/防御力/移動速度/クリティカル率上昇',
        adscrup: '攻撃力/防御力/移動速度/クリ率/クリダメ上昇',
        healareaup: '回復範囲/効果上昇',
        delayoff: '攻撃速度上昇',
        heal_cycle: '徐々に回復',
        pierce: '貫通する',
        wide_attack: '範囲攻撃',
        guard: '遠距離ガード可能',
        destroy_scrap: 'スクラップ破壊',
        super_skill: '超必殺技'
      }
    },
    enchant: {
      name: '付与',
      sub: {
        self: '自身',
        all: '全体',
        archer: '弓使い'
      },
      effect: {
        fire: '火属性',
        ice: '氷属性',
        add_slow: 'スロウ追加',
        add_freeze: '凍結追加',
        add_poison: '毒追加',
        shield_break: '盾破壊',
        super_skill: '超必殺技'
      }
    }
  }.freeze

  MULTI_TYPE = {
    forward: '→',
    either: 'または'
  }.freeze

  CATEGORY_CONDS = lambda do
    ret = []
    CATEGORYS.each do |k, v|
      next if k == :unknown
      ret << [k, v[:name]]
    end
    ret
  end.call.freeze

  SUBCATEGORYS = lambda do
    ret = {}
    CATEGORYS.each_value do |v|
      ret.merge!(v.fetch(:sub, {}))
    end
    ret
  end.call.freeze

  SUBCATEGORY_CONDS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      ret[k] = v.fetch(:sub, {}).to_a
    end
    ret
  end.call.freeze

  SUBEFFECTS = lambda do
    ret = {}
    CATEGORYS.each_value do |v|
      ret.merge!(v.fetch(:effect, {}))
    end
    ret
  end.call.freeze

  SUBEFFECT_CONDS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      ret[k] = v.fetch(:effect, {}).to_a
    end
    ret
  end.call.freeze

  BUFF_TYPES = lambda do
    ret = []
    CATEGORYS.each_value do |cv|
      ret << cv[:effect].keys.select { |k| k.match(/\A[a|d|s|c|r]+up\z/) }
    end
    ret.flatten.uniq.compact.map(&:to_s)
  end.call.freeze

  EFFECT_GROUP = {
    aup: BUFF_TYPES.select { |s| s.match(/a/) },
    dup: BUFF_TYPES.select { |s| s.match(/d/) },
    sup: BUFF_TYPES.select { |s| s.match(/s/) },
    cup: BUFF_TYPES.select { |s| s.match(/c/) },
    rup: BUFF_TYPES.select { |s| s.match(/r/) }
  }.freeze

  validates :order,
            presence: true,
            numericality: { only_integer: true }
  validates :category,
            presence: true,
            length: { maximum: 100 }
  validates :subcategory,
            presence: true,
            length: { maximum: 100 }
  validates :multi_type,
            length: { maximum: 100 }
  validates :multi_condition,
            length: { maximum: 100 }
  validates :subeffect1,
            length: { maximum: 100 }
  validates :subeffect2,
            length: { maximum: 100 }
  validates :subeffect3,
            length: { maximum: 100 }
  validates :subeffect4,
            length: { maximum: 100 }
  validates :subeffect5,
            length: { maximum: 100 }
  validates :note,
            length: { maximum: 100 }

  def serialize
    excepts = %w[id skill_id created_at updated_at]
    se = self.as_json(except: excepts)

    se['category'] = CATEGORYS.fetch(self.category.to_sym, {}).fetch(:name, '')
    se['subcategory'] = SUBCATEGORYS.fetch(self.subcategory.to_sym, '')
    se['subeffect1'] = SUBEFFECTS.fetch(self.subeffect1.to_sym, '') if self.subeffect1.present?
    se['subeffect2'] = SUBEFFECTS.fetch(self.subeffect2.to_sym, '') if self.subeffect2.present?
    se['subeffect3'] = SUBEFFECTS.fetch(self.subeffect3.to_sym, '') if self.subeffect3.present?
    se['subeffect4'] = SUBEFFECTS.fetch(self.subeffect4.to_sym, '') if self.subeffect4.present?
    se['subeffect5'] = SUBEFFECTS.fetch(self.subeffect5.to_sym, '') if self.subeffect5.present?

    se
  end
end
