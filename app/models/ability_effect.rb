class AbilityEffect < ActiveRecord::Base
  belongs_to :abilities

  CATEGORYS = {
    buff_all: {
      name: '全体を強化',
      effect: {
        atkup: '攻撃力上昇',
        defup: '防御力上昇',
        speedup: '移動速度上昇',
        atkdefup: '攻撃力/防御力上昇',
        atkspeedup: '攻撃力/移動速度上昇',
        defspeedup: '防御力/移動速度上昇',
        critup: 'クリティカル率上昇'
      }
    },
    buff_others: {
      name: '自分以外の全体を強化',
      effect: {
        atkup: '攻撃力上昇',
        defup: '防御力上昇',
        speedup: '移動速度上昇',
        atkdefup: '攻撃力/防御力上昇',
        atkspeedup: '攻撃力/移動速度上昇',
        fullup: '攻撃力/防御力/移動速度上昇',
        critup: 'クリティカル率上昇'
      }
    },
    buff_jobs: {
      name: '特定の職全体を強化',
      effect: {
        atkup: '攻撃力上昇',
        defup: '防御力上昇',
        atkdefup: '攻撃力/防御力上昇',
        atkspeedup: '攻撃力/移動速度上昇',
        critup: 'クリティカル率上昇',
        add_down: '対象の攻撃にダウンを付与',
        add_slow: '対象の攻撃にスロウを付与'
      }
    },
    buff_weapons: {
      name: '特定の武器タイプ全体を強化',
      effect: {
        atkup: '攻撃力上昇',
        defup: '防御力上昇',
        speedup: '移動速度上昇',
        atkdefup: '攻撃力/防御力上昇',
        critup: 'クリティカル率上昇'
      }
    },
    skillup: {
      name: '自分のスキルを強化',
      effect: {
        skill_atkup: 'スキル威力上昇',
        skill_boost: 'スキル強化',
        charge_reduce: '溜め時間減少',
        skill_spread: 'スキル範囲拡大'
      }
    },
    killup: {
      name: '倒すたびに自分を強化',
      effect: {
        atkup: '攻撃力上昇',
        atkdefup: '攻撃力/防御力上昇',
        atkspeedup: '攻撃力/移動速度上昇'
      }
    },
    element: {
      name: '属性攻撃',
      effect: {
        fire: '火属性',
        ice: '氷属性'
      }
    },
    heal: {
      name: '回復/吸収',
      effect: {
        heal_self: '自身を回復',
        heal_cycle: '徐々に回復',
        heal_one: '一人を回復',
        heal_jobs: '特定の職を回復',
        heal_all: '全員を回復',
        absorb: '与えたダメージを吸収'
      }
    },
    add_debuff: {
      name: '状態異常付与',
      effect: {
        blind: '暗闇付与',
        down: 'ダウン付与',
        freeze: '凍結付与',
        poison: '毒付与',
        push: '弾き飛ばし付与',
        slow: 'スロウ付与',
        atkdown: '攻撃力低下',
        defdown: '防御力低下',
        speeddown: '移動速度低下',
        delayup: '攻撃速度低下',
        shield_break: '盾を破壊する'
      }
    },
    for_debuff: {
      name: '状態異常の敵に強い',
      effect: {
        atkup: '攻撃力上昇',
        atkdefup: '攻撃力/防御力上昇'
      }
    },
    against_debuff: {
      name: '対状態異常',
      effect: {
        guard_blind: '暗闇を防ぐ',
        guard_curse: '呪いを防ぐ',
        guard_down: 'ダウンを防ぐ',
        guard_freeze: '凍結を防ぐ',
        guard_poison: '毒を防ぐ',
        guard_push: '弾き飛ばしを防ぐ',
        guard_seal: '封印を防ぐ',
        guard_slow: 'スロウを防ぐ',
        guard_undead: '白骨化を防ぐ',
        guard_weaken: '衰弱を防ぐ',
        guard_all: '全ての状態異常を防ぐ',
        atkup: '攻撃力上昇',
        defup: '防御力上昇',
        speedup: '移動速度上昇',
        atkdefup: '攻撃力/防御力上昇',
        atkspeedup: '攻撃力/移動速度上昇',
        defspeedup: '防御力/移動速度上昇',
        cure_blind: '暗闇解除',
        cure_poison: '毒解除',
        cure_seal: '封印解除',
        cure_slow: 'スロウ解除',
        cure_weaken: '衰弱解除',
        cure_all: '状態異常解除'
      }
    },
    killer: {
      name: '特定の敵に強い',
      effect: {
        atkup: '攻撃力上昇',
        atkdefup: '攻撃力/防御力上昇'
      }
    },
    mana: {
      name: 'マナ関連',
      effect: {
        mana_charge: 'マナを持って戦闘開始',
        mana_boost: 'スロットで複数マナが出やすい',
        mana_drop: 'マナを落とす',
        slot_slow: 'マナスロットが遅くなる',
        composite: '複合マナ出現',
        recycle_scrap: 'スクラップをマナに変換',
        destroy_scrap: 'スクラップを破壊'
      }
    },
    field: {
      name: '特定のフィールドに強い',
      effect: {
        atkup: '攻撃力上昇',
        atkdefup: '攻撃力/防御力上昇',
        atkspeedup: '攻撃力/移動速度上昇',
        fullup: '攻撃力/防御力/移動速度上昇'
      }
    },
    combat: {
      name: '接近戦可能',
      effect: {
        combat: '接近戦可能'
      }
    },
    pierce: {
      name: '貫通',
      effect: {
        pierce: '貫通する'
      }
    },
    counter: {
      name: 'カウンター',
      effect: {
        counterattack: 'カウンター攻撃',
        reflect_magic: '魔法反射'
      }
    },
    invincible: {
      name: '無敵',
      effect: {
        invincible: '無敵になる'
      }
    },
    resource: {
      name: 'ゴールド/経験値/AP関連',
      effect: {
        expup: '獲得経験値上昇',
        goldup: '獲得ゴールド上昇',
        treasure: '宝箱が出やすくなる',
        ap_recover: 'APを回復'
      }
    },
    buff_one: {
      name: '誰か一人を強化',
      effect: {
        atkup: '攻撃力上昇',
        defup: '防御力上昇',
        atkdefup: '攻撃力/防御力上昇',
        defspeedup: '防御力/移動速度上昇',
        fullup: '攻撃力/防御力/移動速度上昇',
        critup: 'クリティカル率上昇'
      }
    },
    buff_self: {
      name: '自分を強化（その他）',
      effect: {
        atkup: '攻撃力上昇',
        defup: '防御力上昇',
        speedup: '移動速度上昇',
        atkdefup: '攻撃力/防御力上昇',
        atkspeedup: '攻撃力/移動速度上昇',
        defspeedup: '防御力/移動速度上昇',
        fullup: '攻撃力/防御力/移動速度上昇',
        critup: 'クリティカル率上昇',
        guardup: '遠距離ダメージカット上昇',
        delayoff: '攻撃速度上昇',
        maxhpup: '最大HP増加',
        mana_cost_down: 'スキルの消費マナ低下',
        guard_fire: '火属性を軽減する',
        guard_ice: '氷属性を軽減する',
        areaup: '回復範囲増加',
        healup: '回復効果上昇',
        healareaup: '回復範囲/効果上昇',
        poison_atkup: '毒ダメージ上昇',
        blind_boost: '暗闇の効果延長',
        registup: '魔法ダメージ軽減',
        combat: '接近戦可能',
        invisible: '見えなくなる（遠距離無効）',
        bullet_speedup: '弾速上昇',
        skill_once: '一度だけスキルが使える'
      }
    },
    unknown: {
      name: '（不明）',
      effect: {
        unknown: '（不明）'
      }
    }
  }.freeze

  EFFECTS = lambda do
    ret = {}
    CATEGORYS.values.each do |v|
      ret.merge!(v.fetch(:effect, {}))
    end
    ret
  end.call.freeze

  CATEGORY_CONDS = lambda do
    ret = []
    CATEGORYS.each do |k, v|
      next if k == :unknown
      ret << [k, v[:name]]
    end
    ret
  end.call.freeze

  EFFECT_CONDS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      next if k == :unknown
      ret[k] = v.fetch(:effect, {}).to_a
    end
    ret
  end.call.freeze

  TARGETS = {
    all: '全員',
    archer: '弓使い',
    enemy: '敵',
    fighter: '戦士',
    hp_worst: '一番ダメージが大きい対象',
    jobs: '特定の職',
    knight: '騎士',
    lv_worst: '一番レベルが低い対象',
    magician: '魔法使い',
    other: '他者',
    priest: '僧侶',
    random: 'ランダム',
    resource: '',
    self: '自分',
    weapons: '特定の武器タイプ'
  }.freeze

  CONDITIONS = {
    add_blind: '暗闇を与えた時',
    add_down: 'ダウンさせた時',
    add_poison: '毒を与えた時',
    add_slow: 'スロウを与えた時',
    add_curse: '呪いを与えた時',
    any: 'いつでも',
    attack: '通常攻撃時',
    battle_end: '戦闘終了時',
    battle_start: '戦闘開始時',
    boss_wave: 'BOSS WAVE時',
    counter: 'カウンター発生時',
    critical: 'クリティカル時',
    defend: '攻撃を受けた時',
    dropout_member: '味方が脱落した時',
    dropout_self: '自身が脱落した時',
    enemys_debuff: '敵に状態異常が多いほど',
    for_blind: '敵が暗闇の時',
    for_curse: '敵が呪いの時',
    for_down: '敵がダウン中',
    for_freeze: '敵が凍結の時',
    for_poison: '敵が毒の時',
    for_slow: '敵がスロウの時',
    for_weaken: '敵が衰弱の時',
    guard: 'ガードした時',
    has_mana: '特定のマナを保持している時',
    heal: '回復した時',
    hp_downto: 'HPが一定以下の時',
    hp_full: 'HPが満タンの時',
    hp_upto: 'HPが一定以上の時',
    in_attacking: '攻撃を継続している時',
    in_base_area: '自陣にいる時',
    in_blind: '自分が暗闇状態の時',
    in_combo: '攻撃を一定回数当てた時',
    in_chain: 'チェイン発動中',
    in_curse: '自分が呪い状態の時',
    in_debuff: '自分が状態異常の時',
    in_enemy_area: '敵陣にいる時',
    in_enemy_back: '敵陣の奥にいる時',
    in_field: '特定のフィールドで',
    in_front: '仲間より前にいる時',
    in_head: '先頭にいる時',
    in_move: '移動中',
    in_pierce: '貫通した時',
    in_poison: '自分が毒状態の時',
    in_rear: '仲間より後ろにいる時',
    in_seal: '自分が封印状態の時',
    in_slow: '自分がスロウ状態の時',
    in_sub: 'サブパーティーにいる時',
    in_tail: '一番後ろにいる時',
    in_weaken: '自分が衰弱状態の時',
    kill: '敵を倒した時',
    kill_debuff: '状態異常の敵を倒した時',
    link: '複数で一緒に攻撃した時',
    mana_charged: 'マナが多いほど',
    mana_droped: 'マナを獲得した時',
    mana_empty: 'マナがない時',
    mana_lost: 'マナが少ないほど',
    members_debuff: '味方に状態異常が多いほど',
    others_skill: '味方がスキルを使った時',
    own_skill: '自分がスキルを使った時',
    same_abilities: '同じアビリティを持った味方がいる時',
    scrap_charged: 'スクラップが多いほど',
    skill: 'スキル使用時',
    union: '特定の構成の時',
    vs_beast: 'ビーストに対して',
    vs_bird: '鳥に対して',
    vs_black: '黒の軍勢に対して',
    vs_dragon: 'ドラゴンに対して',
    vs_fish: '魚類に対して',
    vs_ghost: 'ゴーストに対して',
    vs_goblin: 'ゴブリンに対して',
    vs_golem: 'ゴーレムに対して',
    vs_human: '人間に対して',
    vs_insect: '虫に対して',
    vs_machine: '機械に対して',
    vs_lizard: 'トカゲに対して',
    vs_ogre: '鬼に対して',
    vs_skeleton: 'ガイコツに対して',
    waiting: '何もしていない間',
    wave_start: '各WAVE開始時',
    use_mana: 'マナが使用された時',
    unknown: '（不明）'
  }.freeze

  validates :order,
            presence: true,
            numericality: { only_integer: true }
  validates :category,
            presence: true,
            length: { maximum: 100 }
  validates :condition,
            presence: true,
            length: { maximum: 100 }
  validates :effect,
            presence: true,
            length: { maximum: 100 }
  validates :target,
            presence: true,
            length: { maximum: 100 }
  validates :note,
            length: { maximum: 300 }

  def serialize
    excepts = %w(id ability_id created_at updated_at)
    ef = self.as_json(except: excepts)

    ef['category'] = CATEGORYS.fetch(self.category.to_sym, '')
    ef['condition'] = CONDITIONS.fetch(self.condition.to_sym, '')
    ef['effect'] = EFFECTS.fetch(self.effect.to_sym, '')
    ef['target'] = TARGETS.fetch(self.target.to_sym, '')

    ef
  end

end
