class Skill

  SKILL_TABLE =
    attack:
      name: '攻撃'
      types: ['one/short', 'one/line', 'one/combo', 'one/dash', 'one/rear',
        'one/jump', 'one/random', 'one/combination', 'range/line',
        'range/dash', 'range/forward', 'range/self', 'range/explosion',
        'range/drop', 'range/jump', 'range/random', 'range/all']
      subname:
        'one/short': '単体・目前'
        'one/line': '単体・直線'
        'one/combo': '単体・連続'
        'one/dash': '単体・ダッシュ'
        'one/rear': '単体・最後列'
        'one/jump': '単体・ジャンプ'
        'one/random': '単体・ランダム'
        'one/combination': '単体・コンビネーション'
        'range/line': '範囲・直線'
        'range/dash': '範囲・ダッシュ'
        'range/forward': '範囲・前方'
        'range/self': '範囲・自分中心'
        'range/explosion': '範囲・自爆'
        'range/drop': '範囲・落下物'
        'range/jump': '範囲・ジャンプ'
        'range/random': '範囲・ランダム'
        'range/all': '範囲・全体'
    heal:
      name: '回復'
      types: ['all/instant', 'all/cycle', 'one/self', 'one/worst']
      subname:
        'all/instant': '全体・即時'
        'all/cycle': '全体・オート'
        'one/self': '単体・自分'
        'one/worst': '単体・一番低い対象'
    'song/dance':
      name: '歌・舞'
      types: ['buff', 'debuff']
      subname:
        buff: '味方上昇'
        debuff: '敵状態異常'
    buff:
      name: '能力UP'
      types: ['self', 'all', 'random']
      subname:
        self: '自身'
        all: '全体'
        random: 'ランダム'
    barrier:
      name: 'バリア'
      types: ['self', 'all']
      subname:
        self: '自身'
        all: '全体'
    obstacle:
      name: '障害物設置'
      types: []
      subname: {}

  EFFECT_TABLE =
    attack:
      types: ['fire', 'ice', 'push', 'down', 'blind', 'slow', 'poison',
        'freeze', 'curse', 'charge', 'shield_break']
      effectname:
        blind: '暗闇追加'
        charge: '溜め'
        curse: '呪い追加'
        down: 'ダウン追加'
        fire: '火属性'
        freeze: '凍結追加'
        ice: '氷属性'
        poison: '毒追加'
        push: '弾き飛ばし'
        shield_break: '盾破壊'
        slow: 'スロウ追加'
    heal:
      types: ['poison', 'blind', 'slow', 'freeze',
        'seal', 'weaken', 'atkup', 'defup']
      effectname:
        atkup: '与えるダメージ上昇'
        blind: '暗闇解除'
        defup: '受けるダメージ軽減'
        freeze: '凍結解除'
        poison: '毒解除'
        seal: '封印解除'
        slow: 'スロウ解除'
        weaken: '衰弱解除'
    'song/dance':
      types: ['fire', 'ice', 'element', 'blind', 'freeze', 'guard_debuff',
        'debuff_blind', 'debuff_slow', 'debuff_poison']
      effectname:
        blind: '暗闇耐性'
        debuff_blind: '暗闇付与'
        debuff_slow: 'スロウ付与'
        debuff_poison: '毒付与'
        element: '属性軽減'
        fire: '炎属性軽減'
        freeze: '凍結耐性'
        guard_debuff: '状態異常耐性'
        ice: '氷属性軽減'
    buff:
      types: ['delayoff']
      effectname:
        delayoff: '攻撃間隔短縮'
    barrier:
      types: ['ice', 'element', 'blind', 'freeze' ,'debuff', 'invincible']
      effectname:
        blind: '暗闇耐性'
        debuff: '状態異常耐性'
        element: '属性軽減'
        freeze: '凍結耐性'
        ice: '氷軽減'
        invincible: '無敵'
    obstacle:
      types: []
      effectname: {}

  constructor: (data) ->
    @name = data.name || '？'
    @explanation = data.explanation || ''
    @cost = data.cost || '？'
    @effects = []
    if data.effects
      for e in data.effects
        d =
          category: e.category
          subcategory: e.subcategory
          subeffect1: e.subeffect1 || ''
          subeffect2: e.subeffect2 || ''
        @effects.push d

  @subeffectForEffect: (ef) ->
    return [] unless ef
    ret = []
    ret.push(ef.subeffect1) unless ef.subeffect1 == ''
    ret.push(ef.subeffect2) unless ef.subeffect2 == ''
    ret

  @typeNameFor = (s) -> SKILL_TABLE[s]?.name || '？'
  @subtypesFor = (s) -> SKILL_TABLE[s]?.types || []
  @subnameFor = (skill, sub) -> SKILL_TABLE[skill]?.subname?[sub] || '？'
  @effectTypesFor = (s) -> EFFECT_TABLE[s]?.types || []
  @effectNameFor = (s, e) -> EFFECT_TABLE[s]?.effectname?[e] || ''

class Ability

  CONDITION_TABLE =
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
    for_blind: '敵が暗闇の時'
    for_curse: '敵が呪いの時'
    for_down: '敵がダウン中'
    for_poison: '敵が毒の時'
    for_slow: '敵がスロウの時'
    for_weaken: '敵が衰弱の時'
    guard: 'ガードした時'
    heal: '回復時'
    hp_downto: 'HPが一定以下の時'
    hp_downto_more: 'HPがより低い時'
    hp_full: 'HPが満タンの時'
    hp_upto: 'HPが一定以上の時'
    hp_upto_more: 'HPがより高い時'
    in_base_area: '自陣にいる時'
    in_combo: '攻撃を一定回数当てた時'
    in_debuff: '自分が状態異常時'
    in_emeny_area: '敵陣にいる時'
    in_field: '特定のフィールドで'
    in_front: '仲間より前にいる時'
    in_move: '移動中'
    in_pierce: '貫通した時'
    in_sub: 'サブパーティーにいる時'
    kill: '敵を倒した時'
    killer: '特定の敵に対して'
    link: '複数で一緒に攻撃した時'
    mana_charged: 'マナが多いほど'
    mana_lost: 'マナが少ないほど'
    others_skill: '味方がスキルを使った時'
    skill: 'スキル使用時'
    union: '特定の職構成の時'
    wave_start: '各WAVE開始時'
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
    'heal'
    'in_move'
    'killer'
    'in_front'
    'in_base_area'
    'in_emeny_area'
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
    'in_debuff'
    'dropout_member'
    'dropout_self'
    'battle_start'
    'battle_end'
    'in_field'
    'union'
    'in_sub'
  ]

  EFFECT_TABLE =
    absorb:
      name: '与えたダメージを吸収'
      conditions: ['attack', 'critical']
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
    atkup:
      name: '与えるダメージ上昇'
      conditions: ['any', 'hp_upto', 'hp_upto_more', 'hp_downto',
        'hp_downto_more', 'hp_full', 'attack', 'critical', 'in_combo', 'in_pierce',
        'guard', 'kill', 'killer', 'in_front', 'in_emeny_area', 'others_skill', 'link',
        'mana_charged', 'boss_wave', 'wave_start', 'for_blind', 'for_slow',
        'for_poison', 'for_down', 'for_curse', 'for_weaken',
        'in_debuff', 'in_field', 'dropout_member', 'union']
      chains: ['any', 'hp_upto', 'hp_downto', 'attack', 'critical',
        'killer', 'in_field', 'boss_wave', 'for_blind', 'for_slow', 'for_poison',
        'for_down', 'for_curse', 'for_weaken', 'in_debuff', 'dropout_member']
    atkup_all:
      name: '全員の与えるダメージ上昇'
      conditions: ['any', 'in_sub', 'wave_start', 'dropout_self']
      chains: []
    atkup_for_job_best:
      name: '特定の職で残りHPが高い対象の与えるダメージ上昇'
      conditions: []
    atkup_random:
      name: '誰か一人の与えるダメージ上昇'
      conditions: []
    blind:
      name: '暗闇付与'
      conditions: ['attack', 'skill']
      chains: ['attack', 'skill']
    boost_heal:
      name: '回復効果上昇'
      conditions: []
    boost_skill:
      name: 'スキル効果上昇'
      conditions: []
    buff_all:
      name: '全員のステータス上昇'
      conditions: ['any', 'in_sub', 'dropout_self']
      chains: []
    buff_jobs:
      name: '特定の職がステータス上昇'
      conditions: ['any', 'union']
    combat:
      name: '接近戦可能'
      conditions: []
      chains: []
    counterattack:
      name: 'カウンター攻撃'
      conditions: []
    critup:
      name: 'クリティカル率上昇'
      conditions: []
      chains: []
    defdown:
      name: '受けるダメージ増加'
      conditions: ['any', 'kill', 'in_front', 'wavestart']
      chains: []
    defup:
      name: '受けるダメージ軽減'
      conditions: ['any', 'hp_upto', 'hp_downto', 'hp_downto_more',
        'in_combo', 'kill', 'killer', 'in_field', 'boss_wave', 'wave_start',
        'for_slow', 'in_debuff', 'dropout_member', 'union']
      chains: ['any', 'hp_upto', 'hp_downto', 'hp_downto_more',
        'killer', 'in_field', 'boss_wave']
    defup_all:
      name: '全員のダメージ軽減'
      conditions: ['any', 'in_sub']
      chains: []
    defup_for_job_best:
      name: '特定の職で残りHPが高い対象のダメージ軽減'
      conditions: []
    defup_for_job_worst:
      name: '特定の職で残りHPが低い対象のダメージ軽減'
      conditions: []
    delayoff:
      name: '攻撃間隔が早くなる'
      conditions: []
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
    guard_weaken:
      name: '衰弱を防ぐ'
      conditions: []
    guardup:
      name: '遠距離ダメージカット上昇'
      conditions: []
      chains: []
    heal_all:
      name: '全員を回復'
      conditions: ['wave_start', 'dropout_self']
      chains: []
    heal_self:
      name: '自身を回復'
      conditions: ['wave_start', 'cycle', 'in_base_area', 'others_skill',
        'union', 'dropout_self']
      chains: ['wave_start', 'cycle']
    heal_worst:
      name: '一番ダメージが大きい対象を回復'
      conditions: []
      chains: []
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
      conditions: ['attack', 'kill']
      chains: []
    poison:
      name: '毒付与'
      conditions: ['attack', 'skill']
      chains: ['attack', 'skill']
    push:
      name: '弾き飛ばし付与'
      conditions: ['critical', 'skill']
    registup:
      name: '魔法ダメージ軽減'
      conditions: []
    skill_atkup:
      name: '必殺技威力上昇'
      conditions: ['any', 'mana_lost', 'others_skill']
      chain:[]
    slot_slow:
      name: 'マナスロットが遅くなる'
      conditions: []
    slow:
      name: 'スロウ付与'
      conditions: ['attack', 'critical', 'skill']
      chains: ['attack', 'critical']
    speedup:
      name: '移動速度上昇'
      conditions: ['any', 'hp_upto', 'hp_downto', 'hp_downto_more', 'hp_full',
        'guard', 'in_combo', 'kill', 'in_field', 'in_debuff',
        'boss_wave', 'wave_start', 'union']
      chains: ['any', 'hp_upto', 'hp_downto', 'in_field', 'boss_wave']
    speedup_all:
      name: '全員の移動速度上昇'
      conditions: ['any', 'wave_start', 'in_sub']
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
    'maxhpup'
    'atkup_for_job_best'
    'defup_for_job_best'
    'defup_for_job_worst'
    'mana_cost_down'
    'fire'
    'ice'
    'mana_drop'
    'pierce'
    'absorb'
    'counterattack'
    'combat'
    'invisible'
    'invincible'
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
    'buff_all'
    'buff_jobs'
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
    'buff_all'
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

class Arcana

  JOB_NAME =
    F: '戦士'
    K: '騎士'
    A: '弓使い'
    M: '魔法使い'
    P: '僧侶'

  JOB_NAME_SHORT =
    F: '戦'
    K: '騎'
    A: '弓'
    M: '魔'
    P: '僧'

  CLASS_NAME =
    F: 'fighter'
    K: 'knight'
    A: 'archer'
    M: 'magician'
    P: 'priest'

  WEAPON_NAME =
    Sl: '斬'
    Bl: '打'
    Pi: '突'
    Ar: '弓'
    Ma: '魔'
    He: '聖'
    Pu: '拳'
    Gu: '銃'
    Sh: '狙'

  UNION_TYPE =
    unknown: '（調査中）'
    guildtown: '副都'
    holytown: '聖都'
    academy: '賢者の塔'
    mountain: '迷宮山脈'
    oasis: '湖都'
    forest: '精霊島'
    volcano: '九領'
    'forest-sea': '海風の港'
    dawnsea: '大海'
    beasts: 'ケ者'
    volunteers: '義勇軍'
    demon: '魔神'
    others: '旅人'

  SOURCE_TABLE =
    first:
      name: '1部'
      types: ['guildtown', 'holytown', 'academy', 'mountain',
        'oasis', 'forest', 'volcano', 'other']
      details:
        'guildtown': '副都・酒場'
        'holytown': '聖都・酒場'
        'academy': '賢者の塔・酒場'
        'mountain': '迷宮山脈・酒場'
        'oasis': '湖都・酒場'
        'forest': '精霊島・酒場'
        'volcano': '九領・酒場'
        'other': 'その他'
    second:
      name: '2部'
      types: ['forest-sea', 'dawnsea', 'beasts', 'other']
      details:
        'forest-sea': '海風の港・酒場'
        'dawnsea': '夜明けの大海・酒場'
        'beasts': 'ケ者・酒場'
        'other': 'その他'
    ring:
      name: 'リング系'
      types: ['trade', 'random']
      details:
        'trade': '交換'
        'random': 'ガチャ'
    event:
      name: 'イベント限定'
      types: ['festival', 'demon', 'score', 'other']
      details:
        'festival': 'フェス'
        'demon': '魔神戦'
        'score': '戦の年代記'
        'other': 'その他'
    collaboration:
      name: 'コラボ限定'
      types: ['shiningblade', 'maoyu', 'trefle', 'mediafactory',
        'loghorizon', 'bakidou', 'atelier-twilight', 'monokuma',
        'falcom-sen2', 'other']
      details:
        'shiningblade': 'シャイニング・ブレイド'
        'maoyu': 'まおゆう'
        'trefle': 'Trefle'
        'mediafactory': 'メディアファクトリー'
        'loghorizon': 'ログ・ホライズン'
        'bakidou': '刃牙道'
        'atelier-twilight': 'アトリエ・黄昏シリーズ'
        'monokuma': '絶対絶望少女'
        'falcom-sen2': '閃の軌跡II'
        'other': 'その他'

  constructor: (data) ->
    @name = data.name
    @title = data.title
    @rarity = data.rarity
    @cost = data.cost
    @chainCost = data.chain_cost
    @jobType = data.job_type
    @jobIndex = data.job_index
    @jobCode = data.job_code
    @jobName = JOB_NAME[@jobType]
    @jobNameShort = JOB_NAME_SHORT[@jobType]
    @rarityStars = '★★★★★★'.slice(0, @rarity)
    @jobClass = CLASS_NAME[@jobType]
    @weaponType = data.weapon_type
    @weaponName = WEAPON_NAME[@weaponType]
    @voiceActor = data.voice_actor
    @voiceActor = '？' if @voiceActor == ''
    @illustrator = data.illustrator
    @illustrator = '？' if @illustrator == ''
    @union = data.union
    @sourceCategory = data.source_category
    @source = data.source
    @jobDetail = data.job_detail
    @maxAtk = (data.max_atk || '-')
    @maxHp = (data.max_hp || '-')
    @limitAtk = (data.limit_atk || '-')
    @limitHp = (data.limit_hp || '-')

    @skill = new Skill(data.skill)
    @firstAbility = new Ability(data.first_ability)
    @secondAbility = new Ability(data.second_ability)
    @chainAbility = new Ability(data.chain_ability)

  @jobNameFor = (j) -> JOB_NAME[j]
  @jobShortNameFor = (j) -> JOB_NAME_SHORT[j]
  @weaponNameFor = (w) -> WEAPON_NAME[w]
  @unionNameFor = (u) -> UNION_TYPE[u]
  @unions = -> UNION_TYPE
  @sourceCategoryNameFor = (c) -> SOURCE_TABLE[c]?.name || ''
  @sourceTypesFor = (c) -> SOURCE_TABLE[c]?.types || []
  @sourceNameFor = (c, s) -> SOURCE_TABLE[c]?.details?[s] || ''

class Member

  constructor: (a) ->
    @arcana = a
    @chainArcana = null

  chainedCost: ->
    c = @arcana.cost
    return c unless @chainArcana
    (c + @chainArcana.chainCost)

  canUseChainAbility: ->
    return false unless @chainArcana
    return false unless @arcana.jobType == @chainArcana.jobType
    return false if @arcana.name == @chainArcana.name
    true

  @canUseChainAbility = (a, b) ->
    return false unless (a && b)
    aa = a.arcana
    ba = b.arcana
    return false unless aa.jobType == ba.jobType
    return false if aa.name == ba.name
    true

class Arcanas

  arcanas = {}
  resultCache = {}

  constructor: () ->

  createQueryKey = (query) ->
    key = ""
    key += "recently_" if query.recently
    key += "j#{query.job}_" if query.job
    key += "r#{query.rarity}_" if query.rarity
    if query.sourcecategory
      key += "soc#{query.sourcecategory}_"
      key += "so#{query.source}_" if query.source
    key += "w#{query.weapon}_" if query.weapon
    key += "u#{query.union}_" if query.union
    if query.skill || query.skillcost
      key += "sk#{query.skill}_" if query.skill
      key += "skco#{query.skillcost}_" if query.skillcost
      key += "subsk#{query.skillsub}_" if query.skillsub
      key += "subef#{query.skilleffect}_" if query.skilleffect
    key += "a#{query.actor}_" if query.actor
    key += "i#{query.illustrator}_" if query.illustrator
    key += "abc#{query.abilitycond}_" if query.abilitycond
    key += "abe#{query.abilityeffect}_" if query.abilityeffect
    key += "cabc#{query.chainabilitycond}_" if query.chainabilitycond
    key += "cabe#{query.chainabilityeffect}_" if query.chainabilityeffect
    key += "arco#{query.arcanacost}_" if query.arcanacost
    key += "chco#{query.chaincost}_" if query.chaincost
    key

  search: (query, url, callbacks) ->
    key = createQueryKey(query)
    cached = resultCache[key]
    if cached
      as = (new Member(arcanas[code]) for code in cached)
      callbacks.done(as)
      return

    xhr = $.getJSON url, query
    xhr.done (datas) ->
      as = []
      for data in datas
        a = new Arcana(data)
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as.push (new Member(a))
      cs = (a.arcana.jobCode for a in as)
      resultCache[key] = cs
      callbacks.done(as)
    xhr.fail ->
      callbacks.fail()

  searchMembers: (query, url, callbacks) ->
    xhr = $.getJSON url, query
    xhr.done (datas) ->
      as = {}
      for mem, data of datas
        continue unless data
        a = new Arcana(data)
        continue unless a
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as[mem] = new Member(a)
      callbacks.done(as)
    xhr.fail ->
      callbacks.fail()

  searchCodes: (query, url, callbacks) ->
    xhr = $.getJSON url, query
    xhr.done (datas) ->
      as = []
      for data in datas
        a = new Arcana(data)
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as.push new Member(a)
      callbacks.done(as)
    xhr.fail ->
      callbacks.fail()

  forCode: (code) ->
    a = arcanas[code]
    return unless a
    (new Member(a))

class Cookie

  $.cookie.json = true;
  cookieKey = 'ccpts'
  expireDate = 7

  @set = (data) ->
    d = $.extend(@get(), (data || {}));
    $.cookie(cookieKey, d, {expires: expireDate})

  @get = ->
    $.cookie(cookieKey) || {}

  @clear = ->
    $.removeCookie(cookieKey)

  @replace = (data) ->
    $.cookie(cookieKey, (data || {}), {expires: expireDate})

  @delete = (key) ->
    c = @get()
    delete c[key]
    @replace(c)

  @valueFor = (key) ->
    c = @get()
    c[key]

class Pager

  defaultPageSize = 8

  constructor: (list, psize) ->
    @all = list || []
    @size = @all.length
    @pageSize = (psize || defaultPageSize)
    @maxPage = if @size > 0
      Math.ceil(list.length / @pageSize)
    else
      1
    @page = 1

  head: ->
    (@page - 1) * @pageSize

  tail: ->
    t = (@page * @pageSize) - 1
    if t >= @all.length
      t = @all.length - 1
    t

  get: ->
    h = @head()
    t = @tail()
    @all[h .. t]

  nextPage: ->
    @page += 1
    if @page > @maxPage
      @page = @maxPage
    @page

  prevPage: ->
    @page -= 1
    if @page < 0
      @page = 1
    @page

  hasNextPage: ->
    if @page < @maxPage then true else false

  hasPrevPage: ->
    if @page > 1 then true else false

  jumpPage: (p) ->
    @page = parseInt(p)
    if @page > @maxPage
      @page = @maxPage
    if @page < 0
      @page = 1
    @page

class Viewer

  members = {}
  arcanas = new Arcanas()
  memberKeys = ['mem1', 'mem2', 'mem3', 'mem4', 'sub1', 'sub2', 'friend']
  pager = null
  pagerSize = null
  onEdit = true
  defaultMemberCode = 'V2F82F85K51NA38NP28NP24NNNNN'
  usedList = []
  usedListSizeMax = 24
  mode = null

  constructor: ->
    mode = $("#mode").val()

    if mode == 'database'
      initDatabaseHandler()
      searchRecentlyTargets()
      pagerSize = (if isPhoneDevice() then 10 else 25)
    else
      pagerSize = 8
      initEditHandler()

      ptm = $("#ptm").val() || ''
      toggleEditMode() unless ptm is ''

      if isPhoneDevice()
        if ptm is ''
          # TODO redirect to DB mode
          toggleEditMode()
          buildMembersArea(defaultMemberCode)
        else
          buildMembersArea(ptm)
      else
        initUsedArcana()
        searchRecentlyTargets()
        ptm = defaultMemberCode if ptm is ''
        buildMembersArea(ptm)

  isPhoneDevice = ->
    if window.innerWidth < 768 then true else false

  createPager = (list, size) ->
    s = size || pagerSize
    new Pager(list, s)

  eachMemberKey = (func) ->
    for m in memberKeys
      func(m)

  eachMember = (func) ->
    eachMemberKey (k) ->
      func(members[k])

  eachMemberOnly = (func) ->
    eachMemberKey (k) ->
      func(members[k]) unless k == 'friend'

  memberFor = (k) ->
    members[k]

  setMember = (k, a) ->
    members[k] = a

  removeMember = (k) ->
    members[k] = null

  memberAreaFor = (m) ->
    $("#member-character-#{m}")

  memberKeyFromArea = (div) ->
    div.attr('id').replace('member-character-', '')

  renderArcanaCost = (m, cl) ->
    render = "#{m.arcana.cost}"
    if m.chainArcana
      render += " + #{m.chainArcana.chainCost}"
    else if cl == 'choice' || cl == 'detail' || cl == 'table'
      render += " ( #{m.arcana.chainCost} )"
    render

  renderChainAbility = (m, cl) ->
    return '' unless m

    if cl == 'member' || cl == 'chain' || cl == 'full'
      c = m.chainArcana
      if c
        render = ''
        render += if cl == 'member'
          "
            <button type='button' class='close close-chain'>&times;</button>
            <a href='#' data-job-code='#{c.jobCode}' data-toggle='modal' data-target='#view-modal'>#{c.name}</a>
          "
        else if cl == 'full'
          "<a href='#' data-job-code='#{c.jobCode}' data-toggle='modal' data-target='#view-modal'>#{c.name}</a>"
        else
          "<span class='chained-ability'>#{c.name}</span>"
        render += ' / '
        render += if m.canUseChainAbility()
          "<span class='chained-ability'>#{c.chainAbility.name}</span>"
        else
          "<s>#{c.chainAbility.name}</s>"
        render
      else
        "（#{m.arcana.chainAbility.name}）"
    else
      m.arcana.chainAbility.name

  renderSkill = (sk) ->
    render = "
    #{sk.name} (#{sk.cost})<br>
    <ul class='small list-unstyled ability-detail'>"
    for ef, i in sk.effects
      render += "<li>#{if i > 0 then '=> ' else '' }#{Skill.typeNameFor(ef.category)} - #{Skill.subnameFor(ef.category, ef.subcategory)}"
      if Skill.subeffectForEffect(ef).length > 0
        li = []
        for e in Skill.subeffectForEffect(ef)
          li.push Skill.effectNameFor(ef.category, e)
        render += " ( + #{li.join(' / ')} )"
      render += '</li>'
    render += "</ul>"
    render

  renderAbility = (ab) ->
    return "なし" if ab.name == ''

    render = "#{ab.name}<ul class='small list-unstyled ability-detail'>"
    for e in ab.effects
      render += "<li>#{Ability.conditionNameFor(e.conditionType)} - #{Ability.effectNameFor(e.effectType)}</li>"
    render += "</ul>"
    render

  renderFullSizeArcana = (m) ->
    if m
      a = m.arcana

      "
        <div class='#{a.jobClass} full-size arcana' data-job-code='#{a.jobCode}'>
          <div class='#{a.jobClass}-title arcana-title small'>
            #{a.jobNameShort} : #{a.rarityStars}
            <span class='badge pull-right'>#{renderArcanaCost(m)}</span>
          </div>
          <div class='arcana-body'>
            <p class='arcana-name'>
                <button type='button' class='btn btn-default btn-xs view-info pull-right' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>Info</button>
                <span class='text-muted small'>#{a.title}</span><br>
                <strong>#{a.name}</strong>
            </p>
            <dl class='small text-muted arcana-detail'>
              <dt>ATK / HP</dt>
              <dd> #{a.maxAtk} (#{a.limitAtk}) / #{a.maxHp} (#{a.limitHp})</dd>
              <dt>Skill</dt>
              <dd>#{a.skill.name} (#{a.skill.cost})</dd>
              <dt>Ability</dt>
              <dd>
                <ul class='list-unstyled'>
                  <li>#{if a.firstAbility.name != '' then a.firstAbility.name else 'なし'}</li>
                  <li>#{if a.secondAbility.name != '' then a.secondAbility.name else 'なし'}</li>
                </ul>
              </dd>
              <dt class='chain-ability-name'>ChainAbility</dt>
              <dd class='small'>#{renderChainAbility(m, 'full')}</dd>
            </dl>
          </div>
          <div class='#{a.jobClass}-footer arcana-footer'>
          </div>
        </div>
      "
    else
      "<div class='none full-size arcana'></div>"

  renderSummarySizeArcana = (m, cl) ->
    if m
      a = m.arcana

      div = "
        <div class='#{a.jobClass} #{cl} summary-size arcana' data-job-code='#{a.jobCode}'>
          <div class='#{a.jobClass}-title arcana-title small'>
            #{a.jobNameShort}:#{a.rarityStars} <span class='badge badge-sm pull-right'>#{renderArcanaCost(m, cl)}</span>
          </div>
          <div class='arcana-summary'>
            <p>
              <small>
                <button type='button' class='btn btn-default btn-xs view-info pull-right' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>Info</button>
                <span class='text-muted small'>#{a.title}</span><br>
                <strong>#{a.name}</strong>
              </small>
            </p>
            <p>
              <small>
                <ul class='small text-muted list-unstyled summary-detail'>
                  <li>#{a.maxAtk} / #{a.maxHp}</li>
                  <li>#{a.skill.name} (#{a.skill.cost})</li>
                  <li>#{if a.firstAbility.name != '' then a.firstAbility.name else 'なし'}<br>#{if a.secondAbility.name != '' then a.secondAbility.name else 'なし'}</li>
                  <li class='chain-ability-name'>#{renderChainAbility(m, cl)}</li>
                </ul>
              </small>
            </p>
          </div>
      "
      if cl == 'member'
        div += '<button type="button" class="close close-member" aria-hidden="true">&times;</button>'
      div += '</div>'
      div
      return div if cl == 'chain'

      d = $(div)
      d.draggable(
        connectToSortable: false
        containment: false
        helper: 'clone'
        opacity: 0.7
        zIndex: 10000
        start: ->
          $("#search-area").hide()
          $("#help-area").show()
        stop: ->
          $("#search-area").show()
          $("#help-area").hide()
      )
    else
      d = $("<div class='none #{cl} summary-size arcana'></div>")
    d

  renderSummarySizeMember = (m) ->
    renderSummarySizeArcana(m, 'member')

  renderArcanaDetail = (m) ->
    return '' unless m
    a = m.arcana

    "
      <div class='#{a.jobClass} arcana'>
        <div class='#{a.jobClass}-title arcana-title'>
          #{a.jobName} : #{a.rarityStars}
          <span class='badge pull-right'>#{renderArcanaCost(m, 'detail')}</span>
        </div>
        <div class='arcana-view-body'>
          <h4 class='arcana-name' id='view-modal-label'>
            <span class='text-muted'>#{a.title}</span>
            <strong>#{a.name}</strong>
          </h4>
          <div class='row'>
            <div class='col-xs-12 col-sm-4 col-md-4'>
              <dl class='small arcana-view-detail'>
                <dt>職業</dt>
                <dd>#{a.jobDetail}</dd>
                <dt>ATK / HP</dt>
                <dd> #{a.maxAtk} / #{a.maxHp}<br>( #{a.limitAtk} / #{a.limitHp} )</dd>
                <dt>武器タイプ</dt>
                <dd>#{a.weaponName}</dd>
                <dt>所属</dt>
                <dd>#{Arcana.unionNameFor(a.union)}</dd>
                <dt>声優</dt>
                <dd>#{a.voiceActor}</dd>
                <dt>イラストレーター</dt>
                <dd>#{a.illustrator}</dd>
                <dt>入手先</dt>
                <dd>#{Arcana.sourceCategoryNameFor(a.sourceCategory)} - #{Arcana.sourceNameFor(a.sourceCategory, a.source)}</dd>
              </dl>
            </div>
            <div class='col-xs-12 col-sm-8 col-md-8'>
              <dl class='small arcana-view-detail'>
                <dt>スキル</dt>
                <dd>#{renderSkill(a.skill)}</dd>
                <dt>アビリティ1</dt>
                <dd>#{renderAbility(a.firstAbility)}</dd>
                <dt>アビリティ2</dt>
                <dd>#{renderAbility(a.secondAbility)}</dd>
                <dt>絆アビリティ</dt>
                <dd>#{renderAbility(a.chainAbility)}</dd>
              </dl>
            </div>
          </div>
        </div>
      </div>
    "

  renderTableHeader = ->
    tr = "
      <tr>
        <th><br></th>
        <th>職</th>
        <th>★</th>
    "
    unless isPhoneDevice()
      tr += "
        <th>コスト</th>
        <th>武器</th>
        <th>最大ATK</th>
        <th>最大HP</th>
        <th>限界ATK</th>
        <th>限界HP</th>
        <th>所属</th>
      "
    tr += "</tr>"
    tr

  renderTableArcana = (m) ->
    return unless m
    a = m.arcana

    tr = "
      <tr>
        <td class='arcana-header '>
          <div class='#{a.jobClass}'>
    "
    if isPhoneDevice()
      tr += "<span class='badge badge-sm pull-right'>#{renderArcanaCost(m, 'table')}</span>"
    tr += "
            <span class='text-muted small'>#{a.title}</span><br>
            <a href='#' class='view-info' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>#{a.name}</button>
          </div>
        </td>
        <td>#{a.jobNameShort}</td>
        <td>★#{a.rarity}</td>
    "
    unless isPhoneDevice()
      tr += "
        <td>#{renderArcanaCost(m, 'table')}</td>
        <td>#{a.weaponName}</td>
        <td>#{a.maxAtk}</td>
        <td>#{a.maxHp}</td>
        <td>#{a.limitAtk}</td>
        <td>#{a.limitHp}</td>
        <td>#{Arcana.unionNameFor(a.union)}</td>
      "
    tr += "</tr>"
    tr

  renderPager = ->
    pager ||= createPager([])
    prev = $('#pager-prev')
    next = $('#pager-next')
    $('.each-page').remove()

    if pager.hasPrevPage()
      prev.removeClass('disabled')
    else
      prev.addClass('disabled')

    if isPhoneDevice()
      $('#pagination-area').addClass('pagination-sm')
      body = 3
      edge = 1
    else
      body = 5
      edge = 2

    list = if pager.maxPage <= (body + edge * 2 + 2)
      [1 .. pager.maxPage]
    else
      switch
        when pager.page <= (edge + (body+1)/2)
          li = [1 .. (body + edge)]
          li.push '..'
          li = li.concat [(pager.maxPage - edge + 1) .. pager.maxPage]
          li
        when pager.page >= (pager.maxPage - (edge + (body+1)/2) + 1)
          li = [1 .. edge]
          li.push '..'
          li = li.concat [(pager.maxPage-(body + edge)+1) .. pager.maxPage]
          li
        else
          li = [1 .. edge]
          li.push '..'
          li = li.concat [(pager.page - edge) .. (pager.page + edge)]
          li.push '..'
          li = li.concat [(pager.maxPage - edge + 1) .. pager.maxPage]
          li

    for p in list
      pa = $("<li><span class='each-page' data-page='#{p}'>#{p}</span></li>")
      if p is '..'
        pa.addClass('disable')
      else if p == pager.page
        pa.addClass('active')
      else
        pa.hammer().on 'tap', (e) ->
          page = $(e.target).children('span').data('page')
          pager?.jumpPage(page)
          replaceTargetArea()
      next.before(pa)

    if pager.hasNextPage()
      next.removeClass('disabled')
    else
      next.addClass('disabled')

    count = $('#pager-count')
    count.empty()
    if pager.size > 0
      count.append("（#{pager.head() + 1} - #{pager.tail() + 1} / #{pager.size}件）")
    @

  renderMemberArcana = (div, ra) ->
    div.empty()
    a = $(ra)
    a.hide()
    div.append(a)
    a.attr('data-parent-key', memberKeyFromArea(div))
    a.fadeIn()

  reloadMemberAreas = ->
    eachMemberKey (k) ->
      div = memberAreaFor(k)
      m = memberFor(k)
      if onEdit
        renderMemberArcana(div, renderSummarySizeMember(m))
      else
        renderMemberArcana(div, renderFullSizeArcana(m))

  replaceTargetArea = ->
    if mode == 'database'
      replaceTableArea()
    else
      replaceChoiceArea()

  replaceChoiceArea = ->
    as = pager?.get() || []
    ul = $('#choice-characters')
    ul.empty()
    for a in as
      li = $("<li class='listed-character col-sm-3 col-md-3 col-xs-6'></li>")
      li.html(renderSummarySizeArcana(a, 'choice'))
      li.hide()
      ul.append(li)
      li.fadeIn('slow')
    renderPager()
    @

  replaceTableArea = ->
    as = pager?.get() || []
    tbody = $('#table-body')
    tbody.empty()
    tbody.append(renderTableHeader())

    for a in as
      tr = renderTableArcana(a)
      tbody.append(tr)
    renderPager()
    @

  searchArcanas = (query, path, callback) ->
    $("#error").hide()
    $("#loading-modal").modal('show')
    query ?= {}
    query.ver = $("#data-ver").val()
    url = $("#app-path").val() + path
    callbacks =
      done: (as) ->
        callback(as)
        $("#loading-modal").modal('hide')
      fail: ->
        $("#loading-modal").modal('hide')
        $("#error-area").show()

    if path == 'ptm'
      arcanas.searchMembers(query, url, callbacks)
    else if path == 'codes'
      arcanas.searchCodes(query, url, callbacks)
    else
      arcanas.search(query, url, callbacks)

  buildMembersArea = (ptm) ->
    query = ptm: ptm
    searchArcanas query, 'ptm', (as) ->
      eachMemberKey (k) ->
        mb = as[k]
        mc = as[k + 'c']
        if mb && mc
          mb.chainArcana = mc.arcana
        setMember(k, mb)
        render = if onEdit
          renderSummarySizeMember(mb)
        else
          renderFullSizeArcana(mb)
        renderMemberArcana memberAreaFor(k), render
      calcCost()

  searchMembersFromCode = (ptm) ->
    query = ptm: ptm
    searchArcanas query, 'ptm', (as) ->
      list = []
      codes = {}
      eachMemberKey (k) ->
        mb = as[k]
        if mb && !codes[mb.arcana.jobCode]
          list.push mb
          codes[mb.arcana.jobCode] = mb

        mc = as[k + 'c']
        if mc && !codes[mc.arcana.jobCode]
          list.push mc
          codes[mc.arcana.jobCode] = mc

      pager = createPager(list)
      replaceChoiceArea()

  resetQuery = ->
    $("#job").val('')
    $("#rarity").val('')
    $("#weapon").val('')
    $("#actor").val('')
    $("#illustrator").val('')
    $("#union").val('')
    $("#source-category").val('')
    $("#source").empty().append("<option value=''>-</option>")
    $("#skill").val('')
    $("#skill-cost").val('')
    $("#skill-sub").empty().append("<option value=''>-</option>")
    $("#skill-effect").empty().append("<option value=''>-</option>")
    $("#ability-effect").val('')
    $("#ability-condition").empty().append("<option value=''>-</option>")
    $("#chain-ability-effect").val('')
    $("#chain-ability-condition").empty().append("<option value=''>-</option>")
    $("#arcana-cost").val('')
    $("#chain-cost").val('')

    $("#additional-condition").hide()
    $("#skill-add").hide()
    $("#add-condition").show()
    @

  buildQuery = ->
    job = $("#job").val()
    rarity = $("#rarity").val()
    weapon = $("#weapon").val()
    actor = $("#actor").val()
    illst = $("#illustrator").val()
    union = $("#union").val()
    sourcecategory = $("#source-category").val()
    source = $("#source").val()
    skill = $("#skill").val()
    skillcost = $("#skill-cost").val()
    abilityCond = $("#ability-condition").val()
    abilityEffect = $("#ability-effect").val()
    chainAbilityCond = $("#chain-ability-condition").val()
    chainAbilityEffect = $("#chain-ability-effect").val()
    arcanacost = $("#arcana-cost").val()
    chaincost = $("#chain-cost").val()

    query = {}
    query.job = job unless job == ''
    query.rarity = rarity unless rarity == ''
    query.weapon = weapon unless weapon == ''
    query.actor = actor unless actor == ''
    query.illustrator = illst unless illst == ''
    query.union = union unless union == ''
    unless sourcecategory == ''
      query.sourcecategory = sourcecategory
      query.source = source unless source == ''
    query.abilitycond = abilityCond unless abilityCond == ''
    query.abilityeffect = abilityEffect unless abilityEffect == ''
    query.chainabilitycond = chainAbilityCond unless chainAbilityCond == ''
    query.chainabilityeffect = chainAbilityEffect unless chainAbilityEffect == ''
    query.arcanacost = arcanacost unless arcanacost == ''
    query.chaincost = chaincost unless chaincost == ''

    unless (skill == '' && skillcost == '')
      query.skill = skill unless skill == ''
      query.skillcost = skillcost unless skillcost == ''
      skillsub = $("#skill-sub").val()
      query.skillsub = skillsub unless skillsub == ''
      skilleffect = $("#skill-effect").val()
      query.skilleffect = skilleffect unless skilleffect == ''

    if Object.keys(query).length <= 0
      query.recently = true

    query

  createQueryDetail = (query) ->
    elem = []
    if query.recently
      elem.push '最新'
    if query.job
      elem.push Arcana.jobNameFor(query.job)
    if query.rarity
      elem.push "★#{query.rarity.replace(/U/, '以上')}"
    if query.arcanacost
      elem.push "コスト#{query.arcanacost.replace(/D/, '以下')}"
    if query.chaincost
      elem.push "絆コスト#{query.chaincost.replace(/D/, '以下')}"
    if query.union
      elem.push '所属 - ' + Arcana.unionNameFor(query.union)
    if query.weapon
      elem.push '武器タイプ - ' + Arcana.weaponNameFor(query.weapon)
    if query.skill || query.skillcost
      text = 'スキル - '
      text += Skill.typeNameFor(query.skill) if query.skill
      text += " マナ#{query.skillcost.replace(/D/, '以下')}" if query.skillcost
      if query.skillsub || query.skilleffect
        text += '（'
        ss = []
        ss.push Skill.subnameFor(query.skill, query.skillsub) if query.skillsub
        ss.push Skill.effectNameFor(query.skill, query.skilleffect) if query.skilleffect
        text += ss.join(' + ')
        text += '）'
      elem.push text
    if query.abilitycond || query.abilityeffect
      text = 'アビリティ - ' + Ability.conditionNameFor(query.abilitycond) + ' ' + Ability.effectNameFor(query.abilityeffect)
      elem.push text
    if query.chainabilitycond || query.chainabilityeffect
      text = '絆アビリティ - ' + Ability.conditionNameFor(query.chainabilitycond) + ' ' + Ability.effectNameFor(query.chainabilityeffect)
      elem.push text
    if query.sourcecategory
      text = '入手先 - ' + Arcana.sourceCategoryNameFor(query.sourcecategory)
      text += ' ' + Arcana.sourceNameFor(query.sourcecategory, query.source) if query.source
      elem.push text
    if query.actor
      elem.push '声優 - ' + $("#actor :selected").text()
    if query.illustrator
      elem.push 'イラスト - ' + $("#illustrator :selected").text()
    elem.join(' / ')

  searchTargets = (q) ->
    query = q || buildQuery()
    unless query
      $("#detail").text('')
      pager = createPager([])
      replaceTargetArea()
      return
    searchArcanas query, 'arcanas', (as) ->
      $("#detail").text(createQueryDetail(query))
      pager = createPager(as)
      replaceTargetArea()

  searchRecentlyTargets = ->
    searchTargets({recently: true})

  replaceChoiceAreaForUsed = ->
    as = []
    for c in usedList
      as.push arcanas.forCode(c)
    $("#detail").text('最近使ったアルカナ')
    pager = createPager(as)
    replaceChoiceArea()

  searchUsedArcanas = ->
    if usedList.length <= 0
      replaceChoiceAreaForUsed()
      return

    targets = []
    for c in usedList
      continue if arcanas.forCode(c)
      targets.push c

    if targets.length <= 0
      replaceChoiceAreaForUsed()
      return

    query = {'codes': targets.join('/')}
    searchArcanas query, 'codes', (as) ->
      replaceChoiceAreaForUsed()

  toggleEditMode = ->
    edit = $("#edit-area")
    member = $("#member-area")
    btn = $("#edit-members")
    title = $("#edit-title")

    if onEdit
      onEdit = false
      btn.text("編集する")
      member.removeClass("well well-sm")
      title.hide()
      edit.fadeOut()
    else
      onEdit = true
      btn.text("編集終了")
      member.addClass("well well-sm")
      title.show()
      edit.fadeIn()
    reloadMemberAreas()
    @

  clearMemberArcana = (key) ->
    removeMember(key)
    renderMemberArcana(memberAreaFor(key), renderSummarySizeMember(null))

  removeDuplicateMember = (target) ->
    name1 = target.arcana.name
    name2 = target.chainArcana?.name

    eachMemberKey (k) ->
      return if k == 'friend'
      m = memberFor(k)
      return unless m

      if m.arcana.name == name1 || (name2 && m.arcana.name == name2)
        clearMemberArcana(k)
        return

      return unless m.chainArcana
      if m.chainArcana.name == name1 || (name2 && m.chainArcana.name == name2)
        m.chainArcana = null
        setMemberArcana(k, m)
    @

  createMembersCode = ->
    header = 'V' + $("#pt-ver").val()
    code = ''
    eachMember (m) ->
      if m
        code += m.arcana.jobCode
        code += (if m.chainArcana then m.chainArcana.jobCode else 'N')
      else
        code += 'NN'
    if (/^N+$/).test(code) then '' else (header + code)

  calcCost = ->
    cost = 0
    eachMemberOnly (m) ->
      cost += m.chainedCost() if m
    $("#cost").text(cost)

  isFirstAccess = ->
    if Cookie.valueFor('tutorial') then false else true

  showTutorial = ->
    $("#tutorial").show()
    Cookie.set({tutorial: true})

  isShowLatestInfo = ->
    ver = $("#latest-info-ver").val()
    return true if ver == ''
    showed = Cookie.valueFor('latest-info')
    return false unless showed
    if ver == showed then true else false

  showLatestInfo = ->
    ver = $("#latest-info-ver").val()
    $("#latest-info").show()
    Cookie.set({'latest-info': ver})

  createUnionList = ->
    li = $('#union')
    li.empty()
    li.append("<option value=''>-</option>")

    for u, n of Arcana.unions()
      continue if u == 'unknown'
      li.append("<option value='#{u}'>#{n}</option>")
    @

  createSkillOptions = ->
    sub = $("#skill-sub")
    sub.empty()
    effect = $("#skill-effect")
    effect.empty()
    add = $("#skill-add")

    skill = $("#skill").val()
    if skill == ''
      sub.append("<option value=''>-</option>")
      effect.append("<option value=''>-</option>")
      add.hide()
      return

    subtypes = Skill.subtypesFor(skill)
    sub.append("<option value=''>（全て）</option>")
    for t in subtypes
      sub.append("<option value='#{t}'>#{Skill.subnameFor(skill, t)}</option>")

    effecttypes = Skill.effectTypesFor(skill)
    effect.append("<option value=''>（全て）</option>")
    for t in effecttypes
      effect.append("<option value='#{t}'>#{Skill.effectNameFor(skill, t)}</option>")

    add.show()
    @

  createSourceOptions = ->
    cate = $("#source-category").val()
    sources = $("#source")
    sources.empty()

    if cate == ''
      sources.append("<option value=''>-</option>")
      return

    types = Arcana.sourceTypesFor(cate)
    sources.append("<option value=''>（全て）</option>")
    for t in types
      sources.append("<option value='#{t}'>#{Arcana.sourceNameFor(cate, t)}</option>")
    @

  createArcanaDetail = (code) ->
    m = arcanas.forCode(code)
    view = $("#view-detail")
    view.empty()
    view.append(renderArcanaDetail(m))
    @

  createAbilityEffects = ->
    target = $("#ability-effect")
    target.empty()
    target.append("<option value=''>-</option>")
    for e in Ability.effects()
      target.append("<option value='#{e}'>#{Ability.effectNameFor(e)}</option>")
    @

  createChainAbilityEffects = ->
    target = $("#chain-ability-effect")
    target.empty()
    target.append("<option value=''>-</option>")
    for e in Ability.chainEffects()
      target.append("<option value='#{e}'>#{Ability.effectNameFor(e)}</option>")
    @

  createAbilityConditions = ->
    target = $("#ability-condition")
    target.empty()
    abi = $("#ability-effect").val()
    if abi == ''
      target.append("<option value=''>-</option>")
      return
    conds = Ability.conditionsFor(abi)
    target.append("<option value=''>（全て）</option>")
    for c in conds
      target.append("<option value='#{c}'>#{Ability.conditionNameFor(c)}</option>")
    @

  createChainAbilityConditions = ->
    target = $("#chain-ability-condition")
    target.empty()
    abi = $("#chain-ability-effect").val()
    if abi == ''
      target.append("<option value=''>-</option>")
      return
    conds = Ability.chainConditionsFor(abi)
    target.append("<option value=''>（全て）</option>")
    for c in conds
      target.append("<option value='#{c}'>#{Ability.conditionNameFor(c)}</option>")
    @

  prevTargetPage = ->
    if pager?.hasPrevPage()
      pager.prevPage()
      replaceTargetArea()
    @

  nextTargetPage = ->
    if pager?.hasNextPage()
      pager.nextPage()
      replaceTargetArea()
    @

  initUsedArcana = ->
    usedList = []
    list = Cookie.valueFor('used-arcana')
    return unless list
    try
      usedList = list.split('/')
    catch
      usedList = []
    @

  addUsedArcana = (code) ->
    return if (code in usedList)
    usedList.push code
    if usedList.length > usedListSizeMax
      usedList.shift()
    Cookie.set({'used-arcana': usedList.join('/')})
    @

  clearUsedArcana = ->
    usedList = []
    Cookie.delete('used-arcana')
    @

  storeLastMembers = ->
    code = createMembersCode()
    Cookie.set({'last-members': code})

  searchLastMembers = ->
    code = Cookie.valueFor('last-members') || ''
    if code == ''
      code = defaultMemberCode
    buildMembersArea(code)

  clearLastMembers = ->
    Cookie.delete('last-members')

  handleDropedArcana = (target, drag) ->
    code = drag.data('jobCode')
    key = memberKeyFromArea(target)
    org = memberFor(key)
    swapKey = drag.data('parentKey')
    return if key == swapKey

    d = arcanas.forCode(code)
    if (org && org.arcana.name != d.arcana.name)
      spr = $('#select-proposal-replace')
      spr.empty()
      spr.append(renderSummarySizeArcana(d, 'chain'))

      pc = new Member(org.arcana)
      pc.chainArcana = d.arcana
      rpc = renderSummarySizeArcana(pc, 'chain')

      spc = $('#select-proposal-chain')
      spc.empty()
      spc.append(rpc)

      st = $('#select-chain-status')
      if Member.canUseChainAbility(org, d)
        st.text('絆アビリティ使用可能')
        st.addClass('label-success')
        st.removeClass('label-danger')
      else
        st.text('絆アビリティ使用不可')
        st.removeClass('label-success')
        st.addClass('label-danger')

      us = $('#select-union-status')
      if org.arcana.union == d.arcana.union
        us.text('所属ボーナスあり')
        us.addClass('label-success')
        us.removeClass('label-warning')
      else
        us.text('所属ボーナスなし')
        us.removeClass('label-success')
        us.addClass('label-warning')

      $('#select-position-key').val(key)
      $('#select-swap-position-key').val(swapKey)
      $('#select-droped-code').val(code)
      $('#select-modal').modal('show')
    else
      replaceMemberArea(key, code, swapKey)
    addUsedArcana(code)
    @

  replaceMemberArea = (pos, code, swapPos) ->
    fromMember = (if (swapPos && swapPos != '') then true else false)
    m = arcanas.forCode(code)
    if fromMember
      m.chainArcana = (memberFor(swapPos)).chainArcana
    removeDuplicateMember(m) unless pos == 'friend'

    if (! fromMember) || pos == 'friend'
      setMemberArcana(pos, m)
      return

    setMemberArcana(swapPos, memberFor(pos))
    setMemberArcana(pos, m)
    @

  setMemberArcana = (key, m) ->
    setMember(key, m)
    renderMemberArcana(memberAreaFor(key), renderSummarySizeMember(m))
    calcCost()
    storeLastMembers()
    @

  commonHandler = ->
    $("#error-area").hide()
    $("#error-area").removeClass("invisible")
    $("#additional-condition").hide()
    $("#skill-add").hide()

    createUnionList()
    createAbilityEffects()
    createChainAbilityEffects()

    $("#search").hammer().on 'tap', (e) ->
      e.preventDefault()
      searchTargets()
      $("#search-modal").modal('hide')

    $("#search-clear").hammer().on 'tap', (e) ->
      e.preventDefault()
      resetQuery()

    $("#add-condition").hammer().on 'tap', (e) ->
      e.preventDefault()
      $("#add-condition").hide()
      $("#additional-condition").fadeIn('fast')

    $("#skill").on 'change', (e) ->
      e.preventDefault()
      createSkillOptions()

    $("#ability-effect").on 'change', (e) ->
      e.preventDefault()
      createAbilityConditions()

    $("#chain-ability-effect").on 'change', (e) ->
      e.preventDefault()
      createChainAbilityConditions()

    $("#source-category").on 'change', (e) ->
      e.preventDefault()
      createSourceOptions()

    $("#view-modal").on 'show.bs.modal', (e) ->
      code = $(e.relatedTarget).data('jobCode')
      createArcanaDetail(code)
      true # for modal

    $("#pager-prev").hammer().on 'tap', (e) ->
      e.preventDefault()
      prevTargetPage()

    $("#pager-next").hammer().on 'tap', (e) ->
      e.preventDefault()
      nextTargetPage()

    @

  initEditHandler = ->
    commonHandler()

    $("#tutorial").hide()
    $("#tutorial").removeClass("invisible")
    $("#help-area").hide()
    $("#help-area").removeClass("invisible")
    $("#help-text").hide()

    if isFirstAccess()
      showTutorial()
      $("#latest-info").hide()
    else
      if isShowLatestInfo()
        $("#latest-info").hide()
      else
        showLatestInfo()

    $(".member-character").droppable(
      drop: (e, ui) ->
        e.preventDefault()
        handleDropedArcana($(e.target), ui.draggable)
    )

    $("#edit-members").hammer().on 'tap', (e) ->
      e.preventDefault()
      toggleEditMode()

    $("#member-area").on 'click', 'button.close-member', (e) ->
      e.preventDefault()
      target = $(e.target).parents(".member-character")
      key = memberKeyFromArea(target)
      clearMemberArcana(key)
      calcCost()
      false

    $("#member-area").on 'click', 'button.close-chain', (e) ->
      e.preventDefault()
      target = $(e.target).parents(".member-character")
      key = memberKeyFromArea(target)
      mem = memberFor(key)
      if mem
        mem.chainArcana = null
        setMemberArcana(key, mem)
      false

    $("#share-modal").on 'show.bs.modal', (e) ->
      code = createMembersCode()
      url = $("#app-path").val() + code
      $("#ptm-code").val(url)

      twitterUrl = "https://twitter.com/intent/tweet"
      twitterUrl += "?text=#{encodeURIComponent('チェンクロパーティーシミュレーター ' + url)}"
      twitterUrl += "&hashtags=ccpts"
      $("#twitter-share").attr('href', twitterUrl)
      true # for modal

    $("#ptm-code").on 'click forcus', (e) ->
      $(e.target).select()
      e.preventDefault()

    $("#reset-members").hammer().on 'tap', (e) ->
      e.preventDefault()
      eachMemberKey (k) ->
        clearMemberArcana(k)
      $("#cost").text('0')

    $("#used-list").hammer().on 'tap', (e) ->
      e.preventDefault()
      searchUsedArcanas()

    $("#default-list").hammer().on 'tap', (e) ->
      e.preventDefault()
      searchRecentlyTargets()

    $("#last-members").hammer().on 'tap', (e) ->
      e.preventDefault()
      searchLastMembers()

    $("#clear-used").hammer().on 'tap', (e) ->
      e.preventDefault()
      if window.confirm('アルカナの使用履歴を消去します。よろしいですか？')
        clearUsedArcana()
        clearLastMembers()
        window.alert('アルカナの使用履歴を消去しました。')

    $("#select-btn-chain").hammer().on 'tap', (e) ->
      e.preventDefault()
      key = $('#select-position-key').val()
      code = $('#select-droped-code').val()
      mem = memberFor(key)
      if mem
        m = arcanas.forCode(code)
        mem.chainArcana = m.arcana
      removeDuplicateMember(mem) unless key == 'friend'
      setMemberArcana(key, mem)
      $('#select-modal').modal('hide')

    $("#select-btn-replace").hammer().on 'tap', (e) ->
      e.preventDefault()
      key = $('#select-position-key').val()
      swapKey = $('#select-swap-position-key').val()
      code = $('#select-droped-code').val()
      replaceMemberArea(key, code, swapKey)
      $('#select-modal').modal('hide')

    $("#help-text-btn").hammer().on 'tap', (e) ->
      e.preventDefault()
      $("#help-text").show()
      $("#help-text-btn").hide()

    @

  initDatabaseHandler = ->
    commonHandler()

    @

$ -> (new Viewer())
