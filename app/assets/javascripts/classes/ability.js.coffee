class window.Ability

  CONDITION_TABLE =
    add_blind: '暗闇を与えた時'
    add_poison: '毒を与えた時'
    add_slow: 'スロウを与えた時'
    any: 'いつでも'
    attack: '通常攻撃時'
    battle_end: '戦闘終了時'
    battle_start: '戦闘開始時'
    boss_wave: 'BOSS WAVE時'
    counter: 'カウンター発生時'
    critical: 'クリティカル時'
    cycle: '一定間隔で'
    defend: '攻撃を受けた時'
    dropout_member: '味方が脱落した時'
    dropout_self: '自身が脱落した時'
    enemys_debuff: '敵に状態異常が多いほど'
    for_blind: '敵が暗闇の時'
    for_curse: '敵が呪いの時'
    for_down: '敵がダウン中'
    for_poison: '敵が毒の時'
    for_slow: '敵がスロウの時'
    for_weaken: '敵が衰弱の時'
    for_forest_f: '精霊島の戦士が'
    for_forest_m: '精霊島の魔法使いが'
    guard: 'ガードした時'
    heal: '回復時'
    hp_downto: 'HPが一定以下の時'
    hp_downto_more: 'HPがより低い時'
    hp_full: 'HPが満タンの時'
    hp_upto: 'HPが一定以上の時'
    hp_upto_more: 'HPがより高い時'
    in_base_area: '自陣にいる時'
    in_combo: '攻撃を一定回数当てた時'
    in_poison: '自分が毒状態の時'
    in_slow: '自分がスロウ状態の時'
    in_blind: '自分が暗闇状態の時'
    in_seal: '自分が封印状態の時'
    in_debuff: '自分が状態異常の時'
    in_emeny_area: '敵陣にいる時'
    in_emeny_back: '敵陣の奥にいる時'
    in_field: '特定のフィールドで'
    in_front: '仲間より前にいる時'
    in_head: '先頭にいる時'
    in_move: '移動中'
    in_pierce: '貫通した時'
    in_rear: '仲間より後ろにいる時'
    in_sub: 'サブパーティーにいる時'
    kill: '敵を倒した時'
    kill_debuff: '状態異常の敵を倒した時'
    killer: '特定の敵に対して'
    link: '複数で一緒に攻撃した時'
    mana_charged: 'マナが多いほど'
    mana_lost: 'マナが少ないほど'
    members_debuff: '味方に状態異常が多いほど'
    others_skill: '味方がスキルを使った時'
    same_abilities: '同じアビリティを持った味方がいる時'
    skill: 'スキル使用時'
    union: '特定の職構成の時'
    wave_start: '各WAVE開始時'
    with_a: '弓使いと一緒の時'
    with_f: '戦士と一緒の時'
    with_m: '魔法使いと一緒の時'
    unknown: '（不明）'

  CONDITION_LIST = [
    'any'
    'hp_upto'
    'hp_upto_more'
    'hp_downto'
    'hp_downto_more'
    'hp_full'
    'attack'
    'critical'
    'skill'
    'defend'
    'guard'
    'counter'
    'in_combo'
    'in_pierce'
    'kill'
    'kill_debuff'
    'heal'
    'in_move'
    'killer'
    'in_front'
    'in_head'
    'in_rear'
    'in_base_area'
    'in_emeny_area'
    'in_emeny_back'
    'others_skill'
    'mana_charged'
    'mana_lost'
    'boss_wave'
    'wave_start'
    'cycle'
    'for_blind'
    'for_slow'
    'for_poison'
    'for_down'
    'for_curse'
    'for_weaken'
    'in_poison'
    'in_slow'
    'in_blind'
    'in_seal'
    'in_debuff'
    'add_poison'
    'add_blind'
    'add_slow'
    'dropout_member'
    'dropout_self'
    'battle_start'
    'battle_end'
    'in_field'
    'union'
    'with_f'
    'with_a'
    'with_m'
    'same_abilities'
    'in_sub'
  ]

  EFFECT_TABLE =
    absorb:
      name: '与えたダメージを吸収'
      conditions: ['attack', 'critical', 'skill']
      chains: ['attack', 'critical']
    ap_recover:
      name: 'APを回復'
      conditions: []
    areadown:
      name: '回復範囲減少'
      conditions: []
      chains: []
    areaup:
      name: '回復範囲増加'
      conditions: []
      chains: []
    atkdown:
      name: '与えるダメージ減少'
      conditions: []
      chains: []
    atkdown_enemy:
      name: '敵の攻撃力低下'
      conditions: []
      chains: []
    atkup:
      name: '与えるダメージ上昇'
      conditions: ['any', 'hp_upto', 'hp_upto_more', 'hp_downto',
        'hp_downto_more', 'hp_full', 'attack', 'critical', 'in_combo', 'in_pierce',
        'guard', 'kill', 'killer', 'kill_debuff',
        'in_front', 'in_head', 'in_emeny_area', 'in_emeny_back',
        'others_skill', 'link', 'mana_charged', 'boss_wave', 'wave_start',
        'for_blind', 'for_slow', 'for_poison', 'for_down', 'for_curse', 'for_weaken',
        'in_poison', 'in_debuff', 'in_field', 'dropout_member', 'union',
        'with_f', 'same_abilities']
      chains: ['any', 'hp_upto', 'hp_downto', 'attack', 'critical',
        'killer', 'in_field', 'boss_wave', 'for_blind', 'for_slow', 'for_poison',
        'for_down', 'for_curse', 'for_weaken', 'in_poison',
        'in_slow', 'in_blind', 'in_debuff', 'dropout_member']
    atkup_all:
      name: '全員の与えるダメージ上昇'
      conditions: ['any', 'in_sub', 'wave_start', 'dropout_self', 'others_skill']
      chains: []
    atkup_for_job_best:
      name: '特定の職で残りHPが高い対象の与えるダメージ上昇'
      conditions: []
    atkup_for_job_near:
      name: '特定の職で一番近い対象の与えるダメージ上昇'
      conditions: []
    atkup_random:
      name: '誰か一人の与えるダメージ上昇'
      conditions: []
    atkup_hp_worst:
      name: '一番ダメージが大きい対象の与えるダメージ上昇'
      conditions: []
    blind:
      name: '暗闇付与'
      conditions: ['attack', 'skill']
      chains: ['attack', 'skill']
    boost_heal:
      name: '回復効果上昇'
      conditions: []
      chains: []
    boost_skill:
      name: 'スキル効果上昇'
      conditions: []
    buff_forests:
      name: '精霊島所属がステータス上昇'
    buff_jobs:
      name: '特定の職がステータス上昇'
      conditions: ['any', 'union']
    buff_weapons:
      name: '特定の武器タイプがステータス上昇'
      conditions: []
    combat:
      name: '接近戦可能'
      conditions: []
      chains: []
    counterattack:
      name: 'カウンター攻撃'
      conditions: []
    critup:
      name: 'クリティカル率上昇'
      conditions: ['attack', 'wave_start', 'for_forest_f']
      chains: []
    critup_all:
      name: '全員のクリティカル率上昇'
      conditions: []
    critup_hp_worst:
      name: '一番ダメージが大きい対象のクリティカル率上昇'
      conditions: []
    defdown:
      name: '受けるダメージ増加'
      conditions: ['any', 'kill', 'in_front', 'in_head', 'wave_start']
      chains: []
    defdown_all:
      name: '全員の受けるダメージ増加'
      conditions: []
      chains: []
    defdown_enemy:
      name: '敵の防御力低下'
      conditions: []
      chains: []
    defup:
      name: '受けるダメージ軽減'
      conditions: ['any', 'hp_upto', 'hp_downto', 'hp_downto_more', 'in_combo',
        'others_skill', 'guard', 'kill', 'killer', 'in_field', 'boss_wave', 'wave_start',
        'for_slow', 'in_blind', 'in_debuff', 'dropout_member', 'union', 'with_a', 'same_abilities']
      chains: ['any', 'hp_upto', 'hp_downto', 'hp_downto_more',
        'killer', 'in_field', 'boss_wave']
    defup_all:
      name: '全員のダメージ軽減'
      conditions: ['any', 'in_sub']
      chains: []
    defup_for_job_best:
      name: '特定の職で残りHPが高い対象のダメージ軽減'
      conditions: []
    defup_for_job_atk_best:
      name: '特定の職で一番ATKが高い対象のダメージ軽減'
      conditions: []
    defup_for_job_worst:
      name: '特定の職で残りHPが低い対象のダメージ軽減'
      conditions: []
    defup_hp_worst:
      name: '一番ダメージが大きい対象のダメージ軽減'
      conditions: []
    delayoff:
      name: '攻撃間隔が早くなる'
      conditions: []
      chains: []
    delayup:
      name: '攻撃間隔が遅くなる'
      conditions: []
      chains: []
    down:
      name: 'ダウン付与'
      conditions: ['attack', 'critical', 'skill', 'counter']
      chains: ['attack', 'critical']
    expup:
      name: '獲得経験値上昇'
      conditions: []
      chains: []
    fire:
      name: '火属性'
      conditions: []
    freeze:
      name: '凍結付与'
      conditions: ['attack', 'critical', 'skill']
      chains: []
    goldup:
      name: '獲得金額上昇'
      conditions: []
      chains: []
    guard_all:
      name: '全ての状態異常を防ぐ'
      conditions: []
    guard_blind:
      name: '暗闇を防ぐ'
      conditions: []
      chains: []
    guard_curse:
      name: '呪いを防ぐ'
      conditions: []
      chains: []
    guard_down:
      name: 'ダウンを防ぐ'
      conditions: []
      chains: []
    guard_fire:
      name: '火属性を軽減する'
      conditions: []
      chains: []
    guard_freeze:
      name: '凍結を防ぐ'
      conditions: []
      chains: []
    guard_ice:
      name: '氷属性を軽減する'
      conditions: []
      chains: []
    guard_poison:
      name: '毒を防ぐ'
      conditions: []
      chains: []
    guard_push:
      name: '弾き飛ばしを防ぐ'
      conditions: []
    guard_seal:
      name: '封印を防ぐ'
      conditions: []
      chains: []
    guard_slow:
      name: 'スロウを防ぐ'
      conditions: []
      chains: []
    guard_undead:
      name: '白骨化を防ぐ'
      conditions: []
      chains: []
    guard_weaken:
      name: '衰弱を防ぐ'
      conditions: []
    guardup:
      name: '遠距離ダメージカット上昇'
      conditions: []
      chains: []
    heal_all:
      name: '全員を回復'
      conditions: ['wave_start', 'dropout_self', 'others_skill']
      chains: []
    heal_self:
      name: '自身を回復'
      conditions: ['wave_start', 'cycle', 'in_rear', 'in_base_area',
        'others_skill', 'union', 'dropout_self', 'members_debuff']
      chains: ['wave_start', 'cycle']
    heal_worst:
      name: '一番ダメージが大きい対象を回復'
      conditions: []
      chains: []
    heal_for_job_atk_best:
      name: '特定の職で一番ATKが高い対象を回復'
      conditions: []
      chains: []
    heal_for_job_worst:
      name: '特定の職で一番ダメージが大きい対象を回復'
      conditions: []
      chains: []
    heal_lowlv:
      name: '一番レベルが低い対象を回復'
    healup:
      name: '回復量上昇'
      conditions: []
      chains: []
    ice:
      name: '氷属性'
      conditions: []
    invincible:
      name: '無敵になる'
      conditions: []
    invisible:
      name: '見えなくなる（遠距離無効）'
      conditions: []
    mana_boost:
      name: 'スロットで複数マナが出やすい'
      conditions: []
      chains: []
    mana_charge:
      name: 'マナを持って開始'
      conditions: []
      chains: []
    mana_cost_down:
      name: 'スキルでの消費マナ低下'
      conditions: []
    mana_drop:
      name: 'マナを落とす'
      conditions: ['kill', 'dropout_self']
    maxhpup:
      name: '最大HP増加'
      conditions: []
    pierce:
      name: '貫通攻撃'
      conditions: ['attack', 'skill', 'kill']
      chains: []
    poison:
      name: '毒付与'
      conditions: ['attack', 'skill']
      chains: ['attack', 'skill']
    poison_atkup:
      name: '毒ダメージ上昇'
      conditions: []
      chains: []
    push:
      name: '弾き飛ばし付与'
      conditions: ['critical', 'skill']
    registup:
      name: '魔法ダメージ軽減'
      conditions: []
    reflect_magic:
      name: '魔法反射'
      conditions: []
    shield_break:
      name: '盾を破壊する'
      conditions: []
    skill_atkdown:
      name: 'スキル威力減少'
      conditions: []
    skill_atkup:
      name: 'スキル威力上昇'
      conditions: ['any', 'mana_lost', 'others_skill', 'guard']
      chain:[]
    slot_slow:
      name: 'マナスロットが遅くなる'
      conditions: []
    skill_spread:
      name: 'スキル範囲拡大'
      conditions: []
    slow:
      name: 'スロウ付与'
      conditions: ['attack', 'critical', 'skill', 'for_forest_m']
      chains: ['attack', 'critical']
    speedup:
      name: '移動速度上昇'
      conditions: ['any', 'hp_upto', 'hp_downto', 'hp_downto_more', 'hp_full',
        'guard', 'in_combo', 'kill', 'in_field', 'in_slow', 'in_debuff',
        'boss_wave', 'wave_start', 'union', 'with_f', 'with_m','same_abilities']
      chains: ['any', 'hp_upto', 'hp_downto', 'in_field', 'boss_wave']
    speedup_all:
      name: '全員の移動速度上昇'
      conditions: ['any', 'wave_start', 'in_sub', 'dropout_self']
    treasure:
      name: '宝箱が出やすくなる'
      conditions: []
      chains: []
    unknown:
      name: '（不明）'
      conditions: []
      chains: []

  EFFECT_LIST = [
    'atkup'
    'skill_atkup'
    'defup'
    'guardup'
    'speedup'
    'critup'
    'registup'
    'delayoff'
    'delayup'
    'maxhpup'
    'atkup_for_job_best'
    'atkup_for_job_near'
    'atkup_hp_worst'
    'defup_for_job_best'
    'defup_for_job_worst'
    'defup_for_job_atk_best'
    'defup_hp_worst'
    'critup_hp_worst'
    'atkdown_enemy'
    'defdown_enemy'
    'poison_atkup'
    'mana_cost_down'
    'skill_spread'
    'fire'
    'ice'
    'mana_drop'
    'pierce'
    'absorb'
    'counterattack'
    'reflect_magic'
    'combat'
    'invisible'
    'invincible'
    'healup'
    'areaup'
    'heal_self'
    'heal_worst'
    'heal_all'
    'heal_for_job_worst'
    'heal_for_job_atk_best'
    'heal_lowlv'
    'slow'
    'blind'
    'down'
    'poison'
    'freeze'
    'push'
    'guard_all'
    'guard_slow'
    'guard_blind'
    'guard_down'
    'guard_poison'
    'guard_freeze'
    'guard_push'
    'guard_seal'
    'guard_weaken'
    'guard_curse'
    'guard_undead'
    'atkup_all'
    'atkup_random'
    'defup_all'
    'speedup_all'
    'critup_all'
    'buff_jobs'
    'buff_slash'
    'buff_magic'
    'buff_forests'
    'boost_skill'
    'mana_charge'
    'mana_boost'
    'slot_slow'
    'treasure'
    'expup'
    'goldup'
    'ap_recover'
    'atkdown'
    'defdown'
    'areadown'
    'skill_atkdown'
  ]

  EFFECT_LIST_FOR_CHAIN = [
    'atkup'
    'skill_atkup'
    'defup'
    'guardup'
    'speedup'
    'pierce'
    'absorb'
    'combat'
    'healup'
    'areaup'
    'heal_self'
    'heal_worst'
    'heal_all'
    'slow'
    'blind'
    'down'
    'poison'
    'freeze'
    'guard_fire'
    'guard_ice'
    'guard_slow'
    'guard_blind'
    'guard_down'
    'guard_poison'
    'guard_freeze'
    'guard_seal'
    'atkup_all'
    'defup_all'
    'defdown_all'
    'mana_charge'
    'mana_boost'
    'treasure'
    'expup'
    'goldup'
    'atkdown'
    'defdown'
    'areadown'
  ]

  @conditions = -> CONDITION_LIST
  @conditionNameFor = (c) -> CONDITION_TABLE[c] || ''
  @effects = -> EFFECT_LIST
  @chainEffects = -> EFFECT_LIST_FOR_CHAIN
  @effectNameFor = (e) -> EFFECT_TABLE[e]?.name || ''
  @conditionsFor = (e) -> EFFECT_TABLE[e]?.conditions || []
  @chainConditionsFor = (e) -> EFFECT_TABLE[e]?.chains || []

  constructor: (data) ->
    @name = data.name || ''
    @explanation = data.explanation || ''
    @effects = []
    if data.effects
      for e in data.effects
        d =
          conditionType: e.condition_type
          effectType: e.effect_type
        @effects.push d
