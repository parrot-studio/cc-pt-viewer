class SkillEffect < ActiveRecord::Base
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
        range_line: '範囲・直線',
        range_dash: '範囲・ダッシュ',
        range_forward: '範囲・前方',
        range_self: '範囲・自分中心',
        range_explosion: '範囲・自爆',
        range_drop: '範囲・落下物',
        range_jump: '範囲・ジャンプ',
        range_blast: '範囲・爆発',
        range_random: '範囲・ランダム',
        range_line2: '範囲・直線2ライン',
        range_laser: '範囲・レーザー',
        range_all: '範囲・全体'
      },
      effect: {
        add_blind: '暗闇追加',
        add_curse: '呪い追加',
        add_down: 'ダウン追加',
        add_freeze: '凍結追加',
        add_poison: '毒追加',
        add_slow: 'スロウ追加',
        add_push: '弾き飛ばし',
        fire: '火属性',
        ice: '氷属性',
        charge: '溜め',
        kill_pierce: '倒したら貫通',
        shield_break: '盾破壊',
        heal_all: '全員を回復',
        pain: '自分もダメージ',
        return_position: '元の位置に戻る'
      }
    },
    heal: {
      name: '回復',
      sub: {
        all_instant: '全体・即時',
        all_cycle: '全体・オート',
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
        atkup: '攻撃力上昇',
        defup: '防御力上昇'
      }
    },
    song_dance: {
      name: '歌/舞',
      sub: {
        buff: '味方能力上昇',
        debuff: '敵状態異常'
      },
      effect: {
        guard_blind: '暗闇耐性',
        guard_freeze: '凍結耐性',
        guard_slow: 'スロウ耐性',
        guard_weaken: '衰弱耐性',
        guard_debuff: '状態異常耐性',
        guard_fire: '炎属性軽減',
        guard_ice: '氷属性軽減',
        guard_element: '属性軽減',
        add_blind: '暗闇追加',
        add_poison: '毒追加',
        add_slow: 'スロウ追加'
      }
    },
    buff: {
      name: '能力UP',
      sub: {
        self: '自身',
        all: '全体',
        random: 'ランダム'
      },
      effect: {
        atkup: '攻撃力上昇',
        atkdown: '攻撃力低下',
        defup: '防御力上昇',
        defdown: '防御力低下',
        speedup: '移動速度上昇',
        delayoff: '攻撃速度上昇',
        add_fire: '炎属性付与',
        add_ice: '氷属性付与'
      }
    },
    barrier: {
      name: 'バリア',
      sub: {
        self: '自身',
        all: '全体'
      },
      effect: {
        guard_blind: '暗闇耐性',
        guard_freeze: '凍結耐性',
        guard_slow: 'スロウ耐性',
        guard_weaken: '衰弱耐性',
        guard_debuff: '状態異常耐性',
        guard_ice: '氷属性軽減',
        guard_element: '属性軽減',
        invincible: '無敵'
      }
    },
    area: {
      name: '設置/フィールド',
      sub: {
        obstacle: '[設置] 障害物',
        bomb: '[設置] 爆弾',
        continual: '[領域] 継続ダメージ',
        atkup: '[領域] 攻撃力上昇',
        defdown: '[領域] 防御力低下',
        field: 'フィールド変更'
      },
      effect: {
        add_blind: '暗闇追加',
        add_poison: '毒追加',
        add_slow: 'スロウ追加',
        fire: '火属性'
      }
    }
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
    CATEGORYS.values.each do |v|
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
    CATEGORYS.values.each do |v|
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

  validates :order,
            presence: true,
            numericality: { only_integer: true }
  validates :category,
            presence: true,
            length: { maximum: 100 }
  validates :subcategory,
            presence: true,
            length: { maximum: 100 }
  validates :subeffect1,
            length: { maximum: 100 }
  validates :subeffect2,
            length: { maximum: 100 }
  validates :subeffect3,
            length: { maximum: 100 }

  def serialize
    excepts = %w(id skill_id created_at updated_at)
    se = self.as_json(except: excepts)

    se['category'] = CATEGORYS.fetch(self.category.to_sym, {}).fetch(:name, '')
    se['subcategory'] = SUBCATEGORYS.fetch(self.subcategory.to_sym, '')
    se['subeffect1'] = SUBEFFECTS.fetch(self.subeffect1.to_sym, '') if self.subeffect1.present?
    se['subeffect2'] = SUBEFFECTS.fetch(self.subeffect2.to_sym, '') if self.subeffect2.present?
    se['subeffect3'] = SUBEFFECTS.fetch(self.subeffect3.to_sym, '') if self.subeffect3.present?

    se
  end

end
