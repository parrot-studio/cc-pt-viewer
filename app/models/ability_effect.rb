# == Schema Information
#
# Table name: ability_effects
#
#  id         :integer          not null, primary key
#  ability_id :integer          not null
#  order      :integer          not null
#  category   :string(100)      not null
#  condition  :string(100)      not null
#  effect     :string(100)      not null
#  target     :string(100)      not null
#  note       :string(300)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ability_effects_on_ability_id                         (ability_id)
#  index_ability_effects_on_category                           (category)
#  index_ability_effects_on_category_and_condition             (category,condition)
#  index_ability_effects_on_category_and_condition_and_effect  (category,condition,effect)
#  index_ability_effects_on_category_and_effect                (category,effect)
#

class AbilityEffect < ApplicationRecord
  belongs_to :ability

  scope :exclude_chain, -> { where.not(ability_id: Ability.chain_ability_ids) }
  scope :only_chain, -> { where(ability_id: Ability.chain_ability_ids) }

  CATEGORYS = {
    buff_self: {
      name: '自分を強化',
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        cup: 'クリティカル率上昇',
        rup: 'クリティカルダメージ上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        dsup: '防御力/移動速度上昇',
        drup: '防御力/クリティカルダメージ上昇',
        acup: '攻撃力/クリティカル率上昇',
        dcup: '防御力/クリティカル率上昇',
        scup: '移動速度/クリティカル率上昇',
        arup: '攻撃力/クリティカルダメージ上昇',
        srup: '移動速度/クリティカルダメージ上昇',
        crup: 'クリティカル率/クリティカルダメージ上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        ascup: '攻撃力/移動速度/クリティカル率上昇',
        asrup: '攻撃力/移動速度/クリティカルダメージ上昇',
        acrup: '攻撃力/クリティカル率/クリティカルダメージ上昇',
        dcrup: '防御力/クリティカル率/クリティカルダメージ上昇',
        scrup: '移動速度/クリティカル率/クリティカルダメージ上昇',
        adscup: '攻撃力/防御力/移動速度/クリティカル率上昇',
        adsrup: '攻撃力/防御力/移動速度/クリティカルダメージ上昇',
        adcrup: '攻撃力/防御力/クリティカル率/クリティカルダメージ上昇',
        ascrup: '攻撃力/移動速度/クリティカル率/クリティカルダメージ上昇',
        guardup: '遠距離ダメージカット上昇',
        delayoff: '攻撃速度上昇',
        maxhpup: '最大HP増加',
        guard_fire: '火属性を軽減する',
        guard_ice: '氷属性を軽減する',
        areaup: '回復範囲増加',
        healup: '回復効果上昇',
        healareaup: '回復範囲/効果上昇',
        areashift: '回復範囲移動',
        healdelayoff: '回復後の硬直時間減少',
        poison_atkup: '毒ダメージ上昇',
        blind_boost: '暗闇の効果延長',
        down_boost: 'ダウンの効果延長',
        slow_boost: 'スロウの効果延長',
        registup: '魔法ダメージ軽減',
        invisible: '姿を消す（遠距離無効）',
        single_shoot: '単発射撃',
        bullet_speedup: '弾速上昇',
        rapid_shoot: '弾数増加',
        barrier: 'バリアを張る',
        skill_once: '一度だけスキルが使える',
        mana_cost_down: 'スキルの消費マナ低下',
        super_skill: '超必殺技使用可能'
      },
      condition: {
        any: 'いつでも',
        hp_upto: 'HPが一定以上の時',
        hp_downto: 'HPが一定以下の時',
        hp_full: 'HPが満タンの時',
        attack: '通常攻撃時',
        heal: '回復した時',
        in_move: '移動中',
        in_pierce: '貫通した時',
        link: '複数で一緒に攻撃した時',
        guard: 'ガードした時',
        damaged: 'ダメージを受けた時',
        waiting: '何もしていない間',
        staying: '移動していない間',
        counter: 'カウンター発生時',
        wave_start: '各WAVE開始時',
        boss_wave: 'BOSS WAVE時',
        with_f: '戦士がいる時',
        with_k: '騎士がいる時',
        with_a: '弓使いがいる時',
        with_p: '僧侶がいる時',
        with_m: '魔法使いがいる時',
        with_fa: '戦＋弓がいる時',
        with_sl: '<<斬>>がいる時',
        with_bl: '<<打>>がいる時',
        with_pi: '<<突>>がいる時',
        with_ar: '<<弓>>がいる時',
        with_ma: '<<魔>>がいる時',
        with_he: '<<聖>>がいる時',
        with_pu: '<<拳>>がいる時',
        with_gu: '<<銃>>がいる時',
        with_sh: '<<狙>>がいる時',
        with_guildtown: '所属：副都がいる時',
        with_holytown: '所属：聖都がいる時',
        with_forest: '所属：精霊島がいる時',
        with_volcano: '所属：九領がいる時',
        with_beasts: '所属：ケ者がいる時',
        with_demon: '所属：魔神がいる時',
        same_abilities: '同じアビリティを持った味方がいる時',
        kill: '敵を倒した時',
        kill_debuff: '状態異常の敵を倒した時',
        combat: '近接戦闘時',
        in_head: '先頭にいる時',
        in_front: '仲間より前にいる時',
        in_enemy_area: '敵陣にいる時',
        in_enemy_back: '敵陣の奥にいる時',
        in_base_area: '自陣にいる時',
        in_rear: '仲間より後ろにいる時',
        in_tail: '一番後ろにいる時',
        in_back: '一番後列にいる時',
        in_combo: '攻撃を一定回数当てた時',
        in_attacking: '攻撃を当てた時',
        in_invisible: '姿を消している時',
        own_skill: '自分がスキルを使った時',
        others_skill: '味方がスキルを使った時',
        skill_hit: 'スキルが当たる毎に',
        in_chain: 'チェイン発動中',
        mana_charged: 'マナが多いほど',
        mana_lost: 'マナが少ないほど',
        mana_droped: 'マナを獲得した時',
        mana_empty: 'マナがない時',
        mana_mixed: 'マナの種類が多いほど',
        use_mana: 'マナが使用された時',
        scrap_charged: 'スクラップが多いほど',
        has_mana: 'マナを保持している時',
        dropout_member: '味方が脱落した時',
        dropout_self: '自身が脱落した時',
        members_debuff: '味方に状態異常が多いほど',
        enemys_debuff: '敵に状態異常が多いほど',
        super_gauge_max: '超必殺技ゲージがMAXの時',
        add_debuff: '状態異常を付与した時',
        after_move: '一定距離を移動した時',
        in_awakening: '覚醒ゲージがMAXの時'
      },
      target: {
        self: '自分'
      }
    },
    buff_all: {
      name: '全体を強化',
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        cup: 'クリティカル率上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        dsup: '防御力/移動速度上昇',
        acup: '攻撃力/クリティカル率上昇',
        dcup: '防御力/クリティカル率上昇',
        scup: '移動速度/クリティカル率上昇',
        crup: 'クリティカル率/クリティカルダメージ上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        acrup: '攻撃力/クリティカル率/クリティカルダメージ上昇',
        barrier: 'バリアを張る',
        super_gauge_gain: '超必殺技ゲージ上昇'
      },
      condition: {
        any: 'いつでも',
        in_sub: 'サブパーティーにいる時',
        wave_start: '各WAVE開始時',
        boss_wave: 'BOSS WAVE時',
        own_skill: '自分がスキルを使った時',
        others_skill: '味方がスキルを使った時',
        any_skill: '誰かがスキルを使った時',
        dropout_self: '自身が脱落した時',
        dropout_member: '味方が脱落した時',
        mana_charged: 'マナが多いほど',
        mana_slot_many: 'マナスロットが多いほど',
        mana_droped: 'マナを獲得した時',
        kill: '敵を倒した時',
        super_gauge_max: '超必殺技ゲージがMAXの時'
      },
      target: {
        all: '全員'
      }
    },
    buff_others: {
      name: '自分以外の全体を強化',
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        cup: 'クリティカル率上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        acup: '攻撃力/クリティカル率上昇',
        dsup: '防御力/移動速度上昇',
        adsup: '攻撃力/防御力/移動速度上昇'
      },
      condition: {
        any: 'いつでも',
        wave_start: '各WAVE開始時',
        others_skill: '味方がスキルを使った時'
      },
      target: {
        all: '全員',
        job_f: '戦士',
        job_k: '騎士',
        job_a: '弓使い',
        job_m: '魔法使い',
        job_fk: '戦/騎',
        job_fa: '戦/弓',
        job_fm: '戦/魔',
        job_kahm: '騎/弓/僧/魔'
      }
    },
    buff_jobs: {
      name: '特定の職を強化',
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        cup: 'クリティカル率上昇',
        rup: 'クリティカルダメージ上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        dsup: '防御力/移動速度上昇',
        acup: '攻撃力/クリティカル率上昇',
        scup: '移動速度/クリティカル率上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        adrup: '攻撃力/防御力/クリティカルダメージ上昇',
        ascup: '攻撃力/移動速度/クリティカル率上昇',
        adscup: '攻撃力/防御力/移動速度/クリティカル率上昇',
        add_slow: '対象の攻撃にスロウを付与',
        barrier: 'バリアを張る'
      },
      condition: {
        any: 'いつでも',
        with_f: '戦士がいる時',
        with_k: '騎士がいる時',
        with_a: '弓使いがいる時',
        with_m: '魔法使いがいる時',
        with_fk: '戦＋騎がいる時',
        with_fa: '戦＋弓がいる時',
        with_fm: '戦＋魔がいる時',
        with_ka: '騎＋弓がいる時',
        with_kh: '騎＋僧がいる時',
        with_ap: '弓＋僧がいる時',
        with_kap: '騎＋弓＋僧がいる時',
        wave_start: '各WAVE開始時',
        in_sub: 'サブパーティーにいる時'
      },
      target: {
        job_f: '戦士',
        job_k: '騎士',
        job_a: '弓使い',
        job_h: '僧侶',
        job_m: '魔法使い',
        job_fk: '戦/騎',
        job_fa: '戦/弓',
        job_fm: '戦/魔',
        job_ka: '騎/弓',
        job_kh: '騎/僧',
        job_km: '騎/魔',
        job_ah: '弓/僧',
        job_am: '弓/魔',
        job_fkh: '戦/騎/僧',
        job_fah: '戦/弓/僧',
        job_fkah: '戦/騎/弓/僧',
        job_ahm: '弓/僧/魔'
      }
    },
    buff_weapons: {
      name: '特定の武器タイプを強化',
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        cup: 'クリティカル率上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        acup: '攻撃力/クリティカル率上昇',
        scup: '移動速度/クリティカル率上昇',
        crup: 'クリティカル率/クリティカルダメージ上昇',
        adsup: '攻撃力/防御力/移動速度上昇'
      },
      condition: {
        any: 'いつでも',
        with_f: '戦士がいる時',
        with_a: '弓使いがいる時'
      },
      target: {
        weapon_sl: '<<斬>>',
        weapon_bl: '<<打>>',
        weapon_pi: '<<突>>',
        weapon_ar: '<<弓>>',
        weapon_ma: '<<魔>>',
        weapon_pu: '<<拳>>',
        weapon_gu: '<<銃>>',
        weapon_sh: '<<狙>>',
        weapon_slma: '<<斬/魔>>',
        weapon_blpi: '<<打/突>>',
        weapon_gush: '<<銃/狙>>',
        weapon_slblpipu: '<<斬/打/突/拳>>'
      }
    },
    buff_group: {
      name: '特定の所属を強化',
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        cup: 'クリティカル率上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        acup: '攻撃力/クリティカル率上昇',
        dcup: '防御力/クリティカル率上昇',
        scup: '移動速度/クリティカル率上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        adscup: '攻撃力/防御力/移動速度/クリティカル率上昇',
        add_down: '対象の攻撃にダウンを付与',
        add_slow: '対象の攻撃にスロウを付与',
        add_poison: '対象の攻撃に毒を付与',
        add_shield_break: '盾破壊付与'
      },
      condition: {
        group_guildtown: '副都所属',
        group_holytown: '聖都所属',
        group_academy: '賢者の塔所属',
        group_mountain: '迷宮山脈所属',
        group_oasis: '湖都所属',
        group_forest: '精霊島所属',
        group_volcano: '九領所属',
        group_dawnsea: '大海所属',
        group_beasts: 'ケ者所属',
        group_criminal: '罪の大陸所属',
        group_machine: '鉄煙所属',
        group_chronicle: '年代記所属',
        group_remless: 'レムレス島所属',
        group_volunteers: '義勇軍所属',
        group_demon: '魔神所属',
        group_sakurawar: '華劇団所属',
        group_others: '旅人所属'
      },
      target: {
        all: '全員',
        job_f: '戦士',
        job_k: '騎士',
        job_m: '魔法使い',
        job_fk: '戦/騎',
        job_fa: '戦/弓',
        job_fm: '戦/魔',
        job_am: '弓/魔',
        weapon_argush: '<<弓/銃/狙>>'
      }
    },
    buff_one: {
      name: '誰か一人を強化',
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        cup: 'クリティカル率上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        acup: '攻撃力/クリティカル率上昇',
        dsup: '防御力/移動速度上昇',
        scup: '移動速度/クリティカル率上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        scrup: '移動速度/クリティカル率/クリティカルダメージ上昇',
        adscup: '攻撃力/防御力/移動速度/クリティカル率上昇',
        adscrup: '攻撃力/防御力/移動速度/クリティカル率/クリティカルダメージ上昇',
        barrier: 'バリアを張る'
      },
      condition: {
        wave_start: '各WAVE開始時'
      },
      target: {
        hp_worst: '一番ダメージが大きい対象',
        nearest: '一番近い対象',
        random: 'ランダム',
        job_f: '戦士',
        job_k: '騎士',
        job_a: '弓使い',
        job_m: '魔法使い'
      }
    },
    skillup: {
      name: '自分のスキルを強化',
      effect: {
        skill_atkup: 'スキル威力上昇',
        skill_boost: 'スキル強化',
        charge_reduce: '溜め時間減少',
        skill_spread: 'スキル範囲拡大'
      },
      condition: {
        any: 'いつでも',
        skill: 'スキル使用時',
        in_combo: '攻撃を一定回数当てた時',
        others_skill: '味方がスキルを使った時',
        mana_charged: 'マナが多いほど',
        mana_lost: 'マナが少ないほど',
        guard: 'ガードした時',
        scrap_charged: 'スクラップが多いほど'
      },
      target: {
        self: '自分'
      }
    },
    element: {
      name: '属性攻撃',
      effect: {
        fire: '火属性',
        ice: '氷属性'
      },
      condition: {
        attack: '通常攻撃時',
        skill: 'スキル使用時'
      },
      target: {
        self: '自分'
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
        absorb: '与えたダメージを吸収',
        heal_action: '回復行動を取る'
      },
      condition: {
        any: 'いつでも',
        wave_start: '各WAVE開始時',
        boss_wave: 'BOSS WAVE時',
        attack: '通常攻撃時',
        critical: 'クリティカル時',
        in_base_area: '自陣にいる時',
        in_enemy_area: '敵陣にいる時',
        in_enemy_back: '敵陣の奥にいる時',
        in_head: '先頭にいる時',
        in_front: '仲間より前にいる時',
        in_rear: '仲間より後ろにいる時',
        in_tail: '後ろに仲間がいない時',
        in_back: '一番後列にいる時',
        in_sub: 'サブパーティーにいる時',
        skill: 'スキル使用時',
        others_skill: '味方がスキルを使った時',
        any_skill: '誰かがスキルを使った時',
        with_f: '戦士がいる時',
        with_k: '騎士がいる時',
        with_a: '弓使いがいる時',
        with_p: '僧侶がいる時',
        with_gu: '<<銃>>がいる時',
        with_sh: '<<狙>>がいる時',
        link: '複数で一緒に攻撃した時',
        dropout_self: '自身が脱落した時',
        dropout_member: '味方が脱落した時',
        in_debuff: '自分が状態異常の時',
        members_debuff: '味方に状態異常が多いほど',
        enemys_debuff: '敵に状態異常が多いほど',
        has_mana: 'マナを保持している時',
        use_mana: 'マナが使用された時',
        mana_droped: 'マナを獲得した時',
        kill: '敵を倒した時',
        super_gauge_max: '超必殺技ゲージがMAXの時'
      },
      target: {
        self: '自分',
        all: '全員',
        hp_worst: '一番ダメージが大きい対象',
        lv_worst: '一番レベルが低い対象',
        nearest: '一番近い対象',
        job_f: '戦士',
        job_k: '騎士',
        job_fk: '戦/騎',
        weapon_sl: '<<斬>>',
        weapon_blpi: '<<打/突>>'
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
        tumble: '転倒付与',
        atkdown: '攻撃力低下',
        defdown: '防御力低下',
        speeddown: '移動速度低下',
        atkdefdown: '攻撃力/防御力低下',
        atkspeeddown: '攻撃力/移動速度低下',
        defspeeddown: '防御力/移動速度低下',
        fulldown: '攻撃力/防御力/移動速度低下',
        delayup: '攻撃速度低下',
        shield_break: '盾を破壊する'
      },
      condition: {
        attack: '通常攻撃時',
        critical: 'クリティカル時',
        skill: 'スキル使用時',
        counter: 'カウンター発生時',
        add_poison: '毒を与えた時',
        add_blind: '暗闇を与えた時',
        add_slow: 'スロウを与えた時',
        add_down: 'ダウンさせた時',
        add_curse: '呪いを与えた時'
      },
      target: {
        enemy: '敵'
      }
    },
    against_debuff: {
      name: '状態異常防御',
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
        guard_hitstop: '遠距離でのけぞらない',
        reduce_poison: '毒のダメージを減らす',
        reduce_weaken: '衰弱のダメージを減らす',
        reduce_slow: 'スロウからの回復時間減少',
        reduce_down: 'ダウンからの回復時間減少',
        reduce_blind: '暗闇からの回復時間減少',
        reduce_freeze: '凍結からの回復時間減少',
        reduce_seal: '封印からの回復時間減少'
      },
      condition: {
        any: 'いつでも'
      },
      target: {
        self: '自分'
      }
    },
    for_debuff: {
      name: '状態異常の敵に強い',
      effect: {
        aup: '攻撃力上昇',
        adup: '攻撃力/防御力上昇'
      },
      condition: {
        for_poison: '敵が毒の時',
        for_blind: '敵が暗闇の時',
        for_down: '敵がダウン中',
        for_slow: '敵がスロウの時',
        for_freeze: '敵が凍結の時',
        for_curse: '敵が呪いの時',
        for_weaken: '敵が衰弱の時'
      },
      target: {
        self: '自分'
      }
    },
    in_debuff: {
      name: '状態異常時強化',
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        cup: 'クリティカル率上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        dsup: '防御力/移動速度上昇'
      },
      condition: {
        in_poison: '毒状態の時',
        in_slow: 'スロウ状態の時',
        in_blind: '暗闇状態の時',
        in_curse: '呪い状態の時',
        in_weaken: '衰弱状態の時',
        in_seal: '封印状態の時',
        in_debuff: '状態異常の時'
      },
      target: {
        self: '自分',
        all: '全員'
      }
    },
    cure_debuff: {
      name: '状態異常解除',
      effect: {
        cure_blind: '暗闇解除',
        cure_poison: '毒解除',
        cure_seal: '封印解除',
        cure_slow: 'スロウ解除',
        cure_weaken: '衰弱解除',
        cure_curse: '衰弱解除',
        cure_down: 'ダウン解除',
        cure_all: '状態異常解除'
      },
      condition: {
        skill: 'スキル使用時',
        wave_start: '各WAVE開始時',
        use_mana: 'マナが使用された時'
      },
      target: {
        self: '自分',
        all: '全員',
        job_k: '騎士'
      }
    },
    killer: {
      name: '特定の敵に強い',
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        adup: '攻撃力/防御力上昇'
      },
      condition: {
        vs_human: '人間に対して',
        vs_goblin: 'ゴブリンに対して',
        vs_skeleton: 'ガイコツに対して',
        vs_beast: 'ビーストに対して',
        vs_lizard: 'トカゲに対して',
        vs_ogre: '鬼に対して',
        vs_black: '黒の軍勢に対して',
        vs_ghost: 'ゴーストに対して',
        vs_golem: 'ゴーレムに対して',
        vs_dragon: 'ドラゴンに対して',
        vs_fish: '魚類に対して',
        vs_insect: '虫に対して',
        vs_bird: '鳥に対して',
        vs_boar: 'イノシシに対して',
        vs_machine: '機械に対して',
        vs_giant: '巨人に対して',
        vs_white: '白き異形に対して'
      },
      target: {
        self: '自分'
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
      },
      condition: {
        any: 'いつでも',
        battle_start: '戦闘開始時',
        wave_start: '各WAVE開始時',
        boss_wave: 'BOSS WAVE時',
        wave_span: '一定WAVE進むごとに',
        kill: '敵を倒した時',
        dropout_self: '自身が脱落した時',
        own_skill: '自分がスキルを使った時',
        in_chain: 'チェイン発動中'
      },
      target: {
        resource: ''
      }
    },
    field: {
      name: '特定のフィールドに強い',
      effect: {
        aup: '攻撃力上昇',
        sup: '移動速度上昇',
        cup: 'クリティカル率上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        acup: '攻撃力/クリティカル率上昇',
        dsup: '防御力/移動速度上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇'
      },
      condition: {
        in_town: '市街で戦闘時',
        in_forest: '森林で戦闘時',
        in_cave: '洞窟で戦闘時',
        in_castle: '城中で戦闘時',
        in_desert: '砂漠で戦闘時',
        in_ruins: '遺跡で戦闘時',
        in_wasteland: '荒地で戦闘時',
        in_battlefield: '戦場で戦闘時',
        in_beach: '砂浜で戦闘時',
        in_ship: '船上で戦闘時',
        in_upland: '高地で戦闘時',
        in_snow: '雪山で戦闘時',
        in_sea: '海中で戦闘時',
        in_prison: '監獄で戦闘時',
        in_night: '夜間に戦闘時',
        in_dimension: '異空間で戦闘時'
      },
      target: {
        self: '自分',
        all: '全員'
      }
    },
    combat: {
      name: '接近戦可能',
      effect: {
        combat: '接近戦可能'
      },
      condition: {
        attack: '通常攻撃時'
      },
      target: {
        self: '自分'
      }
    },
    pierce: {
      name: '貫通',
      effect: {
        pierce: '貫通する'
      },
      condition: {
        attack: '通常攻撃時',
        kill: '敵を倒した時',
        skill: 'スキル使用時',
        in_combo: '攻撃を一定回数当てた時'
      },
      target: {
        enemy: '敵'
      }
    },
    counter: {
      name: 'カウンター',
      effect: {
        counterattack: 'カウンター攻撃',
        reflect_arrow: '遠距離反射',
        reflect_magic: '魔法反射'
      },
      condition: {
        defend: '攻撃を受けた時',
        guard: 'ガードした時'
      },
      target: {
        enemy: '敵'
      }
    },
    invincible: {
      name: '無敵',
      effect: {
        invincible: '無敵になる'
      },
      condition: {
        dropout_self: '自身が脱落した時'
      },
      target: {
        self: '自分'
      }
    },
    resource: {
      name: 'ゴールド/経験値/AP関連',
      effect: {
        expup: '獲得経験値上昇',
        goldup: '獲得ゴールド上昇',
        treasure: '宝箱が出やすくなる',
        ap_recover: 'APを回復'
      },
      condition: {
        battle_start: '戦闘開始時',
        battle_end: '戦闘終了時'
      },
      target: {
        resource: ''
      }
    },
    unknown: {
      name: '（不明）',
      effect: {
        unknown: ''
      },
      condition: {
        unknown: ''
      },
      target: {
        unknown: ''
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

  CONDITIONS = lambda do
    ret = {}
    CATEGORYS.values.each do |v|
      ret.merge!(v.fetch(:condition, {}))
    end
    ret
  end.call.freeze

  TARGETS = lambda do
    ret = {}
    CATEGORYS.values.each do |v|
      ret.merge!(v.fetch(:target, {}))
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

  CONDITION_CONDS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      next if k == :unknown
      ret[k] = v.fetch(:condition, {}).to_a
    end
    ret
  end.call.freeze

  TARGET_CONDS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      next if k == :unknown
      ret[k] = v.fetch(:target, {}).to_a
    end
    ret
  end.call.freeze

  BUFF_TYPES = lambda do
    CATEGORYS[:buff_self][:effect].keys.select { |k| k.match(/\A[a|d|s|c|r]+up\z/) }.map(&:to_s)
  end.call

  EFFECT_GROUP = {
    aup: BUFF_TYPES.select { |s| s.match(/a/) },
    dup: BUFF_TYPES.select { |s| s.match(/d/) },
    sup: BUFF_TYPES.select { |s| s.match(/s/) },
    cup: BUFF_TYPES.select { |s| s.match(/c/) },
    rup: BUFF_TYPES.select { |s| s.match(/r/) },
    areaup: %w[healareaup areashift],
    healup: %w[healareaup],
    atkdown: %w[atkdefdown atkspeeddown fulldown],
    defdown:  %w[atkdefdown defspeeddown fulldown],
    speeddown: %w[atkspeeddown defspeeddown fulldown],
    guard_blind: ['guard_all'],
    guard_curse: ['guard_all'],
    guard_down: ['guard_all'],
    guard_freeze: ['guard_all'],
    guard_poison: ['guard_all'],
    guard_push: ['guard_all'],
    guard_seal: ['guard_all'],
    guard_slow: ['guard_all'],
    guard_undead: ['guard_all'],
    guard_weaken: ['guard_all'],
    cure_blind: ['cure_all'],
    cure_poison: ['cure_all'],
    cure_seal: ['cure_all'],
    cure_slow: ['cure_all'],
    cure_weaken: ['cure_all'],
    cure_curse: ['cure_all'],
    cure_down: ['cure_all']
  }.freeze

  TARGET_GROUP = {
    job_f: %w[job_fk job_fa job_fm job_fkh job_fah job_fkah],
    job_k: %w[job_fk job_ka job_kh job_km job_fkh job_fkah job_kahm],
    job_a: %w[job_fa job_ka job_ah job_am job_fah job_fkah job_kahm],
    job_h: %w[job_kh job_ah job_fkh job_fah job_fkah job_kahm],
    job_m: %w[job_fm job_km job_am job_kahm],
    weapon_sl: %w[weapon_slma weapon_slblpipu],
    weapon_bl: %w[weapon_blpi weapon_slblpipu],
    weapon_pi: %w[weapon_blpi weapon_slblpipu],
    weapon_pu: %w[weapon_slblpipu],
    weapon_ar: %w[weapon_argush],
    weapon_ma: %w[weapon_slma],
    weapon_gu: %w[weapon_gush weapon_argush],
    weapon_sh: %w[weapon_gush weapon_argush]
  }.freeze

  class << self
    def chain_ability_categorys
      cs = Ability.chain_ability_ids
      keys = AbilityEffect.where(ability_id: cs).uniq.pluck(:category)

      ret = []
      CATEGORYS.each do |k, v|
        next if k == :unknown
        next unless keys.include?(k.to_s)
        ret << [k, v[:name]]
      end
      ret
    end

    def chain_ability_effects
      create_chain_conds(:effect)
    end

    def chain_ability_conditions
      create_chain_conds(:condition)
    end

    def chain_ability_targets
      create_chain_conds(:target)
    end

    private

    def create_chain_conds(key)
      cs = Ability.chain_ability_ids
      conds = AbilityEffect.where(ability_id: cs).select(:category, key).distinct.pluck(:category, key)
      cos = conds.each_with_object({}) do |co, h|
        cate = co.first.to_sym
        h[cate] ||= []
        h[cate] << co.last.to_sym
      end

      ret = {}
      CATEGORYS.each do |k, v|
        next if k == :unknown
        has = cos[k]
        next unless has

        ret[k] = []
        v.fetch(key, {}).each do |co, name|
          next unless has.include?(co)
          ret[k] << [co, name]
        end
      end
      ret
    end
  end

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
    ef = {}
    ef['category'] = CATEGORYS.fetch(self.category.to_sym, {}).fetch(:name, '')
    ef['condition'] = CONDITIONS.fetch(self.condition.to_sym, '')
    ef['effect'] = EFFECTS.fetch(self.effect.to_sym, '')
    ef['target'] = TARGETS.fetch(self.target.to_sym, '')
    ef['note'] = self.note
    ef
  end
end
