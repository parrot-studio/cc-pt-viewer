# == Schema Information
#
# Table name: ability_effects
#
#  id             :bigint(8)        not null, primary key
#  ability_id     :integer          not null
#  order          :integer          not null
#  category       :string(100)      not null
#  condition      :string(100)      not null
#  sub_condition  :string(100)      not null
#  condition_note :string(100)      default(""), not null
#  effect         :string(100)      not null
#  sub_effect     :string(100)      not null
#  effect_note    :string(100)      default(""), not null
#  target         :string(100)      not null
#  sub_target     :string(100)      not null
#  target_note    :string(100)      default(""), not null
#  note           :string(300)      default(""), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  condition                            (category,condition,sub_condition)
#  effect                               (category,effect,sub_effect)
#  full                                 (category,condition,effect,target)
#  index_ability_effects_on_ability_id  (ability_id)
#  target                               (category,target,sub_target)
#

# rubocop:disable Metrics/ClassLength, Metrics/MethodLength, Metrics/AbcSize
class AbilityEffect < ApplicationRecord
  belongs_to :ability, inverse_of: :ability_effects

  CATEGORYS = {
    buff_self: {
      name: '自分を強化',
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        cup: 'クリティカル率上昇',
        rup: 'クリティカル威力上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        arup: '攻撃力/クリティカル威力上昇',
        dsup: '防御力/移動速度上昇',
        drup: '防御力/クリティカル威力上昇',
        acup: '攻撃力/クリティカル率上昇',
        dcup: '防御力/クリティカル率上昇',
        scup: '移動速度/クリティカル率上昇',
        srup: '移動速度/クリティカル威力上昇',
        crup: 'クリティカル率/クリティカル威力上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        adrup: '攻撃力/防御力/クリティカル威力上昇',
        ascup: '攻撃力/移動速度/クリティカル率上昇',
        asrup: '攻撃力/移動速度/クリティカル威力上昇',
        acrup: '攻撃力/クリティカル率/クリティカル威力上昇',
        dscup: '防御力/移動速度/クリティカル率上昇',
        dcrup: '防御力/クリティカル率/クリティカル威力上昇',
        scrup: '移動速度/クリティカル率/クリティカル威力上昇',
        adscup: '攻撃力/防御力/移動速度/クリティカル率上昇',
        adsrup: '攻撃力/防御力/移動速度/クリティカル威力上昇',
        adcrup: '攻撃力/防御力/クリティカル率/クリティカル威力上昇',
        ascrup: '攻撃力/移動速度/クリティカル率/クリティカル威力上昇',
        adscrup: '攻撃力/防御力/移動速度/クリティカル率/クリティカル威力上昇',
        guardup: '遠距離ダメージカット上昇',
        delayoff: '攻撃速度上昇',
        maxhpup: '最大HP増加',
        hp_excess: 'HP超過状態になる',
        guard_fire: '火属性を軽減',
        guard_ice: '氷属性を軽減',
        guard_fireice: '炎/氷属性を軽減',
        areaup: '回復範囲増加',
        healup: '回復効果上昇',
        healareaup: '回復範囲/効果上昇',
        areashift: '回復範囲移動',
        healdelayoff: '回復後の硬直時間減少',
        healspeedup: '回復速度上昇',
        poison_atkup: '毒ダメージ上昇',
        blind_boost: '暗闇の効果延長',
        down_boost: 'ダウンの効果延長',
        slow_boost: 'スロウの効果延長',
        registup: '魔法ダメージ軽減',
        invisible: '姿を消す（遠距離無効）',
        single_shoot: '単発射撃',
        twin_shoot: '二連射撃',
        bullet_speedup: '弾速上昇',
        rapid_shoot: '弾数増加',
        barrier: 'バリアを張る',
        skill_once: '一度だけ必殺技が使える',
        mana_cost_down: '必殺技の消費マナ低下',
        super_skill: '超必殺技使用可能',
        heal_action: '回復行動を取る',
        super_gauge_gain: '超必殺技ゲージ上昇',
        extra_attack: '追撃発生',
        blast_attack: '範囲攻撃化',
        combo_blast_attack: '連続範囲攻撃化',
        double_critical: 'クリティカル時二連撃',
        shoot_available: '遠距離攻撃可能',
        multi_gauge: '複数ゲージ所持',
        aup_m: '攻撃力上昇 / 一定時間',
        dup_m: '防御力上昇 / 一定時間',
        sup_m: '移動速度上昇 / 一定時間',
        cup_m: 'クリティカル率上昇 / 一定時間',
        adup_m: '攻撃力/防御力上昇 / 一定時間',
        asup_m: '攻撃力/移動速度上昇 / 一定時間',
        acup_m: '攻撃力/クリティカル率上昇 / 一定時間',
        arup_m: '攻撃力/クリティカル威力上昇 / 一定時間',
        dsup_m: '防御力/移動速度上昇 / 一定時間',
        dcup_m: '防御力/クリティカル率上昇 / 一定時間',
        drup_m: '防御力/クリティカル威力上昇 / 一定時間',
        scup_m: '移動速度/クリティカル率上昇 / 一定時間',
        crup_m: 'クリティカル率/クリティカル威力上昇 / 一定時間',
        adsup_m: '攻撃力/防御力/移動速度上昇 / 一定時間',
        adcup_m: '攻撃力/防御力/クリティカル率上昇 / 一定時間',
        adrup_m: '攻撃力/防御力/クリティカル威力上昇 / 一定時間',
        ascup_m: '攻撃力/移動速度/クリティカル率上昇 / 一定時間',
        asrup_m: '攻撃力/移動速度/クリティカル威力上昇 / 一定時間',
        acrup_m: '攻撃力/クリティカル率/クリティカル威力上昇 / 一定時間',
        dscup_m: '防御力/移動速度/クリティカル率上昇 / 一定時間',
        dcrup_m: '防御力/クリティカル率/クリティカル威力上昇 / 一定時間',
        scrup_m: '移動速度/クリティカル率/クリティカル威力上昇 / 一定時間',
        adscup_m: '攻撃力/防御力/移動速度/クリティカル率上昇 / 一定時間',
        adsrup_m: '攻撃力/防御力/移動速度/クリティカル威力上昇 / 一定時間',
        adcrup_m: '攻撃力/防御力/クリティカル率/クリティカル威力上昇 / 一定時間',
        ascrup_m: '攻撃力/移動速度/クリティカル率/クリティカル威力上昇 / 一定時間',
        adscrup_m: '攻撃力/防御力/移動速度/クリティカル率/クリティカル威力上昇 / 一定時間'
      },
      sub_effect: {
        aup: {
          defdown_self: '自身の防御力低下'
        },
        dup: {
          atkdown_self: '自身の攻撃力低下'
        },
        sup: {
          defdown_self: '自身の防御力低下'
        },
        asup: {
          defdown_self: '自身の防御力低下'
        },
        delayoff: {
          momentary: '一定時間'
        },
        healup: {
          areadown_self: '自身の回復範囲減少',
          defdown_self: '自身の防御力低下'
        },
        healareaup: {
          defdown_self: '自身の防御力低下'
        },
        extra_attack: {
          ice: '氷属性'
        },
        aup_m: {
          defdown_self: '自身の防御力低下'
        },
        adup_m: {
          speeddown_self: '自身の移動速度低下'
        },
        asup_m: {
          defdown_self: '自身の防御力低下'
        },
        ascup_m: {
          defdown_self: '自身の防御力低下'
        }
      },
      condition: {
        any: 'いつでも',
        hp_upto: 'HPが一定以上の時',
        hp_downto: 'HPが一定以下の時',
        hp_full: 'HPが満タンの時',
        hp_excess: 'HP超過状態の時',
        attack: '通常攻撃時',
        critical: 'クリティカル時',
        shoot: '遠距離攻撃時',
        in_move: '移動中',
        in_pierce: '貫通した時',
        link: '複数で一緒に攻撃した時',
        guard: 'ガードした時',
        damaged: 'ダメージを受けた時',
        heavily_damaged: '一定以上のダメージを受けた時',
        waiting: '何もしていない間',
        staying: '移動していない間',
        counter: 'カウンター発生時',
        wave_start: '各WAVE開始時',
        boss_wave: 'BOSS WAVE時',
        wave_span: '一定WAVE進むごとに',
        with_f: '戦士がいる時',
        with_k: '騎士がいる時',
        with_a: '弓使いがいる時',
        with_p: '僧侶がいる時',
        with_m: '魔法使いがいる時',
        with_fk: '戦/騎がいる時',
        with_fa: '戦/弓がいる時',
        with_fkpm: '戦/騎/僧/魔がいる時',
        with_exclude_f: '戦士以外がいる時',
        with_various_jobs: '職の種類が多いほど',
        with_many_f: '戦士が多いほど',
        with_many_k: '騎士が多いほど',
        with_sl: '<<斬>>がいる時',
        with_bl: '<<打>>がいる時',
        with_pi: '<<突>>がいる時',
        with_ar: '<<弓>>がいる時',
        with_ma: '<<魔>>がいる時',
        with_he: '<<聖>>がいる時',
        with_pu: '<<拳>>がいる時',
        with_gu: '<<銃>>がいる時',
        with_sh: '<<狙>>がいる時',
        with_slpu: '<<斬/拳>>がいる時',
        with_blpi: '<<打/突>>がいる時',
        with_armahe: '<<弓/魔/聖>>がいる時',
        with_gush: '<<銃/狙>>がいる時',
        with_many_slbl: '<<斬/打>>が多いほど',
        with_guildtown: '所属：副都がいる時',
        with_holytown: '所属：聖都がいる時',
        with_academy: '所属：賢者の塔がいる時',
        with_mountain: '所属：迷宮山脈がいる時',
        with_oasis: '所属：湖都がいる時',
        with_forest: '所属：精霊島がいる時',
        with_volcano: '所属：九領がいる時',
        with_beasts: '所属：ケ者がいる時',
        with_criminal: '所属：罪の大陸がいる時',
        with_machine: '所属：鉄煙がいる時',
        with_demon: '所属：魔神がいる時',
        with_others: '所属：旅人がいる時',
        with_volunteers: '所属：義勇軍がいる時',
        with_many_guildtown: '所属：副都が多いほど',
        with_many_holytown: '所属：聖都が多いほど',
        with_many_academy: '所属：賢者の塔が多いほど',
        with_many_oasis: '所属：湖都が多いほど',
        with_many_forest: '所属：精霊島が多いほど',
        with_many_volcano: '所属：九領が多いほど',
        with_many_others: '所属：旅人が多いほど',
        with_many_demons: '所属：魔神が多いほど',
        same_abilities: '同じアビリティを持った味方がいる時',
        kill: '敵を倒した時',
        kill_debuff: '状態異常の敵を倒した時',
        kill_count: '一定数の敵を倒した時',
        combat: '近接戦闘時',
        in_head: '先頭にいる時',
        in_front: '仲間より前にいる時',
        in_enemy_area: '敵陣にいる時',
        in_enemy_back: '敵陣の奥にいる時',
        in_base_area: '自陣にいる時',
        after_enemy_area: '敵陣に一定時間いた時',
        after_base_area: '自陣に一定時間いた時',
        in_rear: '仲間より後ろにいる時',
        in_tail: '最も後ろにいる時',
        in_back: '最も後列にいる時',
        in_combo: '攻撃を一定回数当てた時',
        in_attacking: '攻撃を当てた時',
        in_invisible: '姿を消している時',
        own_skill: '自分が必殺技を使った時',
        others_skill: '味方が必殺技を使った時',
        any_skill: '誰かが必殺技を使った時',
        job_skill: '特定の職が必殺技を使った時',
        skill_hit: '必殺技が当たる毎に',
        in_chain: 'チェイン発動中',
        mana_charged: 'マナが多いほど',
        mana_lost: 'マナが少ないほど',
        mana_droped: 'マナを獲得した時',
        mana_empty: 'マナがない時',
        mana_mixed: 'マナの種類が多いほど',
        mana_slot_many: 'マナスロットで多く獲得するほど',
        use_mana: 'マナが使用された時',
        scrap_charged: 'スクラップが多いほど',
        scrap_lost: 'スクラップが少ないほど',
        has_mana: 'マナを保持している時',
        dropout_member: '味方が脱落した時',
        dropout_self: '自身が脱落した時',
        members_debuff: '味方に状態異常が多いほど',
        enemys_debuff: '敵に状態異常が多いほど',
        with_enemy_debuff: '状態異常の敵がいる時',
        any_debuff: 'フィールドに状態異常が多いほど',
        super_gauge_max: '超必殺技ゲージがMAXの時',
        in_awakening: '覚醒している時',
        add_debuff: '状態異常を付与した時',
        add_atkdown: '攻撃力低下を付与した時',
        add_defdown: '防御力低下を付与した時',
        add_atkdefdown: '攻撃力/防御力低下を付与した時',
        add_atkspeeddown: '攻撃力/移動速度低下を付与した時',
        add_defspeeddown: '防御力/移動速度低下を付与した時',
        after_move: '一定距離を移動した時',
        from_sub: 'サブから戦場に移動したとき',
        waiting_charge: '何もせずに一定時間経過した時',
        targeted_self: '自身を選択中',
        battle_start: '戦闘開始時',
        in_heroic: '援軍として参戦した時'
      },
      sub_condition: {
        any: {
          boost_on_hp_upto: 'HPが一定以上で効果上昇',
          boost_on_hp_downto: 'HPが一定以下で効果上昇',
          boost_on_hp_excess: 'HP超過状態だと効果上昇',
          boost_on_boss_wave: 'BOSS WAVEで効果上昇',
          boost_on_front: '仲間より前にいると効果上昇',
          boost_on_rear: '仲間より後ろにいると効果上昇',
          boost_on_field: '特定のフィールドだと効果上昇',
          boost_on_enemy_area: '敵陣にいると効果上昇',
          boost_on_base_area: '自陣にいると効果上昇',
          boost_on_debuff_enemy: '状態異常の敵がいると効果上昇',
          boost_on_mana: 'マナを持っていると効果上昇',
          boost_on_combo: '攻撃を一定回数当てると効果上昇',
          boost_on_with_jobs: '特定の職がいると効果上昇'
        },
        critical: {
          with_span: '連続では発動しない'
        },
        hp_upto: {
          boost_on_hp_excess: 'HP超過状態だと効果上昇'
        },
        wave_start: {
          hp_upto: 'HPが一定以上',
          hp_downto: 'HPが一定以下',
          hp_full: 'HPが満タンの時'
        },
        with_f: {
          include_self: '自身を含む',
          group_oasis: '湖都所属',
          group_beasts: 'ケ者所属',
          group_others: '旅人所属',
          boost_on_union: '対象が特定の所属だと効果上昇'
        },
        with_k: {
          include_self: '自身を含む'
        },
        with_a: {
          group_oasis: '湖都所属',
          boost_on_union: '対象が特定の所属だと効果上昇'
        },
        with_m: {
          include_self: '自身を含む'
        },
        with_fk: {
          include_self: '自身を含む'
        },
        with_fa: {
          include_self: '自身を含む',
          group_oasis: '湖都所属'
        },
        with_pu: {
          group_beasts: 'ケ者所属',
          group_others: '旅人所属'
        },
        with_fkpm: {
          group_demon: '魔神所属'
        },
        with_various_jobs: {
          boost_on_job_target: '対象が特定の職だと効果上昇'
        },
        with_volcano: {
          job_f: '戦士'
        },
        with_demon: {
          include_self: '自身を含む'
        },
        with_volunteers: {
          job_m: '魔法使い'
        },
        with_many_guildtown: {
          include_self: '自身を含む'
        },
        with_many_holytown: {
          include_self: '自身を含む'
        },
        with_many_academy: {
          include_self: '自身を含む'
        },
        with_many_oasis: {
          include_self: '自身を含む'
        },
        with_many_forest: {
          include_self: '自身を含む'
        },
        with_many_others: {
          include_self: '自身を含む'
        },
        kill: {
          skill: '必殺技使用時',
          boost_on_debuff_enemy: '状態異常の敵がいると効果上昇'
        },
        link: {
          with_f: '戦士',
          with_fp: '戦/僧'
        },
        in_front: {
          with_k: '騎士',
          with_a: '弓使い',
          with_p: '僧侶',
          with_m: '魔法使い',
          with_fm: '戦/魔',
          boost_on_many_target: '対象の人数が多いほど効果上昇',
          boost_on_job_target: '対象が特定の職だと効果上昇'
        },
        in_rear: {
          with_f: '戦士',
          with_fa: '戦/弓',
          with_fk: '戦/騎',
          boost_on_job_target: '対象が特定の職だと効果上昇'
        },
        in_combo: {
          combat: '近接戦闘時'
        },
        has_mana: {
          mana_f: '戦マナ',
          mana_k: '騎マナ',
          mana_p: '僧マナ',
          mana_m: '魔マナ',
          mana_fk: '戦/騎マナ',
          mana_fa: '戦/弓マナ',
          mana_fp: '戦/僧マナ',
          mana_fm: '戦/魔マナ',
          mana_ka: '騎/弓マナ',
          mana_pm: '僧/魔マナ',
          mana_all: '虹色マナ',
          mana_exclude_f: '戦マナ以外',
          mana_fk_all: '戦＋騎マナ',
          mana_fm_all: '戦＋魔マナ',
          boost_on_mana: '特定のマナだと効果上昇'
        },
        mana_droped: {
          mana_f: '戦マナ',
          mana_k: '騎マナ',
          mana_a: '弓マナ',
          mana_p: '僧マナ',
          mana_m: '魔マナ',
          mana_fa: '戦/弓マナ',
          mana_fm: '戦/魔マナ',
          mana_ka: '騎/弓マナ',
          mana_fkap: '魔マナ以外',
          boost_on_mana: 'boost_on_mana'
        },
        mana_charged: {
          mana_k: '騎マナ',
          mana_m: '魔マナ',
          mana_fm: '戦/魔マナ',
          mana_ka: '騎/弓マナ',
          boost_on_mana: '特定のマナだと効果上昇'
        },
        use_mana: {
          self: '自分'
        },
        own_skill: {
          with_mana_empty: 'マナが空で発動したとき',
          boost_with_enemys: '敵が多いほど効果上昇'
        },
        others_skill: {
          job_a: '弓使い',
          job_p: '僧侶',
          job_kam: '騎/弓/魔',
          with_f: '戦士がいる時',
          boost_with_enemys: '敵が多いほど効果上昇'
        },
        any_skill: {
          boost_on_self: '自身が使用すると効果上昇',
          boost_on_user: '特定の使用者だと効果上昇'
        },
        job_skill: {
          job_f: '戦士'
        },
        battle_start: {
          in_main: 'メインパーティーにいる時'
        },
        with_enemy_debuff: {
          boost_on_debuff_enemy: '特定の状態異常の敵がいると効果上昇'
        },
        add_atkspeeddown: {
          boost_on_skill: '必殺技だと効果上昇'
        }
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
        arup: '攻撃力/クリティカル威力上昇',
        dcup: '防御力/クリティカル率上昇',
        scup: '移動速度/クリティカル率上昇',
        crup: 'クリティカル率/クリティカル威力上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        adrup: '攻撃力/防御力/クリティカル威力上昇',
        ascup: '攻撃力/移動速度/クリティカル率上昇',
        acrup: '攻撃力/クリティカル率/クリティカル威力上昇',
        adscup: '攻撃力/防御力/移動速度/クリティカル率上昇',
        adsrup: '攻撃力/防御力/移動速度/クリティカル威力上昇',
        barrier: 'バリアを張る',
        super_gauge_gain: '超必殺技ゲージ上昇',
        extend_chain: 'チェイン受け付け時間延長',
        enhance_chain: 'チェイン倍率上昇',
        hp_excess: 'HP超過状態になる',
        aup_m: '攻撃力上昇 / 一定時間',
        dup_m: '防御力上昇 / 一定時間',
        sup_m: '移動速度上昇 / 一定時間',
        cup_m: 'クリティカル率上昇 / 一定時間',
        adup_m: '攻撃力/防御力上昇 / 一定時間',
        asup_m: '攻撃力/移動速度上昇 / 一定時間',
        acup_m: '攻撃力/クリティカル率上昇 / 一定時間',
        arup_m: '攻撃力/クリティカル威力上昇 / 一定時間',
        dsup_m: '防御力/移動速度上昇 / 一定時間',
        dcup_m: '防御力/クリティカル率上昇 / 一定時間',
        scup_m: '移動速度/クリティカル率上昇 / 一定時間',
        crup_m: 'クリティカル率/クリティカル威力上昇 / 一定時間',
        adsup_m: '攻撃力/防御力/移動速度上昇 / 一定時間',
        adcup_m: '攻撃力/防御力/クリティカル率上昇 / 一定時間',
        ascup_m: '攻撃力/移動速度/クリティカル率上昇 / 一定時間',
        acrup_m: '攻撃力/クリティカル率/クリティカル威力上昇 / 一定時間',
        adscup_m: '攻撃力/防御力/移動速度/クリティカル率上昇 / 一定時間',
        adsrup_m: '攻撃力/防御力/移動速度/クリティカル威力上昇 / 一定時間'
      },
      sub_effect: {
        aup: {
          defdown_all: '全体の防御力低下',
          gradually: '徐々に上昇'
        },
        asup: {
          defdown_all: '全体の防御力低下'
        },
        barrier: {
          guard_fireice: '炎/氷属性を軽減'
        }
      },
      condition: {
        any: 'いつでも',
        in_sub: 'サブパーティーにいる時',
        wave_start: '各WAVE開始時',
        boss_wave: 'BOSS WAVE時',
        own_skill: '自分が必殺技を使った時',
        others_skill: '味方が必殺技を使った時',
        any_skill: '誰かが必殺技を使った時',
        job_skill: '特定の職が必殺技を使った時',
        dropout_self: '自身が脱落した時',
        dropout_member: '味方が脱落した時',
        hp_excess: 'HP超過状態の時',
        mana_charged: 'マナが多いほど',
        mana_slot_many: 'マナスロットで多く獲得するほど',
        mana_droped: 'マナを獲得した時',
        use_mana: 'マナが使用された時',
        has_mana: 'マナを保持している時',
        kill: '敵を倒した時',
        kill_debuff: '状態異常の敵を倒した時',
        super_gauge_max: '超必殺技ゲージがMAXの時',
        from_sub: 'サブから戦場に移動したとき',
        with_k: '騎士がいる時',
        with_fk: '戦/騎がいる時',
        battle_start: '戦闘開始時',
        in_heroic: '援軍として参戦した時',
        targeted_self: '自身を選択中'
      },
      sub_condition: {
        any: {
          boost_on_job_target: '対象が特定の職だと効果上昇'
        },
        in_sub: {
          field: '特定のフィールド',
          boost_on_union: '対象が特定の所属だと効果上昇',
          boost_on_job_target: '対象が特定の職だと効果上昇'
        },
        any_skill: {
          job_f: '戦士',
          job_k: '騎士',
          job_p: '僧侶',
          job_m: '魔法使い',
          boost_on_self: '自身が使用すると効果上昇',
          boost_on_user: '特定の使用者だと効果上昇'
        },
        others_skill: {
          job_k: '騎士',
          job_m: '魔法使い',
          job_fm: '戦/魔',
          boost_on_user: '特定の使用者だと効果上昇'
        },
        job_skill: {
          job_p: '僧侶',
          job_fa: '戦/弓'
        },
        mana_droped: {
          mana_f: '戦マナ',
          mana_k: '騎マナ',
          mana_p: '僧マナ',
          mana_m: '魔マナ',
          mana_fa: '戦/弓マナ',
          mana_pm: '僧/魔マナ',
          mana_exclude_f: '戦マナ以外'
        },
        use_mana: {
          self: '自身',
          other: '味方',
          mana_m: '魔マナ',
          mana_fm: '戦/魔マナ',
          mana_fpm: '戦/僧/魔マナ',
          job_f: '戦士',
          job_fa: '戦/弓',
          job_fm: '戦/魔',
          boost_on_user: '特定の使用者だと効果上昇',
          boost_on_mana: '特定のマナだと効果上昇'
        },
        has_mana: {
          mana_f: '戦マナ',
          mana_a: '弓マナ',
          mana_m: '魔マナ',
          mana_fm: '戦/魔マナ',
          mana_fka: '戦/騎/弓マナ',
          mana_all: '虹色マナ',
          mana_exclude_a: '弓マナ以外'
        },
        with_fk: {
          include_self: '自身を含む'
        },
        battle_start: {
          in_main: 'メインパーティーにいる時',
          in_sub: 'サブパーティーにいる時'
        },
        in_heroic: {
          mana_charged: 'マナが多いほど'
        }
      },
      target: {
        all: '全員'
      },
      sub_target: {
        all: {
          boost_for_self: '自身は効果上昇',
          boost_for_union: '特定の所属だと効果上昇',
          boost_for_jobs: '特定の職業だと効果上昇'
        }
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
        adsup: '攻撃力/防御力/移動速度上昇',
        aup_m: '攻撃力上昇 / 一定時間',
        adup_m: '攻撃力/防御力上昇 / 一定時間',
        acup_m: '攻撃力/クリティカル率上昇 / 一定時間'
      },
      condition: {
        any: 'いつでも',
        wave_start: '各WAVE開始時',
        own_skill: '自分が必殺技を使った時',
        others_skill: '味方が必殺技を使った時'
      },
      sub_condition: {
        others_skill: {
          job_k: '騎士'
        }
      },
      target: {
        others: '自分以外全員',
        job_f: '戦士',
        job_k: '騎士',
        job_a: '弓使い',
        job_m: '魔法使い',
        job_fk: '戦/騎',
        job_fa: '戦/弓',
        job_fm: '戦/魔',
        job_kapm: '騎/弓/僧/魔'
      }
    },
    buff_jobs: {
      name: '特定の職を強化',
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        sup: '移動速度上昇',
        cup: 'クリティカル率上昇',
        rup: 'クリティカル威力上昇',
        adup: '攻撃力/防御力上昇',
        asup: '攻撃力/移動速度上昇',
        acup: '攻撃力/クリティカル率上昇',
        dsup: '防御力/移動速度上昇',
        dcup: '防御力/クリティカル率上昇',
        scup: '移動速度/クリティカル率上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        adrup: '攻撃力/防御力/クリティカル威力上昇',
        ascup: '攻撃力/移動速度/クリティカル率上昇',
        acrup: '攻撃力/クリティカル率/クリティカル威力上昇',
        adscup: '攻撃力/防御力/移動速度/クリティカル率上昇',
        ascrup: '攻撃力/移動速度/クリティカル率/クリティカル威力上昇',
        adscrup: '攻撃力/防御力/移動速度/クリティカル率/クリティカル威力上昇',
        add_slow: '対象の攻撃にスロウを付与',
        barrier: 'バリアを張る',
        aup_m: '攻撃力上昇 / 一定時間',
        dup_m: '防御力上昇 / 一定時間',
        sup_m: '移動速度上昇 / 一定時間',
        cup_m: 'クリティカル率上昇 / 一定時間',
        adup_m: '攻撃力/防御力上昇 / 一定時間',
        asup_m: '攻撃力/移動速度上昇 / 一定時間',
        acup_m: '攻撃力/クリティカル率上昇 / 一定時間',
        dsup_m: '防御力/移動速度上昇 / 一定時間',
        scup_m: '移動速度/クリティカル率上昇 / 一定時間',
        adsup_m: '攻撃力/防御力/移動速度上昇 / 一定時間',
        adrup_m: '攻撃力/防御力/クリティカル威力上昇 / 一定時間',
        adcup_m: '攻撃力/防御力/クリティカル率上昇 / 一定時間',
        ascup_m: '攻撃力/移動速度/クリティカル率上昇 / 一定時間',
        acrup_m: '攻撃力/クリティカル率/クリティカル威力上昇 / 一定時間',
        adscup_m: '攻撃力/防御力/移動速度/クリティカル率上昇 / 一定時間',
        ascrup_m: '攻撃力/移動速度/クリティカル率/クリティカル威力上昇 / 一定時間',
        adscrup_m: '攻撃力/防御力/移動速度/クリティカル率/クリティカル威力上昇 / 一定時間'
      },
      sub_effect: {
        aup: {
          defdown_targets: '対象の防御力低下'
        },
        aup_m: {
          defdown_targets: '対象の防御力低下'
        }
      },
      condition: {
        any: 'いつでも',
        with_f: '戦士がいる時',
        with_k: '騎士がいる時',
        with_a: '弓使いがいる時',
        with_m: '魔法使いがいる時',
        with_fk: '戦/騎がいる時',
        with_fa: '戦/弓がいる時',
        with_fp: '戦/僧がいる時',
        with_fm: '戦/魔がいる時',
        with_ka: '騎/弓がいる時',
        with_kp: '騎/僧がいる時',
        with_ap: '弓/僧がいる時',
        with_fka: '戦/騎/弓がいる時',
        with_fkm: '戦/騎/魔がいる時',
        with_fam: '戦/弓/魔がいる時',
        with_fpm: '戦/僧/魔がいる時',
        with_kam: '騎/弓/魔がいる時',
        with_fkap: '戦/騎/弓/僧がいる時',
        wave_start: '各WAVE開始時',
        in_sub: 'サブパーティーにいる時',
        own_skill: '自分が必殺技を使った時',
        job_skill: '特定の職が必殺技を使った時'
      },
      sub_condition: {
        with_f: {
          include_self: '自身を含む'
        },
        with_k: {
          include_self: '自身を含む'
        },
        with_m: {
          include_self: '自身を含む'
        },
        with_fa: {
          include_self: '自身を含む'
        },
        with_fk: {
          include_self: '自身を含む'
        },
        with_fp: {
          include_self: '自身を含む'
        },
        with_fm: {
          include_self: '自身を含む'
        },
        with_ka: {
          include_self: '自身を含む'
        },
        with_kp: {
          include_self: '自身を含む'
        },
        with_ap: {
          include_self: '自身を含む'
        },
        with_fka: {
          include_self: '自身を含む'
        },
        with_fam: {
          include_self: '自身を含む'
        },
        with_fpm: {
          include_self: '自身を含む'
        },
        with_fkap: {
          include_self: '自身を含む'
        },
        in_sub: {
          wave_start: '各WAVE開始時'
        },
        job_skill: {
          job_fk: '戦/騎',
          job_fm: '戦/魔'
        }
      },
      target: {
        job_f: '戦士',
        job_k: '騎士',
        job_a: '弓使い',
        job_p: '僧侶',
        job_m: '魔法使い',
        job_fk: '戦/騎',
        job_fa: '戦/弓',
        job_fp: '戦/僧',
        job_fm: '戦/魔',
        job_ka: '騎/弓',
        job_kp: '騎/僧',
        job_km: '騎/魔',
        job_ap: '弓/僧',
        job_am: '弓/魔',
        job_fka: '戦/騎/弓',
        job_fkp: '戦/騎/僧',
        job_fkm: '戦/騎/魔',
        job_fap: '戦/弓/僧',
        job_fam: '戦/弓/魔',
        job_fpm: '戦/僧/魔',
        job_kam: '騎/弓/魔',
        job_apm: '弓/僧/魔',
        job_fkap: '戦/騎/弓/僧'
      },
      sub_target: {
        job_f: {
          nearest: '最も近い対象',
          hp_best: '最もHPが大きい対象',
          atk_best: '最も攻撃力が大きい対象'
        },
        job_k: {
          nearest: '最も近い対象',
          hp_worst: '最もHPの低い対象'
        },
        job_a: {
          nearest: '最も近い対象',
          farthest: '最も遠い対象',
          hp_worst: '最もHPの低い対象'
        },
        job_m: {
          nearest: '最も近い対象',
          farthest: '最も遠い対象',
          atk_best: '最も攻撃力が大きい対象'
        },
        job_fk: {
          nearest: '最も近い対象',
          hp_best: '最もHPが大きい対象',
          hp_worst: '最もHPの低い対象',
          atk_best: '最も攻撃力が大きい対象'
        },
        job_fa: {
          random: 'ランダム'
        }
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
        arup: '攻撃力/クリティカル威力上昇',
        dcup: '防御力/クリティカル率上昇',
        scup: '移動速度/クリティカル率上昇',
        crup: 'クリティカル率/クリティカル威力上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        adrup: '攻撃力/防御力/クリティカル威力上昇',
        ascup: '攻撃力/移動速度/クリティカル率上昇',
        barrier: 'バリアを張る'
      },
      condition: {
        any: 'いつでも',
        with_f: '戦士がいる時',
        with_a: '弓使いがいる時',
        with_slpi: '<<斬/突>>がいる時',
        with_slma: '<<斬/魔>>がいる時',
        with_slpu: '<<斬/拳>>がいる時',
        with_slblpu: '<<斬/打/拳>>がいる時',
        with_blpipu: '<<打/突/拳>>がいる時',
        with_blpush: '<<打/銃/狙>>がいる時',
        with_slpimapu: '<<斬/突/魔/拳>>がいる時',
        with_dawnsea: '所属：大海がいる時',
        wave_start: '各WAVE開始時',
        in_heroic: '援軍として参戦した時'
      },
      sub_condition: {
        with_slma: {
          include_self: '自身を含む'
        },
        with_slpu: {
          include_self: '自身を含む'
        },
        with_slblpu: {
          include_self: '自身を含む'
        },
        with_blpipu: {
          include_self: '自身を含む'
        },
        with_blpush: {
          include_self: '自身を含む'
        }
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
        weapon_slpi: '<<斬/突>>',
        weapon_slma: '<<斬/魔>>',
        weapon_slpu: '<<斬/拳>>',
        weapon_blpi: '<<打/突>>',
        weapon_pish: '<<突/狙>>',
        weapon_arpu: '<<弓/拳>>',
        weapon_argu: '<<弓/銃>>',
        weapon_mapu: '<<魔/拳>>',
        weapon_gush: '<<銃/狙>>',
        weapon_slpibl: '<<斬/突/打>>',
        weapon_slblpu: '<<斬/打/拳>>',
        weapon_slmapu: '<<斬/魔/拳>>',
        weapon_blpush: '<<打/銃/狙>>',
        weapon_blpipu: '<<打/突/拳>>',
        weapon_pugush: '<<拳/銃/狙>>',
        weapon_slblpipu: '<<斬/打/突/拳>>',
        weapon_slpimapu: '<<斬/突/魔/拳>>',
        weapon_slpiarmapu: '<<斬/突/弓/魔/拳>>',
        weapon_exclude_sl: '<<斬>>以外',
        weapon_exclude_ma: '<<魔>>以外',
        weapon_exclude_gu: '<<銃>>以外',
        shoot: '遠距離攻撃'
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
        arup: '攻撃力/クリティカル威力上昇',
        dsup: '防御力/移動速度上昇',
        dcup: '防御力/クリティカル率上昇',
        scup: '移動速度/クリティカル率上昇',
        crup: 'クリティカル率/クリティカル威力上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        adrup: '攻撃力/防御力/クリティカル威力上昇',
        ascup: '攻撃力/移動速度/クリティカル率上昇',
        acrup: '攻撃力/クリティカル率/クリティカル威力上昇',
        adscup: '攻撃力/防御力/移動速度/クリティカル率上昇',
        maxhpup: '最大HP増加',
        hp_excess: 'HP超過状態になる',
        add_down: '対象の攻撃にダウンを付与',
        add_slow: '対象の攻撃にスロウを付与',
        add_poison: '対象の攻撃に毒を付与',
        add_shield_break: '対象の攻撃に盾破壊付与',
        adup_m: '攻撃力/防御力上昇 / 一定時間',
        asup_m: '攻撃力/移動速度上昇 / 一定時間',
        scup_m: '移動速度/クリティカル率上昇 / 一定時間',
        adsup_m: '攻撃力/防御力/移動速度上昇 / 一定時間',
        adcup_m: '攻撃力/防御力/クリティカル率上昇 / 一定時間',
        adrup_m: '攻撃力/防御力/クリティカル威力上昇 / 一定時間',
        acrup_m: '攻撃力/クリティカル率/クリティカル威力上昇 / 一定時間',
        adscup_m: '攻撃力/防御力/移動速度/クリティカル率上昇 / 一定時間'
      },
      condition: {
        any: 'いつでも',
        wave_start: '各WAVE開始時',
        battle_start: '戦闘開始時',
        in_enemy_area: '敵陣にいる時',
        in_base_area: '自陣にいる時',
        in_sub: 'サブパーティーにいる時',
        with_f: '戦士がいる時',
        with_k: '騎士がいる時',
        with_a: '弓使いがいる時',
        with_m: '魔法使いがいる時',
        with_sl: '<<斬>>がいる時',
        with_ar: '<<弓>>がいる時',
        with_ma: '<<魔>>がいる時',
        with_machine: '所属：鉄煙がいる時',
        hp_excess: 'HP超過状態の時'
      },
      sub_condition: {
        battle_start: {
          in_main: 'メインパーティーにいる時',
          in_sub: 'サブパーティーにいる時'
        },
        with_machine: {
          include_self: '自身を含む'
        }
      },
      target: {
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
        group_life: '薄命所属',
        group_machine: '鉄煙所属',
        group_chronicle: '年代記所属',
        group_remless: 'レムレス島所属',
        group_volunteers: '義勇軍所属',
        group_demon: '魔神所属',
        group_others: '旅人所属'
      },
      sub_target: {
        group_guildtown: {
          job_fm: '戦/魔',
          random: 'ランダム'
        },
        group_holytown: {
          job_k: '騎士'
        },
        group_academy: {
          random: 'ランダム'
        },
        group_mountain: {
          job_f: '戦士'
        },
        group_oasis: {
          job_f: '戦士',
          job_a: '弓使い',
          random: 'ランダム',
          in_enemy_area: '敵陣にいる対象',
          in_base_area: '自陣にいる対象'
        },
        group_forest: {
          job_f: '戦士',
          job_m: '魔法使い',
          job_fk: '戦/騎',
          job_am: '弓/魔',
          random: 'ランダム'
        },
        group_volcano: {
          random: 'ランダム'
        },
        group_criminal: {
          job_fa: '戦/弓'
        },
        group_machine: {
          nearest: '最も近い対象',
          weapon_argush: '<<弓/銃/狙>>'
        },
        group_demon: {
          nearest: '最も近い対象',
          job_fk: '戦/騎',
          job_apm: '弓/僧/魔'
        }
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
        arup: '攻撃力/クリティカル威力上昇',
        dsup: '防御力/移動速度上昇',
        scup: '移動速度/クリティカル率上昇',
        crup: 'クリティカル率/クリティカル威力上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        acrup: '攻撃力/クリティカル率/クリティカル威力上昇',
        scrup: '移動速度/クリティカル率/クリティカル威力上昇',
        adscup: '攻撃力/防御力/移動速度/クリティカル率上昇',
        dscrup: '防御力/移動速度/クリティカル率/クリティカル威力上昇',
        barrier: 'バリアを張る',
        aup_m: '攻撃力上昇 / 一定時間',
        dup_m: '防御力上昇 / 一定時間',
        adup_m: '攻撃力/防御力上昇 / 一定時間',
        acup_m: '攻撃力/クリティカル率上昇 / 一定時間',
        asup_m: '攻撃力/移動速度上昇 / 一定時間',
        scup_m: '移動速度/クリティカル率上昇 / 一定時間',
        crup_m: 'クリティカル率/クリティカル威力上昇 / 一定時間',
        adsup_m: '攻撃力/防御力/移動速度上昇 / 一定時間',
        adcup_m: '攻撃力/防御力/クリティカル率上昇 / 一定時間',
        acrup_m: '攻撃力/クリティカル率/クリティカル威力上昇 / 一定時間',
        scrup_m: '移動速度/クリティカル率/クリティカル威力上昇 / 一定時間',
        adscup_m: '攻撃力/防御力/移動速度/クリティカル率上昇 / 一定時間'
      },
      condition: {
        wave_start: '各WAVE開始時',
        in_sub: 'サブパーティーにいる時',
        in_combo: '攻撃を一定回数当てた時',
        with_volcano: '所属：九領がいる時'
      },
      target: {
        nearest: '最も近い対象',
        hp_worst: '最もHPの低い対象',
        owner: '主人',
        buddy: 'バディ',
        random: 'ランダム'
      }
    },
    buff_area: {
      name: '範囲内を強化',
      effect: {
        aup: '攻撃力上昇',
        dup: '防御力上昇',
        adup: '攻撃力/防御力上昇',
        acup: '攻撃力/クリティカル率上昇',
        arup: '攻撃力/クリティカル威力上昇',
        dsup: '防御力/移動速度上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        acrup: '攻撃力/クリティカル率/クリティカル威力上昇',
        super_gauge_gain: '超必殺技ゲージ上昇',
        aup_m: '攻撃力上昇 / 一定時間',
        dup_m: '防御力上昇 / 一定時間',
        adup_m: '攻撃力/防御力上昇 / 一定時間',
        dsup_m: '防御力/移動速度上昇 / 一定時間',
        adsup_m: '攻撃力/防御力/移動速度上昇 / 一定時間',
        acrup_m: '攻撃力/クリティカル率/クリティカル威力上昇 / 一定時間'
      },
      condition: {
        any: 'いつでも',
        heal_action: '回復行動時'
      },
      target: {
        base_area_member: '自陣にいる味方',
        enemy_area_member: '敵陣にいる味方',
        heal_area_member: '回復範囲内の味方'
      },
      sub_target: {
        base_area_member: {
          job_f: '戦士',
          group_others: '旅人所属',
          boost_for_self: '自身は効果上昇'
        },
        enemy_area_member: {
          job_f: '戦士',
          group_others: '旅人所属',
          boost_for_self: '自身は効果上昇'
        }
      }
    },
    skillup: {
      name: '自分の必殺技を強化',
      effect: {
        skill_atkup: '必殺技威力上昇',
        skill_boost: '必殺技強化',
        charge_reduce: '溜め時間減少',
        skill_spread: '必殺技範囲拡大',
        add_slow: '必殺技にスロウ付与を追加',
        add_down: '必殺技にダウン付与を追加',
        add_shield_break: '必殺技に盾破壊を追加'
      },
      sub_effect: {
        skill_atkup: {
          momentary: '一定時間'
        },
        skill_spread: {
          momentary: '一定時間'
        }
      },
      condition: {
        any: 'いつでも',
        skill: '必殺技使用時',
        in_combo: '攻撃を一定回数当てた時',
        others_skill: '味方が必殺技を使った時',
        mana_charged: 'マナが多いほど',
        mana_lost: 'マナが少ないほど',
        guard: 'ガードした時',
        scrap_charged: 'スクラップが多いほど',
        has_mana: 'マナを保持している時'
      },
      sub_condition: {
        has_mana: {
          mana_m: '魔マナ',
          mana_exclude_f: '戦マナ以外'
        }
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
        skill: '必殺技使用時',
        in_awakening: '覚醒ゲージがMAXの時'
      },
      sub_condition: {
        skill: {
          has_mana_f: '戦マナを所持'
        }
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
        heal_group: '特定の所属を回復',
        heal_all: '全員を回復',
        absorb: '与えたダメージを吸収'
      },
      sub_effect: {
        heal_self: {
          excess: 'HP超過'
        },
        heal_all: {
          excess: 'HP超過'
        }
      },
      condition: {
        any: 'いつでも',
        wave_start: '各WAVE開始時',
        boss_wave: 'BOSS WAVE時',
        attack: '通常攻撃時',
        critical: 'クリティカル時',
        guard: 'ガードした時',
        damaged: 'ダメージを受けた時',
        in_base_area: '自陣にいる時',
        in_enemy_area: '敵陣にいる時',
        in_enemy_back: '敵陣の奥にいる時',
        in_head: '先頭にいる時',
        in_front: '仲間より前にいる時',
        in_rear: '仲間より後ろにいる時',
        in_tail: '後ろに仲間がいない時',
        in_back: '最も後列にいる時',
        in_sub: 'サブパーティーにいる時',
        in_field: '特定のフィールドにいる時',
        skill: '必殺技使用時',
        others_skill: '味方が必殺技を使った時',
        job_skill: '特定の職が必殺技を使った時',
        any_skill: '誰かが必殺技を使った時',
        with_f: '戦士がいる時',
        with_k: '騎士がいる時',
        with_a: '弓使いがいる時',
        with_p: '僧侶がいる時',
        with_m: '魔法使いがいる時',
        with_fk: '戦/騎がいる時',
        with_kp: '騎/僧がいる時',
        with_fpm: '戦/僧/魔がいる時',
        with_sl: '<<斬>>がいる時',
        with_gu: '<<銃>>がいる時',
        with_sh: '<<狙>>がいる時',
        with_gush: '<<銃/狙>>がいる時',
        with_holytown: '所属：聖都がいる時',
        with_oasis: '所属：湖都がいる時',
        with_others: '所属：旅人がいる時',
        link: '複数で一緒に攻撃した時',
        dropout_self: '自身が脱落した時',
        dropout_member: '味方が脱落した時',
        in_debuff: '自分が状態異常の時',
        members_debuff: '味方に状態異常が多いほど',
        enemys_debuff: '敵に状態異常が多いほど',
        any_debuff: 'フィールドに状態異常が多いほど',
        with_enemy_debuff: '状態異常の敵がいる時',
        has_mana: 'マナを保持している時',
        use_mana: 'マナが使用された時',
        mana_droped: 'マナを獲得した時',
        kill: '敵を倒した時',
        kill_debuff: '状態異常の敵を倒した時',
        super_gauge_max: '超必殺技ゲージがMAXの時',
        targeted_self: '自身を選択中'
      },
      sub_condition: {
        any: {
          boost_on_enemy_area: '敵陣にいると効果上昇',
          boost_on_base_area: '自陣にいると効果上昇',
          boost_on_debuff_enemy: '状態異常の敵がいると効果上昇'
        },
        attack: {
          boost_on_critical: 'クリティカルだと効果上昇',
          boost_on_skill: '必殺技だと効果上昇',
          boost_on_sp_attack: 'クリティカルか必殺技だと効果上昇'
        },
        damaged: {
          with_span: '連続では発動しない'
        },
        wave_start: {
          repeat: '繰り返し発動'
        },
        in_front: {
          with_p: '僧侶',
          with_m: '魔法使い',
          boost_on_job_target: '対象が特定の職だと効果上昇'
        },
        in_sub: {
          field: '特定のフィールド',
          boost_on_union: '対象が特定の所属だと効果上昇'
        },
        others_skill: {
          job_f: '戦士',
          job_a: '弓使い',
          job_kam: '騎/弓/魔'
        },
        any_skill: {
          boost_on_user: '特定の使用者だと効果上昇'
        },
        with_f: {
          include_self: '自身を含む'
        },
        with_fk: {
          include_self: '自身を含む'
        },
        with_kp: {
          include_self: '自身を含む'
        },
        with_fpm: {
          include_self: '自身を含む'
        },
        has_mana: {
          mana_f: '戦マナ',
          mana_p: '僧マナ',
          mana_m: '魔マナ',
          mana_fm: '戦/魔マナ',
          mana_ka: '騎/弓マナ',
          mana_pm: '僧/魔マナ',
          mana_fka: '戦/騎/弓マナ',
          mana_exclude_a: '弓マナ以外'
        },
        mana_droped: {
          mana_f: '戦マナ',
          mana_k: '騎マナ',
          mana_p: '僧マナ',
          mana_m: '魔マナ',
          mana_fa: '戦/弓マナ',
          mana_fm: '戦/魔マナ',
          mana_pm: '僧/魔マナ'
        },
        job_skill: {
          job_f: '戦士',
          job_fm: '戦/魔',
          job_ka: '騎/弓'
        },
        kill: {
          boost_on_debuff_enemy: '状態異常の敵がだと効果上昇'
        }
      },
      target: {
        self: '自分',
        all: '全員',
        nearest: '最も近い対象',
        hp_worst: '最もHPの低い対象',
        lv_worst: '最もレベルが低い対象',
        owner: '主人',
        job_f: '戦士',
        job_k: '騎士',
        job_fk: '戦/騎',
        job_fp: '戦/僧',
        job_kp: '騎/僧',
        job_fpm: '戦/僧/魔',
        weapon_sl: '<<斬>>',
        weapon_pi: '<<突>>',
        weapon_blpi: '<<打/突>>',
        weapon_slpibl: '<<斬/突/打>>',
        weapon_exclude_ma: '<<魔>>以外',
        group_guildtown: '副都所属',
        group_oasis: '湖都所属',
        group_forest: '精霊島所属',
        group_volcano: '九領所属',
        group_beasts: 'ケ者所属',
        group_others: '旅人所属',
        group_demon: '魔神所属',
        base_area_member: '自陣にいる味方'
      },
      sub_target: {
        all: {
          boost_for_union: '対象が特定の所属だと効果上昇',
          boost_for_jobs: '対象が特定の職業だと効果上昇'
        },
        job_f: {
          nearest: '最も近い対象'
        },
        job_k: {
          nearest: '最も近い対象',
          hp_worst: '最もHPの低い対象'
        },
        job_fk: {
          hp_worst: '最もHPの低い対象',
          atk_best: '最も攻撃力が大きい対象'
        },
        base_area_member: {
          group_others: '旅人所属',
          boost_for_self: '自身は効果上昇'
        }
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
        atkdown: '攻撃力低下付与',
        defdown: '防御力低下付与',
        speeddown: '移動速度低下付与',
        atkdefdown: '攻撃力/防御力低下付与',
        atkspeeddown: '攻撃力/移動速度低下付与',
        defspeeddown: '防御力/移動速度低下付与',
        fulldown: '攻撃力/防御力/移動速度低下付与',
        delayup: '攻撃速度低下付与',
        shield_break: '盾を破壊する',
        weak_element: '属性弱点付与'
      },
      sub_effect: {
        weak_element: {
          ice: '氷属性',
          fireice: '火/氷属性'
        }
      },
      condition: {
        attack: '通常攻撃時',
        critical: 'クリティカル時',
        skill: '必殺技使用時',
        counter: 'カウンター発生時',
        shoot: '遠距離攻撃時',
        combat: '近接攻撃時',
        extra_attack: '追撃発生時',
        blast_attack: '範囲攻撃発生時',
        add_blind: '暗闇を与えた時',
        add_down: 'ダウンさせた時',
        add_freeze: '凍結を与えた時',
        add_poison: '毒を与えた時',
        add_slow: 'スロウを与えた時',
        add_curse: '呪いを与えた時',
        heal_action: '回復行動時'
      },
      sub_condition: {
        attack: {
          in_combo: 'コンボ中のみ',
          super_gauge_max: '超必殺技ゲージがMAXの時',
          in_awakening: '覚醒ゲージがMAXの時',
          boost_on_critical: 'クリティカルだと効果上昇',
          boost_on_skill: '必殺技だと効果上昇',
          boost_on_sp_attack: 'クリティカルか必殺技だと効果上昇',
          boost_on_add_debuff: '状態異常を付与すると効果上昇'
        },
        shoot: {
          boost_on_add_debuff: '状態異常を付与すると効果上昇'
        },
        skill: {
          in_combo: 'コンボ中のみ',
          has_mana_m: '魔マナを所持',
          has_mana_fk: '戦/騎マナを所持',
          has_mana_fkap: '魔マナ以外を所持',
          has_mana_fkap_all: '戦＋騎＋弓＋僧マナを所持'
        }
      },
      target: {
        enemy: '敵',
        heal_area_enemy: '回復範囲内の敵'
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
        guard_all: '全ての状態異常を防止',
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
        skill: '必殺技使用時',
        wave_start: '各WAVE開始時',
        use_mana: 'マナが使用された時',
        any_skill: '誰かが必殺技を使った時',
        own_skill: '自分が必殺技を使った時'
      },
      sub_condition: {
        skill: {
          has_mana_m: '魔マナを所持',
          has_mana_fk: '戦/騎マナを所持'
        }
      },
      target: {
        self: '自分',
        all: '全員',
        job_k: '騎士',
        job_fp: '戦/僧'
      },
      sub_target: {
        job_k: {
          nearest: '最も近い対象'
        }
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
        limited_slot: 'スロットが特定のマナのみ',
        recycle_scrap: 'スクラップをマナに変換',
        destroy_scrap: 'スクラップを破壊'
      },
      sub_effect: {
        mana_charge: {
          mana_f: '戦マナ',
          mana_k: '騎マナ',
          mana_a: '弓マナ',
          mana_p: '僧マナ',
          mana_m: '魔マナ',
          mana_fk: '戦＋騎',
          mana_fa: '戦＋弓',
          mana_fm: '戦＋魔',
          mana_fp: '戦＋僧',
          mana_ka: '騎＋弓',
          mana_kp: '騎＋僧',
          mana_ap: '弓＋僧',
          mana_pm: '僧＋魔',
          mana_fap: '戦＋弓＋僧',
          mana_fam: '戦＋弓＋魔',
          mana_kap: '騎＋弓＋僧',
          mana_fkam: '戦＋騎＋弓＋魔',
          mana_all: '虹色マナ',
          mana_demon: '魔神マナ',
          compressed_mana_f: '圧縮戦マナ',
          compressed_mana_k: '圧縮騎マナ',
          compressed_mana_a: '圧縮弓マナ',
          compressed_mana_m: '圧縮魔マナ',
          compressed_mana_all: '圧縮虹色マナ',
          compressed_mana_demon: '圧縮魔神マナ'
        },
        mana_boost: {
          mana_triple: '3つ出やすい'
        },
        mana_drop: {
          mana_f: '戦マナ',
          mana_k: '騎マナ',
          mana_a: '弓マナ',
          mana_p: '僧マナ',
          mana_m: '魔マナ',
          mana_fk: '戦＋騎',
          mana_fm: '戦＋魔',
          mana_ka: '騎＋弓',
          mana_fkm: '戦＋騎＋魔',
          mana_fam: '戦＋弓＋魔',
          mana_fkam: '戦＋騎＋弓＋魔'
        },
        composite: {
          mana_fk: '戦＋騎',
          mana_fa: '戦＋弓',
          mana_fp: '戦＋僧',
          mana_fm: '戦＋魔',
          mana_ka: '騎＋弓',
          mana_kp: '騎＋僧',
          mana_km: '騎＋魔',
          mana_ap: '弓＋僧',
          mana_am: '弓＋魔',
          mana_pm: '僧＋魔',
          mana_fka: '戦＋騎＋弓',
          mana_fkp: '戦＋騎＋僧',
          mana_fap: '戦＋弓＋僧',
          mana_fam: '戦＋弓＋魔',
          mana_kap: '騎＋弓＋僧',
          mana_kam: '騎＋弓＋魔'
        },
        limited_slot: {
          mana_demon: '魔神マナ'
        },
        recycle_scrap: {
          mana_k: '騎マナ',
          mana_a: '弓マナ'
        }
      },
      condition: {
        any: 'いつでも',
        battle_start: '戦闘開始時',
        wave_start: '各WAVE開始時',
        boss_wave: 'BOSS WAVE時',
        wave_span: '一定WAVE進むごとに',
        kill: '敵を倒した時',
        kill_count: '一定数の敵を倒した時',
        dropout_self: '自身が脱落した時',
        own_skill: '自分が必殺技を使った時',
        in_chain: 'チェイン発動中',
        in_maxchain: 'MAXChain時',
        with_demon: '所属：魔神がいる時',
        in_heroic: '援軍として参戦した時'
      },
      sub_condition: {
        battle_start: {
          with_f: '戦士がいる特',
          with_k: '騎士がいる時',
          with_p: '僧侶がいる時',
          with_m: '魔法使いがいる時',
          in_sub: 'サブパーティーにいる時'
        },
        wave_start: {
          field: '特定のフィールド',
          boost_on_field: '特定のフィールドだと効果上昇'
        },
        kill: {
          critical: 'クリティカル時',
          skill: '必殺技使用時',
          boost_on_critical: 'クリティカルだと確率上昇',
          boost_on_sp_attack: 'クリティカルか必殺技だと確率上昇',
          boost_on_skill: '必殺技だと確率上昇',
          boost_on_field: '特定のフィールドだと確率上昇'
        },
        kill_count: {
          skill: '必殺技使用時'
        },
        dropout_self: {
          mana_f: '戦マナ'
        },
        with_demon: {
          include_self: '自身を含む'
        },
        in_heroic: {
          in_chain: 'チェイン発動中'
        }
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
        arup: '攻撃力/クリティカル威力上昇',
        dsup: '防御力/移動速度上昇',
        adsup: '攻撃力/防御力/移動速度上昇',
        adcup: '攻撃力/防御力/クリティカル率上昇',
        adrup: '攻撃力/防御力/クリティカル威力上昇',
        ascup: '攻撃力/移動速度/クリティカル率上昇',
        acrup: '攻撃力/クリティカル率/クリティカル威力上昇',
        adscup: '攻撃力/防御力/移動速度/クリティカル率上昇',
        adsrup: '攻撃力/防御力/移動速度/クリティカル威力上昇',
        adcrup: '攻撃力/防御力/クリティカル率/クリティカル威力上昇',
        delayoff: '攻撃速度上昇'
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
        in_sea: '海中で戦闘時',
        in_all_sea: '砂浜/船上/海中で戦闘時',
        in_upland: '高地で戦闘時',
        in_snow: '雪山で戦闘時',
        in_prison: '監獄で戦闘時',
        in_night: '夜に戦闘時',
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
      sub_effect: {
        combat: {
          combat_only: '遠距離攻撃不能',
          atkdown_shoot: '遠距離威力低下'
        }
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
      sub_effect: {
        pierce: {
          momentary: '一定時間',
          bullet_speeddown: '弾速低下'
        }
      },
      condition: {
        shoot: '遠距離攻撃時',
        kill: '敵を倒した時',
        skill: '必殺技使用時',
        in_combo: '攻撃を一定回数当てた時'
      },
      sub_condition: {
        in_combo: {
          shoot: '遠距離攻撃時'
        }
      },
      target: {
        enemy: '敵'
      }
    },
    counter: {
      name: 'カウンター',
      effect: {
        counterattack: 'カウンター攻撃',
        counterattack_contact: 'カウンター攻撃（接触）',
        reflect_arrow: '遠距離反射',
        reflect_arrow_pierce: '遠距離反射（貫通）',
        reflect_magic: '魔法反射'
      },
      sub_effect: {
        counterattack: {
          ice: '氷属性'
        },
        counterattack_contact: {
          fire: '火属性',
          ice: '氷属性'
        },
        reflect_arrow: {
          fire: '火属性',
          ice: '氷属性'
        }
      },
      condition: {
        any: 'いつでも',
        defend: '攻撃を受けた時',
        guard: 'ガードした時',
        random: '一定確率で'
      },
      sub_condition: {
        any: {
          with_span: '連続では発動しない'
        }
      },
      target: {
        enemy: '敵'
      }
    },
    auto_skill: {
      name: '自動スキル発動',
      effect: {
        attack: '攻撃スキル発動',
        field: 'フィールド変更スキル発動',
        area: '領域展開/設置スキル発動',
        enchant: '付与スキル発動'
      },
      sub_effect: {
        attack: {
          range_dash: '範囲・ダッシュ',
          range_random_blast: '範囲・ランダム/爆発',
          summon: '召喚'
        },
        field: {
          ship: '船上',
          night: '夜'
        },
        area: {
          echo: '[領域] 反響'
        },
        enchant: {
          all: '全体'
        }
      },
      condition: {
        battle_start: '戦闘開始時',
        boss_wave: 'BOSS WAVE時'
      },
      target: {
        self: ''
      }
    },
    invincible: {
      name: '無敵',
      effect: {
        invincible: '無敵になる'
      },
      condition: {
        dropout_self: '自身が脱落した時',
        in_heroic: '援軍として参戦した時'
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
    heroic: {
      name: 'ヒロイックスキル',
      effect: {
        heroic: 'ヒロイックスキルに設定可能'
      },
      condition: {
        in_ptedit: 'パーティー編成時'
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
    CATEGORYS.each do |k, v|
      ret[k] = v.fetch(:effect, {})
    end
    ret
  end.call.freeze

  SUB_EFFECTS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      sret = {}
      v.fetch(:sub_effect, {}).each do |sk, sv|
        sret[sk] = sv
      end
      ret[k] = sret
    end
    ret
  end.call.freeze

  CONDITIONS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      ret[k] = v.fetch(:condition, {})
    end
    ret
  end.call.freeze

  SUB_CONDITIONS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      sret = {}
      v.fetch(:sub_condition, {}).each do |sk, sv|
        sret[sk] = sv
      end
      ret[k] = sret
    end
    ret
  end.call.freeze

  TARGETS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      ret[k] = v.fetch(:target, {})
    end
    ret
  end.call.freeze

  SUB_TARGETS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      sret = {}
      v.fetch(:sub_target, {}).each do |sk, sv|
        sret[sk] = sv
      end
      ret[k] = sret
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

      ret[k] = v.fetch(:effect, {}).to_a.reject { |d| d.first.to_s.end_with?('up_m') }
    end
    ret
  end.call.freeze

  SUB_EFFECT_CONDS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      next if k == :unknown

      base = {}
      v.fetch(:sub_effect, {}).each do |sk, sv|
        m = sk.to_s.match(/\A(.+up)_m\z/)
        if m
          key = m[1].to_sym
          base[key] = (base[key] || {}).merge(sv)
        else
          base[sk] = sv
        end
      end

      sret = {}
      base.each do |sk, sv|
        sret[sk] = sv.to_a
      end
      ret[k] = sret
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

  SUB_CONDITION_CONDS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      next if k == :unknown

      sret = {}
      v.fetch(:sub_condition, {}).each do |sk, sv|
        sret[sk] = sv.to_a
      end
      ret[k] = sret
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

  SUB_TARGET_CONDS = lambda do
    ret = {}
    CATEGORYS.each do |k, v|
      next if k == :unknown

      sret = {}
      v.fetch(:sub_target, {}).each do |sk, sv|
        sret[sk] = sv.to_a
      end
      ret[k] = sret
    end
    ret
  end.call.freeze

  BUFF_TYPES = lambda do
    ret = []
    CATEGORYS.each_value do |cv|
      ret << cv[:effect].keys.select { |k| k.match?(/\A[a|d|s|c|r]+up\z/) }
    end
    ret.flatten.uniq.compact.map(&:to_s)
  end.call.freeze

  CONDITION_GROUP = {
    in_beach: ['in_all_sea'],
    in_ship: ['in_all_sea'],
    in_sea: ['in_all_sea']
  }.freeze

  EFFECT_GROUP = {
    aup: BUFF_TYPES.select { |s| s.match?(/a/) },
    dup: BUFF_TYPES.select { |s| s.match?(/d/) },
    sup: BUFF_TYPES.select { |s| s.match?(/s/) },
    cup: BUFF_TYPES.select { |s| s.match?(/c/) },
    rup: BUFF_TYPES.select { |s| s.match?(/r/) },
    areaup: %w[healareaup areashift],
    healup: %w[healareaup],
    atkdown: %w[atkdefdown atkspeeddown fulldown],
    defdown: %w[atkdefdown defspeeddown fulldown],
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

  ALL_TARGETS = lambda do
    ret = []
    CATEGORYS.each_value do |cv|
      ret << cv[:target].keys
    end
    ret.flatten.uniq.map(&:to_s)
  end.call.freeze

  JOB_TARGETS = ALL_TARGETS.select { |t| t.start_with?('job_') }.freeze
  WEAPON_TARGETS = ALL_TARGETS.select { |t| t.start_with?('weapon_') }.freeze

  TARGET_GROUP = {
    job_f: JOB_TARGETS.select { |t| t.match(/f/) },
    job_k: JOB_TARGETS.select { |t| t.match(/k/) },
    job_a: JOB_TARGETS.select { |t| t.match(/a/) },
    job_p: JOB_TARGETS.select { |t| t.match(/p/) },
    job_m: JOB_TARGETS.select { |t| t.match(/m/) },
    weapon_sl: WEAPON_TARGETS.select { |t| t.match(/sl/) },
    weapon_bl: WEAPON_TARGETS.select { |t| t.match(/bl/) },
    weapon_pi: WEAPON_TARGETS.select { |t| t.match(/pi/) },
    weapon_ar: WEAPON_TARGETS.select { |t| t.match(/ar/) },
    weapon_ma: WEAPON_TARGETS.select { |t| t.match(/ma/) },
    weapon_he: WEAPON_TARGETS.select { |t| t.match(/he/) },
    weapon_pu: WEAPON_TARGETS.select { |t| t.match(/pu/) },
    weapon_gu: WEAPON_TARGETS.select { |t| t.match(/gu/) },
    weapon_sh: WEAPON_TARGETS.select { |t| t.match(/sh/) }
  }.freeze

  class << self
    def chain_ability_categorys
      keys = AbilityEffect.joins(:ability)
                          .merge(Ability.chain_abilities)
                          .distinct
                          .pluck(:category)

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

    def chain_ability_sub_effects
      create_chain_sub_conds(:effect)
    end

    def chain_ability_sub_conditions
      create_chain_sub_conds(:condition)
    end

    def chain_ability_sub_targets
      create_chain_sub_conds(:target)
    end

    def valid_category?(cate)
      return false if cate.blank?

      CATEGORYS.key?(cate.to_sym)
    end

    def valid_condition?(cate, cond)
      return false if cate.blank? || cond.blank?

      CONDITIONS.dig(cate.to_sym, cond.to_sym).nil? ? false : true
    end

    def valid_sub_condition?(cate, cond, sub)
      return false if cate.blank? || cond.blank? || sub.blank?

      SUB_CONDITIONS.dig(cate.to_sym, cond.to_sym, sub.to_sym).nil? ? false : true
    end

    def valid_effect?(cate, effect)
      return false if cate.blank? || effect.blank?

      EFFECTS.dig(cate.to_sym, effect.to_sym).nil? ? false : true
    end

    def valid_sub_effect?(cate, effect, sub)
      return false if cate.blank? || effect.blank? || sub.blank?

      SUB_EFFECTS.dig(cate.to_sym, effect.to_sym, sub.to_sym).nil? ? false : true
    end

    def valid_target?(cate, target)
      return false if cate.blank? || target.blank?

      TARGETS.dig(cate.to_sym, target.to_sym).nil? ? false : true
    end

    def valid_sub_target?(cate, target, sub)
      return false if cate.blank? || target.blank? || sub.blank?

      SUB_TARGETS.dig(cate.to_sym, target.to_sym, sub.to_sym).nil? ? false : true
    end

    private

    def create_chain_conds(key)
      conds = AbilityEffect.joins(:ability)
                           .merge(Ability.chain_abilities)
                           .distinct
                           .pluck(:category, key)

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

    # NOTE: 今のところ未使用
    def create_chain_sub_conds(key)
      sub_key = "sub_#{key}".to_sym
      conds = AbilityEffect.joins(:ability)
                           .merge(Ability.chain_abilities)
                           .distinct
                           .pluck(:category, key, sub_key)

      cos = conds.each_with_object({}) do |co, h|
        cate, fk, sk = co.map(&:to_sym)
        h[cate] ||= {}
        h[cate][fk] ||= []
        h[cate][fk] << sk
      end

      ret = {}
      CATEGORYS.each do |k, v|
        next if k == :unknown

        has = cos[k]
        next unless has

        sret = {}
        v.fetch(sub_key, {}).each do |sk, sv|
          next unless has[sk]

          li = []
          sv.each do |ssk, name|
            next unless has[sk].include?(ssk)

            li << [ssk, name]
          end
          sret[sk] = li if li.present?
        end
        ret[k] = sret if sret.present?
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
    ef['condition'] = CONDITIONS.dig(self.category.to_sym, self.condition.to_sym) || ''
    ef['sub_condition'] = SUB_CONDITIONS.dig(
      self.category.to_sym, self.condition.to_sym, self.sub_condition.to_sym
    ) || ''
    ef['condition_note'] = self.condition_note.to_s
    ef['effect'] = EFFECTS.dig(self.category.to_sym, self.effect.to_sym) || ''
    ef['sub_effect'] = SUB_EFFECTS.dig(
      self.category.to_sym, self.effect.to_sym, self.sub_effect.to_sym
    ) || ''
    ef['effect_note'] = self.effect_note.to_s
    ef['target'] = TARGETS.dig(self.category.to_sym, self.target.to_sym) || ''
    ef['sub_target'] = SUB_TARGETS.dig(
      self.category.to_sym, self.target.to_sym, self.sub_target.to_sym
    ) || ''
    ef['target_note'] = self.target_note.to_s
    ef
  end
end
# rubocop:enable Metrics/ClassLength, Metrics/MethodLength, Metrics/AbcSize
