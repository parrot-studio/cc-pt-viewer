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
        'freeze', 'curse', 'charge', 'shield_break', 'heal_all', 'pain']
      effectname:
        blind: '暗闇追加'
        charge: '溜め'
        curse: '呪い追加'
        down: 'ダウン追加'
        fire: '火属性'
        freeze: '凍結追加'
        heal_all: '全員を回復'
        ice: '氷属性'
        poison: '毒追加'
        push: '弾き飛ばし'
        shield_break: '盾破壊'
        slow: 'スロウ追加'
        pain: '自分もダメージ'
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
      types: ['ice', 'element', 'blind', 'freeze', 'slow', 'weaken', 'debuff', 'invincible']
      effectname:
        blind: '暗闇耐性'
        debuff: '状態異常耐性'
        element: '属性軽減'
        freeze: '凍結耐性'
        ice: '氷軽減'
        invincible: '無敵'
        slow: 'スロウ耐性'
        weaken: '衰弱耐性'
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
          subeffect3: e.subeffect3 || ''
        @effects.push d

  @subeffectForEffect: (ef) ->
    return [] unless ef
    ret = []
    ret.push(ef.subeffect1) unless ef.subeffect1 == ''
    ret.push(ef.subeffect2) unless ef.subeffect2 == ''
    ret.push(ef.subeffect3) unless ef.subeffect3 == ''
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
    in_head: '先頭にいる時'
    in_move: '移動中'
    in_pierce: '貫通した時'
    in_rear: '仲間より後ろにいる時'
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
    'in_head'
    'in_rear'
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
    atkup:
      name: '与えるダメージ上昇'
      conditions: ['any', 'hp_upto', 'hp_upto_more', 'hp_downto',
        'hp_downto_more', 'hp_full', 'attack', 'critical', 'in_combo', 'in_pierce',
        'guard', 'kill', 'killer', 'in_front', 'in_head', 'in_emeny_area',
        'others_skill', 'link', 'mana_charged', 'boss_wave', 'wave_start',
        'for_blind', 'for_slow', 'for_poison', 'for_down', 'for_curse', 'for_weaken',
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
    atkup_for_job_near:
      name: '特定の職で一番近い対象の与えるダメージ上昇'
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
      chains: []
    boost_skill:
      name: 'スキル効果上昇'
      conditions: []
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
      conditions: ['attack', 'wave_start']
      chains: []
    critup_all:
      name: '全員のクリティカル率上昇'
      conditions: []
    defdown:
      name: '受けるダメージ増加'
      conditions: ['any', 'kill', 'in_front', 'in_head', 'wave_start']
      chains: []
    defdown_all:
      name: '全員の受けるダメージ増加'
      conditions: []
      chains: []
    defup:
      name: '受けるダメージ軽減'
      conditions: ['any', 'hp_upto', 'hp_downto', 'hp_downto_more', 'in_combo',
        'guard', 'kill', 'killer', 'in_field', 'boss_wave', 'wave_start',
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
      conditions: ['wave_start', 'dropout_self']
      chains: []
    heal_self:
      name: '自身を回復'
      conditions: ['wave_start', 'cycle', 'in_rear', 'in_base_area',
        'others_skill', 'union', 'dropout_self']
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
      conditions: ['attack', 'skill', 'kill']
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
      conditions: ['any', 'mana_lost', 'others_skill', 'guard']
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
    'maxhpup'
    'atkup_for_job_best'
    'atkup_for_job_near'
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
    'critup_all'
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

  WIKI_URL = 'http://xn--eckfza0gxcvmna6c.gamerch.com/'

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

    @wikiName = (
      if @title is '（調査中）'
        ''
      else if @jobCode is 'F82'
        "主人公（第2部）"
      else
        "#{@title}#{@name}"
    )
    @wikiUrl = (
      if @wikiName is ''
        WIKI_URL
      else
        WIKI_URL + encodeURIComponent(@wikiName)
    )

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

  $.cookie.json = true
  cookieKey = 'ccpts'
  expireDate = 21

  @set = (data) ->
    d = $.extend(@get(), (data || {}))
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

  sort: (col, order) ->
    order ||= 'desc'
    @all.sort (am, bm) ->
      a = am.arcana
      b = bm.arcana
      return 0 if a.jobCode is b.jobCode

      av = a[col]
      av = 0 if av is '-'
      bv = b[col]
      bv = 0 if bv is '-'

      if av is bv
        0
      else if av < bv
        if order is 'desc' then 1 else -1
      else
        if order is 'desc' then -1 else 1
    @all

class Viewer

  members = {}
  arcanas = new Arcanas()
  memberKeys = ['mem1', 'mem2', 'mem3', 'mem4', 'sub1', 'sub2', 'friend']
  pager = null
  pagerSize = null
  onEdit = true
  recentlySize = 24
  defaultMemberCode = 'V2F82F85K51NA38NP28NP24NNNNN'
  mode = null
  lastQuery = null
  querys = []
  queryLogSize = 5
  favs = {}
  sortOrderDefault = {name: 'asc'}
  sortOrder = {}

  constructor: ->
    mode = $("#mode").val() || ''

    if mode is 'database'
      pagerSize = (if isPhoneDevice() then 8 else 16)
      recentlySize = (if isPhoneDevice() then 16 else 32)
      initDatabaseHandler()

      query = parseQuery()
      if Object.keys(query).length <= 0
        searchRecentlyTargets()
      else
        searchTargets(query)
        setConditions(query)
    else if mode is 'ptedit'
      pagerSize = 8
      initEditHandler()

      ptm = $("#ptm").val() || ''
      if isPhoneDevice()
        toggleEditMode()
      else
        toggleEditMode() unless ptm is ''
        searchRecentlyTargets()
      ptm = defaultMemberCode if ptm is ''
      buildMembersArea(ptm)
    else
      commonHandler()

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
      func(members[k]) unless k is 'friend'

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

  collectFavriteList = ->
    fl = []
    for code, state of favs
      fl.push code if state
    fl.sort()
    fl

  renderArcanaCost = (m, cl) ->
    render = "#{m.arcana.cost}"
    if m.chainArcana
      render += " + #{m.chainArcana.chainCost}"
    else if (cl is 'choice' || cl is 'detail' || cl is 'table')
      render += " ( #{m.arcana.chainCost} )"
    render

  renderChainAbility = (m, cl) ->
    return '' unless m

    if (cl is 'member' || cl is 'chain' || cl is 'full')
      c = m.chainArcana
      if c
        render = ''
        render += if cl is 'member'
          "
            <button type='button' class='close close-chain'>&times;</button>
            <a href='#' data-job-code='#{c.jobCode}' data-toggle='modal' data-target='#view-modal'>#{c.name}</a>
          "
        else if cl is 'full'
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
    return renderSummarySizeArcana(m, 'full') if isPhoneDevice()

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
      if cl is 'member'
        div += '<button type="button" class="close close-member" aria-hidden="true">&times;</button>'
      div += '</div>'
      div
      return div if (cl is 'chain' || cl is 'full')

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
            <div class='col-xs-12 hidden-sm hidden-md hidden-lg'>
              <p class='pull-right'>
                <input type='checkbox' class='fav' data-job-code='#{a.jobCode}'>
              </p>
            </div>
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
            <div class='col-xs-12 col-sm-12 col-md-12'>
              <p class='pull-left'>
                <button type='button' class='btn btn-default btn-sm wiki-link' data-job-code='#{a.jobCode}'>Wikiで確認</button>
              </p>
              <p class='pull-right hidden-xs'>
                <input type='checkbox' class='fav' data-job-code='#{a.jobCode}'>
              </p>
            </div>
          </div>
        </div>
      </div>
    "

  renderTableHeader = ->
    tr = "
      <tr>
        <th class='sortable' data-col-name='name'>名前
          <button class='btn btn-default btn-xs sortable' type='button'>
            <span class='glyphicon glyphicon-sort' aria-hidden='true'></span>
          </button>
        </th>
        <th>職</th>
        <th>★</th>
    "
    unless isPhoneDevice()
      tr += "
        <th class='sortable' data-col-name='cost'>コスト
          <button class='btn btn-default btn-xs sortable' type='button'>
            <span class='glyphicon glyphicon-sort' aria-hidden='true'></span>
          </button>
        </th>
        <th>武器</th>
        <th class='sortable' data-col-name='maxAtk'>最大ATK
          <button class='btn btn-default btn-xs sortable' type='button'>
            <span class='glyphicon glyphicon-sort' aria-hidden='true'></span>
          </button>
        </th>
        <th class='sortable' data-col-name='maxHp'>最大HP
          <button class='btn btn-default btn-xs sortable' type='button'>
            <span class='glyphicon glyphicon-sort' aria-hidden='true'></span>
          </button>
        </th>
        <th class='sortable' data-col-name='limitAtk'>限界ATK
          <button class='btn btn-default btn-xs sortable' type='button'>
            <span class='glyphicon glyphicon-sort' aria-hidden='true'></span>
          </button>
        </th>
        <th class='sortable' data-col-name='limitHp'>限界HP
          <button class='btn btn-default btn-xs sortable' type='button'>
            <span class='glyphicon glyphicon-sort' aria-hidden='true'></span>
          </button>
        </th>
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
    prev = $('.pager-prev')
    next = $('.pager-next')
    $('.each-page').remove()

    if pager.hasPrevPage()
      prev.removeClass('disabled')
    else
      prev.addClass('disabled')

    if isPhoneDevice()
      $('.pagination').addClass('pagination-sm')
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
      pa = $("<li class='each-page'><span data-page='#{p}'>#{p}</span></li>")
      if p is '..'
        pa.addClass('disable')
      else if p == pager.page
        pa.addClass('active')
      else
        pa.children('span').addClass('jump-page')
      next.before(pa)

    if pager.hasNextPage()
      next.removeClass('disabled')
    else
      next.addClass('disabled')

    count = $('.pager-count')
    count.empty()
    if pager.size > 0
      count.append("（#{pager.head() + 1} - #{pager.tail() + 1} / #{pager.size}件）")
    else
      count.append("（0件）")
    @

  renderMemberArcana = (div, ra) ->
    div.empty()
    a = $(ra)
    a.hide()
    div.append(a)
    a.attr('data-parent-key', memberKeyFromArea(div))
    a.fadeIn()

  renderOrderState = ->
    $(".sortable").map ->
      col = $(this)
      name = col.data('colName')
      order = sortOrder[name] || ''
      span = col.children('button').children('span')

      switch order
        when 'desc'
          span.removeClass('glyphicon-sort')
          span.removeClass('glyphicon-sort-by-attributes')
          span.addClass('glyphicon-sort-by-attributes-alt')
          span.addClass('active')
        when 'asc'
          span.removeClass('glyphicon-sort')
          span.removeClass('glyphicon-sort-by-attributes-alt')
          span.addClass('glyphicon-sort-by-attributes')
          span.addClass('active')
        else
          span.removeClass('glyphicon-sort-by-attributes-alt')
          span.removeClass('glyphicon-sort-by-attributes')
          span.removeClass('active')
          span.addClass('glyphicon-sort')

  reloadMemberAreas = ->
    eachMemberKey (k) ->
      div = memberAreaFor(k)
      m = memberFor(k)
      if onEdit
        renderMemberArcana(div, renderSummarySizeMember(m))
      else
        renderMemberArcana(div, renderFullSizeArcana(m))

  replaceTargetArea = ->
    if mode is 'database'
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
    renderOrderState()
    @

  replaceTargetAreaForFavorite = ->
    as = []
    for c in collectFavriteList()
      as.push arcanas.forCode(c)
    $(".search-detail").text('お気に入り')
    pager = createPager(as)
    replaceTargetArea()

  searchArcanas = (query, path, callback) ->
    $("#error-area").hide()
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

    switch path
      when 'ptm'
        arcanas.searchMembers(query, url, callbacks)
      when 'codes'
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
      query.recently = recentlySize

    query

  setConditions = (query) ->
    return unless query
    resetQuery()

    if query.job
      $("#job").val(query.job)
    if query.rarity
      $("#rarity").val(query.rarity)
    if query.weapon
      $("#weapon").val(query.weapon)
    if query.union
      $("#union").val(query.union)
    if query.arcanacost
      $("#arcana-cost").val(query.arcanacost)
    if query.chaincost
      $("#chain-cost").val(query.chaincost)

    add = false
    if query.actor
      $("#actor").val(query.actor)
      add = true
    if query.actorname
      id = getSelectboxValue(query.actorname)
      $("#actor").val(id)
      add = true
    if query.illustrator
      $("#illustrator").val(query.illustrator)
      add = true
    if query.illustratorname
      id = getSelectboxValue(query.illustratorname)
      $("#illustrator").val(id)
      add = true
    if query.sourcecategory
      add = true
      $("#source-category").val(query.sourcecategory)
      createSourceOptions()
      if query.source
        $("#source").val(query.source)
    if query.skillcost
      add = true
      $("#skill-cost").val(query.skillcost)
    if query.skill
      add = true
      $("#skill").val(query.skill)
      createSkillOptions()
      $("#skill-add").show()
      if query.skillsub
        $("#skill-sub").val(query.skillsub)
      if query.skilleffect
        $("#skill-effect").val(query.skilleffect)
    if query.abilityeffect
      add = true
      $("#ability-effect").val(query.abilityeffect)
      createAbilityConditions()
      if query.abilitycond
        $("#ability-condition").val(query.abilitycond)
    if query.chainabilityeffect
      add = true
      $("#chain-ability-effect").val(query.chainabilityeffect)
      createChainAbilityConditions()
      if query.chainabilitycond
        $("#chain-ability-condition").val(query.chainabilitycond)

    if add
      $("#additional-condition").show()
      $("#add-condition").hide()
    @

  parseQuery = (q) ->
    q ?= (location.search.replace(/(^\?)/,'') || '')
    return {} if q is ''

    ret = {}
    recently = false
    r = /\+/g
    for qs in q.split("&")
      [n, v] = qs.split("=")
      val = decodeURIComponent(v).replace(r, ' ')
      switch n
        when 'ver'
          continue
        when 'recently'
          recently = true
          break
        when 'illustratorname'
          ret['illustrator'] = getSelectboxValue('illustrator', val)
        when 'actorname'
          ret['actor'] = getSelectboxValue('actor', val)
        else
          ret[n] = val
    return {} if recently
    ret

  encodeQuery = (q) ->
    return {} unless q

    ret = {}
    recently = false
    for n, v of q
      switch n
        when 'ver'
          continue
        when 'recently'
          recently = true
          break
        when 'illustrator'
          ret['illustratorname'] = getSelectboxText('illustrator', v)
        when 'actor'
          ret['actorname'] = getSelectboxText('actor', v)
        else
          ret[n] = v
    return '' if recently
    $.param ret

  isQueryForRecently = (q) ->
    return false unless q
    if q.recently then true else false

  getSelectboxText = (sname, v) ->
    ret = null
    $("##{sname} option").each ->
      val = $(this).val()
      return unless val is v
      ret = $(this).text()
      false
    ret

  getSelectboxValue = (sname, v) ->
    ret = null
    $("##{sname} option").each ->
      text = $(this).text()
      return unless text is v
      ret = $(this).val()
      false
    ret

  createQueryDetail = (query) ->
    return '' unless query
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
      elem.push '声優 - ' + getSelectboxText('actor', query.actor)
    if query.illustrator
      elem.push 'イラスト - ' + getSelectboxText('illustrator', query.illustrator)
    elem.join(' / ')

  addQueryLog = (q) ->
    lastQuery = q
    return if isQueryForRecently(q)
    nl = [q]
    eq = encodeQuery(q)
    cs = [eq]
    for oq in querys
      break if nl.length == queryLogSize
      continue if (eq is encodeQuery(oq))
      nl.push oq
      cs.push encodeQuery(oq)
    querys = nl
    Cookie.set({'query-log': cs})
    q

  initQueryLog = ->
    querys = []
    try
      cs = Cookie.valueFor('query-log')
      return unless cs

      for c in cs
        q = parseQuery(c)
        querys.push(q) if q
      renderQueryLog()
    catch
      querys = []
    @

  clearQueryLog = ->
    lastQuery = null
    querys = []
    Cookie.delete('query-log')
    renderQueryLog()

  renderQueryLog = ->
    $(".search-log").remove()
    return if querys.length < 1

    base = $("#search-log-header")
    limit = if isPhoneDevice() then 20 else 30

    for i in [queryLogSize..1]
      q = querys[i-1]
      continue unless q
      detail = createQueryDetail(q)
      if detail.length > limit
        detail = detail.slice(0, limit-3) + '...'
      li = "<li><a data-target='#' data-order='#{i}' class='search-log'>#{detail}</a></li>"
      base.after(li)
    @

  searchTargets = (q) ->
    query = q || buildQuery()
    unless query
      $(".search-detail").text('')
      pager = createPager([])
      replaceTargetArea()
      return
    addQueryLog(query)
    renderQueryLog()
    searchArcanas query, 'arcanas', (as) ->
      $(".search-detail").text(createQueryDetail(query))
      pager = createPager(as)
      resetSortOrder()
      replaceTargetArea()

  searchRecentlyTargets = ->
    searchTargets({recently: recentlySize})

  searchFavoriteArcanas = ->
    fl = collectFavriteList()
    if fl.length <= 0
      replaceTargetAreaForFavorite()
      return

    targets = []
    for c in fl
      continue if arcanas.forCode(c)
      targets.push c

    if targets.length <= 0
      replaceTargetAreaForFavorite()
      return

    query = {'codes': targets.join('/')}
    searchArcanas query, 'codes', (as) ->
      replaceTargetAreaForFavorite()

  toggleEditMode = ->
    edit = $("#edit-area")
    member = $("#member-area")
    btnText = $("#edit-state")
    btnIcon = $("#edit-icon")
    title = $("#edit-title")

    if onEdit
      onEdit = false
      btnText.text("編集する")
      btnIcon.removeClass("glyphicon-check")
      btnIcon.addClass("glyphicon-edit")
      member.removeClass("well well-sm")
      title.hide()
      edit.fadeOut()
    else
      onEdit = true
      btnText.text("編集終了")
      btnIcon.removeClass("glyphicon-edit")
      btnIcon.addClass("glyphicon-check")
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
      return if k is 'friend'
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

  isShowTutorial = ->
    if Cookie.valueFor('tutorial') then false else true

  showTutorial = ->
    $("#tutorial").show()
    Cookie.set({tutorial: true})

  isShowLatestInfo = ->
    ver = $("#latest-info-ver").val()
    return false if ver == ''
    showed = Cookie.valueFor('latest-info')
    return true unless showed
    if ver == showed then false else true

  showLatestInfo = ->
    ver = $("#latest-info-ver").val()
    $("#latest-info").show()
    Cookie.set({'latest-info': ver})

  createUnionList = ->
    li = $('#union')
    li.empty()
    li.append("<option value=''>-</option>")

    for u, n of Arcana.unions()
      continue if u is 'unknown'
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

    $(".fav").bootstrapSwitch({
      state: favs[code]
      size: 'mini'
      onColor: 'success'
      labelText: 'お気に入り'
      onSwitchChange: (e, state) ->
        target = $(e.target)
        toggleFavoriteArcana(target.data('jobCode'), state)
    })
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

  toggleFavoriteArcana = (code, state) ->
    favs[code] = state
    storeFavoriteArcana()
    @

  initFavoriteArcana = ->
    favs = {}

    try
      list = Cookie.valueFor('fav-arcana')
      return unless list
      for code in list.split('/')
        favs[code] = true
    catch
      favs = {}
    @

  storeFavoriteArcana = ->
    fl = collectFavriteList()
    Cookie.set({'fav-arcana': fl.join('/')})
    @

  clearFavoriteArcana = ->
    favs = {}
    Cookie.delete('fav-arcana')
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
    @

  replaceMemberArea = (pos, code, swapPos) ->
    fromMember = (if (swapPos && swapPos != '') then true else false)
    m = arcanas.forCode(code)
    if fromMember
      m.chainArcana = (memberFor(swapPos)).chainArcana
    removeDuplicateMember(m) unless pos is 'friend'

    if (! fromMember) || pos is 'friend'
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

  resetSortOrder = ->
    sortOrder = {}
    @

  updateSortOrder = (col, order) ->
    resetSortOrder()
    sortOrder[col] = order
    @

  reverseOrder = (order) ->
    switch order
      when 'asc' then 'desc'
      when 'desc' then 'asc'
      else null

  sortTargets = (col, ord) ->
    order = ord || reverseOrder(sortOrder[col]) || sortOrderDefault[col] || 'desc'
    pager?.sort(col, order)
    replaceTargetArea()
    updateSortOrder(col, order)
    renderOrderState()
    @

  commonHandler = ->
    $("#error-area").hide()
    $("#error-area").removeClass("invisible")
    $("#topnav").hide()
    $("#topnav").removeClass("invisible")
    if isPhoneDevice()
      $("#ads").hide()
    else
      $("#topnav").show()

  searchHandler = ->
    commonHandler()

    $("#latest-info").hide()
    $("#latest-info").removeClass("invisible")
    $("#additional-condition").hide()
    $("#skill-add").hide()

    createUnionList()
    createAbilityEffects()
    createChainAbilityEffects()

    initFavoriteArcana()
    initQueryLog()

    $(".search").on 'click', (e) ->
      e.preventDefault()
      searchTargets()
      $("#search-modal").modal('hide')

    $(".search-clear").on 'click', (e) ->
      e.preventDefault()
      resetQuery()

    $("#add-condition").on 'click', (e) ->
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

    $(".pager-prev").on 'click', (e) ->
      e.preventDefault()
      prevTargetPage()

    $(".pager-next").on 'click', (e) ->
      e.preventDefault()
      nextTargetPage()

    $(".pagination").on 'click', 'span.jump-page', (e) ->
      e.preventDefault()
      page = $(e.target).data('page')
      pager?.jumpPage(page)
      replaceTargetArea()

    $("#default-list").on 'click', (e) ->
      e.preventDefault()
      searchRecentlyTargets()

    $("#clear-fav").on 'click', (e) ->
      e.preventDefault()
      if window.confirm('お気に入りを消去します。よろしいですか？')
        clearFavoriteArcana()
        window.alert('お気に入りを消去しました。')

    $("#clear-log").on 'click', (e) ->
      e.preventDefault()
      if window.confirm('検索履歴を消去します。よろしいですか？')
        clearQueryLog()
        window.alert('検索履歴を消去しました。')

    $("#clear-all").on 'click', (e) ->
      e.preventDefault()
      if window.confirm('全ての履歴（お気に入り/検索）を消去します。よろしいですか？')
        clearFavoriteArcana()
        clearLastMembers()
        clearQueryLog()
        window.alert('全ての履歴を消去しました。')

    $("#search-menu").on 'click', 'a.search-log', (e) ->
      e.preventDefault()
      n = parseInt($(e.target).data('order'))
      if n > 0
        query = querys[n-1]
        if query
          searchTargets(query)
          setConditions(query)

    $("#favorite-list").on 'click', (e) ->
      e.preventDefault()
      searchFavoriteArcanas()

    $("#view-modal").on 'click', 'button.wiki-link', (e) ->
      e.preventDefault()
      code = $(e.target).data('jobCode')
      m = arcanas.forCode(code)
      return false unless m

      a = m.arcana
      lt = if a.wikiName is ''
        "Wikiで最新情報を確認する"
      else
        "Wikiで #{a.wikiName} を確認する"

      $("#outside-link-text").text(lt)
      $("#outside-link").attr('href', a.wikiUrl)
      $("#outside-site-name").text("チェインクロニクル攻略・交流Wiki")

      $("#view-modal").modal('hide')
      $("#link-modal").modal('show')

    $("#outside-link").on 'click', (e) ->
      $("#link-modal").modal('hide')
      true

    $("#arcana-table").on 'click', 'th.sortable', (e) ->
      e.preventDefault()
      target = $(e.target)
      col = target.data('colName') || ''
      sortTargets(col) unless col is ''

    $("#arcana-table").on 'click', 'button.sortable', (e) ->
      target = $(e.target).parents('th')
      col = target.data('colName') || ''
      sortTargets(col) unless col is ''
      false

    @

  initEditHandler = ->
    searchHandler()

    $("#tutorial").hide()
    $("#tutorial").removeClass("invisible")
    $("#help-area").hide()
    $("#help-area").removeClass("invisible")
    $("#help-text").hide()

    if isShowTutorial()
      showTutorial()
    else if isShowLatestInfo()
      showLatestInfo()

    $(".member-character").droppable(
      drop: (e, ui) ->
        e.preventDefault()
        handleDropedArcana($(e.target), ui.draggable)
    )

    $("#edit-members").on 'click', (e) ->
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

    $("#share-ptm-modal").on 'show.bs.modal', (e) ->
      code = createMembersCode()
      url = $("#app-path").val() + code
      $("#ptm-code").val(url)

      twitterUrl = "https://twitter.com/intent/tweet"
      twitterUrl += "?text=#{encodeURIComponent('チェンクロ パーティーシミュレーター ' + url)}"
      twitterUrl += "&hashtags=ccpts"
      $("#twitter-share").attr('href', twitterUrl)
      true # for modal

    $("#ptm-code").on 'click forcus', (e) ->
      $(e.target).select()
      e.preventDefault()

    $("#reset-members").on 'click', (e) ->
      e.preventDefault()
      eachMemberKey (k) ->
        clearMemberArcana(k)
      $("#cost").text('0')

    $("#last-members").on 'click', (e) ->
      e.preventDefault()
      searchLastMembers()

    $("#select-btn-chain").on 'click', (e) ->
      e.preventDefault()
      key = $('#select-position-key').val()
      code = $('#select-droped-code').val()
      mem = memberFor(key)
      if mem
        m = arcanas.forCode(code)
        mem.chainArcana = m.arcana
      removeDuplicateMember(mem) unless key is 'friend'
      setMemberArcana(key, mem)
      $('#select-modal').modal('hide')

    $("#select-btn-replace").on 'click', (e) ->
      e.preventDefault()
      key = $('#select-position-key').val()
      swapKey = $('#select-swap-position-key').val()
      code = $('#select-droped-code').val()
      replaceMemberArea(key, code, swapKey)
      $('#select-modal').modal('hide')

    $("#help-text-btn").on 'click', (e) ->
      e.preventDefault()
      $("#help-text").show()
      $("#help-text-btn").hide()

    @

  initDatabaseHandler = ->
    searchHandler()

    # TODO remove ----------------------------
    $("#database-warning").hide()
    $("#database-warning").removeClass("invisible")

    unless Cookie.valueFor('database-warning')
      $("#database-warning").show()

    $("#database-warning").on 'close.bs.alert', (e) ->
      Cookie.set({'database-warning': true})
    # ----------------------------

    showLatestInfo() if isShowLatestInfo()

    $("#share-query-modal").on 'show.bs.modal', (e) ->
      query = lastQuery || {}
      qs = encodeQuery(query) || ''

      url = "#{$("#app-path").val()}db"
      url += "?#{qs}" unless qs is ''
      if isPhoneDevice()
        $("#share-url-form").hide()
      else
        $("#query-url").val(url)

      twitterUrl = "https://twitter.com/intent/tweet"
      twitterUrl += "?text=#{encodeURIComponent('チェンクロ パーティーシミュレーター ' + url)}"
      twitterUrl += "&hashtags=ccpts"
      $("#twitter-share").attr('href', twitterUrl)
      true # for modal

    $("#query-url").on 'click forcus', (e) ->
      $(e.target).select()
      e.preventDefault()

    if isPhoneDevice()
      $("#arcana-table").swipe (
        swipeLeft: (e) ->
          prevTargetPage()
          e.preventDefault()
        swipeRight: (e) ->
          nextTargetPage()
          e.preventDefault()
      )

    @

$ ->
  FastClick.attach(document.body)
  new Viewer()
