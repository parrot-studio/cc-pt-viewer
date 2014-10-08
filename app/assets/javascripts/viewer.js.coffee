class Skill

  SKILL_TABLE =
    attack:
      name: '攻撃'
      types: ['one/short', 'one/line', 'one/combo', 'one/dash', 'one/rear', 'one/jump',
        'range/line', 'range/dash', 'range/forward', 'range/self', 'range/explosion',
        'range/drop', 'range/jump', 'range/random', 'range/all']
      subname:
        'one/short': '単体・目前'
        'one/line': '単体・直線'
        'one/combo': '単体・連続'
        'one/dash': '単体・ダッシュ'
        'one/rear': '単体・最後列'
        'one/jump': '単体・ジャンプ'
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
        'debuff_blind', 'debuff_slow']
      effectname:
        blind: '暗闇耐性'
        debuff_blind: '暗闇付与'
        debuff_slow: 'スロウ付与'
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
      types: ['ice', 'element', 'blind', 'debuff', 'invincible']
      effectname:
        blind: '暗闇耐性'
        debuff: '状態異常耐性'
        element: '属性軽減'
        ice: '氷軽減'
        invincible: '無敵'
    obstacle:
      types: []
      effectname: {}

  constructor: (data) ->
    @name = data.name || '？'
    @category = data.category || ''
    @subcategory = data.subcategory || ''
    @explanation = data.explanation || ''
    @cost = data.cost || '？'
    @subeffect1 = data.subeffect1 || ''
    @subeffect2 = data.subeffect2 || ''

  hasEffect: ->
    return true unless @subeffect1 == ''
    return true unless @subeffect2 == ''
    false

  effects: ->
    ret = []
    ret.push(@subeffect1) unless @subeffect1 == ''
    ret.push(@subeffect2) unless @subeffect2 == ''
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
    critical: 'クリティカル時'
    cycle: '一定間隔で'
    dropout_member: '味方が脱落した時'
    dropout_self: '自身が脱落した時'
    for_blind: '敵が暗闇の時'
    for_curse: '敵が呪いの時'
    for_down: '敵がダウン中'
    for_poison: '敵が毒の時'
    for_slow: '敵がスロウの時'
    for_weaken: '敵が衰弱の時'
    heal: '回復時'
    hp_downto: 'HPが一定以下の時'
    hp_downto_more: 'HPがより低い時'
    hp_full: 'HPが満タンの時'
    hp_upto: 'HPが一定以上の時'
    hp_upto_more: 'HPがより高い時'
    in_combo: '攻撃を一定回数当てた時'
    in_debuff: '自分が状態異常時'
    in_field: '特定のフィールドで'
    in_move: '移動中'
    in_sub: 'サブパーティーにいる時'
    kill: '敵を倒した時'
    killer: '特定の敵に対して'
    mana_charged: 'マナが多いほど'
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
    'in_combo'
    'kill'
    'heal'
    'in_move'
    'killer'
    'mana_charged'
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
      conditions: ['hp_upto', 'hp_downto']
      chains: []
    atkup:
      name: '与えるダメージ上昇'
      conditions: ['any', 'hp_upto', 'hp_upto_more', 'hp_downto',
        'hp_downto_more', 'hp_full', 'attack', 'critical', 'skill', 'in_combo',
        'kill', 'killer', 'in_field', 'mana_charged', 'boss_wave', 'wave_start',
        'for_blind', 'for_slow', 'for_poison', 'for_down', 'for_curse',
        'for_weaken', 'in_debuff', 'dropout_member', 'union']
      chains: ['any', 'hp_upto', 'hp_downto', 'attack', 'critical', 'skill',
        'killer', 'in_field', 'boss_wave', 'for_blind', 'for_slow', 'for_poison',
        'for_down', 'for_curse', 'for_weaken', 'in_debuff', 'dropout_member']
    atkup_all:
      name: '全員の与えるダメージ上昇'
      conditions: ['any', 'in_sub', 'wave_start']
      chains: []
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
    critup:
      name: 'クリティカル率上昇'
      conditions: []
    defdown:
      name: '受けるダメージ増加'
      conditions: ['any', 'kill', 'wavestart']
      chains: []
    defup:
      name: '受けるダメージ軽減'
      conditions: ['any', 'hp_upto', 'hp_downto', 'kill', 'killer', 'in_field',
        'boss_wave', 'wave_start', 'for_slow', 'in_debuff',
        'dropout_member', 'union']
      chains: ['any', 'hp_upto', 'hp_downto', 'killer', 'in_field', 'boss_wave']
    defup_all:
      name: '全員のダメージ軽減'
      conditions: ['any', 'in_sub']
      chains: []
    delayoff:
      name: '攻撃間隔が早くなる'
      conditions: []
    down:
      name: 'ダウン付与'
      conditions: ['attack', 'critical', 'skill']
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
      conditions: ['wave_start', 'cycle']
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
    invisible:
      name: '見えなくなる（遠距離無効）'
      conditions: []
    mana_boost:
      name: 'スロットで複数マナが出やすい'
      conditions: []
    mana_charge:
      name: 'マナを持って開始'
      conditions: []
      chains: []
    mana_drop:
      name: 'マナを落とす'
      conditions: []
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
    slot_slow:
      name: 'マナスロットが遅くなる'
      conditions: []
    slow:
      name: 'スロウ付与'
      conditions: ['attack', 'critical', 'skill']
      chains: ['attack', 'critical']
    speedup:
      name: '移動速度上昇'
      conditions: ['any', 'hp_upto', 'hp_downto', 'hp_full', 'in_combo',
        'kill', 'in_field', 'boss_wave', 'wave_start']
      chains: ['any', 'hp_downto', 'in_field', 'boss_wave']
    speedup_all:
      name: '全員の移動速度上昇'
      conditions: ['any', 'wave_start']
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
    'defup'
    'guardup'
    'speedup'
    'critup'
    'registup'
    'delayoff'
    'maxhpup'
    'fire'
    'ice'
    'mana_drop'
    'pierce'
    'absorb'
    'combat'
    'invisible'
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
    'guard_undead'
    'atkup_all'
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
      types: ['forest-sea', 'dawnsea', 'other']
      details:
        'forest-sea': '海風の港・酒場'
        'dawnsea': '夜明けの大海・酒場'
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
        'loghorizon', 'bakidou', 'atelier-twilight', 'other']
      details:
        'shiningblade': 'シャイニング・ブレイド'
        'maoyu': 'まおゆう'
        'trefle': 'Trefle'
        'mediafactory': 'メディアファクトリー'
        'loghorizon': 'ログ・ホライズン'
        'bakidou': '刃牙道'
        'atelier-twilight': 'アトリエ・黄昏シリーズ'
        'other': 'その他'

  constructor: (data) ->
    @name = data.name
    @title = data.title
    @rarity = data.rarity
    @cost = data.cost
    @jobType = data.job_type
    @jobIndex = data.job_index
    @jobCode = data.job_code
    @jobName = JOB_NAME[@jobType]
    @jobNameShort = JOB_NAME_SHORT[@jobType]
    @rarityStars = '★★★★★★'.slice(0, @rarity)
    @jobClass = CLASS_NAME[@jobType]
    @hometown = data.hometown
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

    @chainArcana = null

  @jobNameFor = (j) -> JOB_NAME[j]
  @jobShortNameFor = (j) -> JOB_NAME_SHORT[j]
  @weaponNameFor = (w) -> WEAPON_NAME[w]
  @unionNameFor = (u) -> UNION_TYPE[u]
  @sourceCategoryNameFor = (c) -> SOURCE_TABLE[c]?.name || ''
  @sourceTypesFor = (c) -> SOURCE_TABLE[c]?.types || []
  @sourceNameFor = (c, s) -> SOURCE_TABLE[c]?.details?[s] || ''

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
    key

  search: (query, url, callbacks) ->
    key = createQueryKey(query)
    cached = resultCache[key]
    if cached
      as = (arcanas[code] for code in cached)
      callbacks.done(as)
      return

    xhr = $.getJSON url, query
    xhr.done (datas) ->
      as = []
      for data in datas
        a = new Arcana(data)
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as.push a
      cs = (a.jobCode for a in as)
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
        as[mem] = a
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
        as.push a
      callbacks.done(as)
    xhr.fail ->
      callbacks.fail()

  forCode: (code) -> arcanas[code]

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
  onEdit = false
  defaultMemberCode = 'V1F36K7A1P2P24NN'
  usedList = []
  usedListSizeMax = 16

  constructor: ->
    initUsedArcana()
    initHandler()
    initMembers()

  isPhoneDevice = ->
    if window.innerWidth < 768 then true else false

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

  renderFullSizeArcana = (a) ->
    if a
      "
        <div class='#{a.jobClass} full-size arcana' data-job-code='#{a.jobCode}'>
          <div class='#{a.jobClass}-title arcana-title small'>
            #{a.jobNameShort} : #{a.rarityStars}
            <span class='badge pull-right'>#{a.cost}</span>
          </div>
          <div class='arcana-body'>
            <p class='arcana-name'>
                <span class='text-muted small'>#{a.title}</span><br>
                <strong>#{a.name}</strong>
                <button type='button' class='btn btn-default btn-xs view-info pull-right' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>Info</button>
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
              <dd>#{renderChainAbirity(a, 'member')}</dd>
            </dl>
          </div>
          <div class='#{a.jobClass}-footer arcana-footer'>
          </div>
        </div>
      "
    else
      "<div class='none full-size arcana'></div>"

  renderChainAbirity = (a, cl) ->
    return '' unless a

    if cl == 'member'
      if a.chainArcana
        # TODO 絆アビリティ表示
      else
        "（#{a.chainAbility.name}）"
    else
      a.chainAbility.name

  renderSummarySizeArcana = (a, cl) ->
    if a
      div = "
        <div class='#{a.jobClass} #{cl} summary-size arcana' data-job-code='#{a.jobCode}'>
          <div class='#{a.jobClass}-title arcana-title small'>
            #{a.jobNameShort}:#{a.rarityStars} <span class='badge badge-sm pull-right'>#{a.cost}</span>
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
                  <li class='chain-ability-name'>#{renderChainAbirity(a, cl)}</li>
                </ul>
              </small>
            </p>
          </div>
      "
      if cl == 'member'
        div += '<button type="button" class="close close-member" aria-hidden="true">&times;</button>'
      div += '</div>'
      div

      d = $(div)
      d.draggable(
        connectToSortable: false
        containment: false
        helper: 'clone'
        opacity: 0.7
        zIndex: 10000
      )
    else
      d = $("<div class='none #{cl} summary-size arcana'></div>")
    d

  renderSummarySizeMember = (a) ->
    renderSummarySizeArcana(a, 'member')

  renderSkill = (sk) ->
    render = "
    #{sk.name} (#{sk.cost})<br>
    <ul class='small list-unstyled ability-detail'>
      <li>#{Skill.typeNameFor(sk.category)} - #{Skill.subnameFor(sk.category, sk.subcategory)}</li>"

    if sk.hasEffect()
      for e in sk.effects()
        render += "<li>+ #{Skill.effectNameFor(sk.category, e)}</li>"

    render += "</ul>"
    render

  renderAbility = (ab) ->
    return "なし" if ab.name == ''

    render = "#{ab.name}<ul class='small list-unstyled ability-detail'>"
    for e in ab.effects
      render += "<li>#{Ability.conditionNameFor(e.conditionType)} - #{Ability.effectNameFor(e.effectType)}</li>"
    render += "</ul>"
    render

  renderArcanaDetail = (a) ->
    return '' unless a

    "
      <div class='#{a.jobClass} arcana'>
        <div class='#{a.jobClass}-title arcana-title'>
          #{a.jobName} : #{a.rarityStars}
          <span class='badge pull-right'>#{a.cost}</span>
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

  renderPager = ->
    pager ||= new Pager([])
    prev = $('#pager-prev')
    next = $('#pager-next')
    $('.each-page').remove()

    if pager.hasPrevPage()
      prev.removeClass('disabled')
    else
      prev.addClass('disabled')

    for p in [1 .. pager.maxPage]
      pa = $("<li><span class='each-page' data-page='#{p}'>#{p}</span></li>")
      if p == pager.page
        pa.addClass('active')
      else
        pa.hammer().on 'tap', (e) ->
          page = $(e.target).children('span').data('page')
          pager?.jumpPage(page)
          replaceChoiceArea()
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

  replaceMemberArcana = (div, ra) ->
    div.empty()
    a = $(ra)
    a.hide()
    div.append(a)
    a.attr('data-parent-key', memberKeyFromArea(div))
    a.fadeIn()

  replaceMemberArea = ->
    eachMemberKey (k) ->
      div = memberAreaFor(k)
      a = memberFor(k)
      if onEdit
        replaceMemberArcana(div, renderSummarySizeMember(a))
      else
        replaceMemberArcana(div, renderFullSizeArcana(a))

  replaceChoiceArea = ->
    as = pager?.get() || []
    ul = $('#choice-characters')
    ul.empty()
    for a in as
      li = $("<li class='listed-character col-sm-3 col-md-3'></li>")
      li.html(renderSummarySizeArcana(a, 'choice'))
      li.hide()
      ul.append(li)
      li.fadeIn('slow')
    renderPager()
    @

  searchArcanas = (query, path, callback) ->
    $("#error").hide()
    query ?= {}
    query.ver = $("#data-ver").val()
    url = $("#app-path").val() + path
    callbacks =
      done: (as) -> callback(as)
      fail: -> $("#error-area").show()

    if path == 'ptm'
      arcanas.searchMembers(query, url, callbacks)
    else if path == 'codes'
      arcanas.searchCodes(query, url, callbacks)
    else
      arcanas.search(query, url, callbacks)

  searchMembers = (ptm, edit) ->
    query = ptm: ptm
    searchArcanas query, 'ptm', (as) ->
      eachMemberKey (k) ->
        a = as[k]
        setMember(k, a)
        render = if edit
          renderSummarySizeMember(a)
        else
          renderFullSizeArcana(a)
        replaceMemberArcana memberAreaFor(k), render
      calcCost()

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
    return {recently: true} if (job == '' && rarity == '' && weapon == '' && actor == '' && illst == '' && union == '' && sourcecategory == '' && skill == '' && skillcost == '' && abilityCond == '' && abilityEffect == '' && chainAbilityCond == '' && chainAbilityEffect == '')

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

    unless (skill == '' && skillcost == '')
      query.skill = skill unless skill == ''
      query.skillcost = skillcost unless skillcost == ''
      skillsub = $("#skill-sub").val()
      query.skillsub = skillsub unless skillsub == ''
      skilleffect = $("#skill-effect").val()
      query.skilleffect = skilleffect unless skilleffect == ''
    query

  createQueryDetail = (query) ->
    elem = []
    if query.recently
      elem.push '最新'
    if query.job
      elem.push Arcana.jobNameFor(query.job)
    if query.rarity
      elem.push "★#{query.rarity.replace(/U/, '以上')}"
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
    if query.union
      elem.push '所属 - ' + Arcana.unionNameFor(query.union)
    if query.weapon
      elem.push '武器タイプ - ' + Arcana.weaponNameFor(query.weapon)
    if query.actor
      elem.push '声優 - ' + $("#actor :selected").text()
    if query.illustrator
      elem.push 'イラスト - ' + $("#illustrator :selected").text()
    elem.join(' / ')

  searchTargets = ->
    query = buildQuery()
    unless query
      $("#detail").text('')
      pager = new Pager([])
      replaceChoiceArea()
      return
    searchArcanas query, 'arcanas', (as) ->
      $("#detail").text(createQueryDetail(query))
      pager = new Pager(as)
      replaceChoiceArea()

  replaceChoiceAreaForUsed = ->
    as = []
    for a in usedList
      as.push arcanas.forCode(a)
    $("#detail").text('最近使ったアルカナ')
    pager = new Pager(as)
    replaceChoiceArea()

  searchUsedArcanas = ->
    if usedList.length <= 0
      replaceChoiceAreaForUsed()
      return

    targets = []
    for a in usedList
      continue if arcanas.forCode(a)
      targets.push a

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
    reset = $("#reset-members")

    if onEdit
      onEdit = false
      btn.text("編集する")
      member.removeClass("well well-sm")
      title.hide()
      reset.hide()
      edit.fadeOut()
    else
      onEdit = true
      btn.text("編集終了")
      member.addClass("well well-sm")
      title.show()
      reset.show()
      edit.fadeIn()
    replaceMemberArea()
    @

  clearMemberArcana = (key) ->
    removeMember(key)
    replaceMemberArcana(memberAreaFor(key), renderSummarySizeMember(null))

  removeDuplicateMember = (target) ->
    eachMemberKey (k) ->
      return if k == 'friend'
      a = memberFor(k)
      return unless a
      return unless a.name == target.name
      clearMemberArcana(k)
    @

  createMembersCode = ->
    header = 'V' + $("#pt-ver").val()
    code = ''
    eachMember (a) ->
      code += (if a then a.jobCode else 'N')
    if (/^N+$/).test(code) then '' else (header + code)

  calcCost = ->
    cost = 0
    eachMemberOnly (a) ->
      if a
        cost += a.cost
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
    a = arcanas.forCode(code)
    view = $("#view-detail")
    view.empty()
    view.append(renderArcanaDetail(a))
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

  prevChoicePage = ->
    if pager?.hasPrevPage()
      pager.prevPage()
      replaceChoiceArea()
    @

  nextChoicePage = ->
    if pager?.hasNextPage()
      pager.nextPage()
      replaceChoiceArea()
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

  initHandler = ->
    $("#error-area").hide()
    $("#error-area").removeClass("invisible")
    $("#edit-area").hide()
    $("#edit-area").removeClass("invisible")
    $("#edit-title").hide()
    $("#edit-title").removeClass("invisible")
    $("#tutorial").hide()
    $("#tutorial").removeClass("invisible")
    $("#reset-members").hide()
    $("#reset-members").removeClass("invisible")
    $("#additional-condition").hide()
    $("#skill-add").hide()

    if isFirstAccess()
      showTutorial()
      $("#latest-info").hide()
    else
      if isShowLatestInfo()
        $("#latest-info").hide()
      else
        showLatestInfo()

    createAbilityEffects()
    createChainAbilityEffects()

    $(".member-character").droppable(
      drop: (e, ui) ->
        e.preventDefault()
        drag = ui.draggable
        code = drag.data('jobCode')
        a = arcanas.forCode(code)
        target = $(e.target)
        key = memberKeyFromArea(target)

        unless target.hasClass('friend')
          removeDuplicateMember(a)
          if drag.hasClass('member')
            mem = memberFor(key)
            orgKey = drag.data('parentKey')
            setMember(orgKey, mem)
            replaceMemberArcana(memberAreaFor(orgKey),
              renderSummarySizeMember(mem))

        setMember(key, a)
        replaceMemberArcana(target, renderSummarySizeMember(a))
        calcCost()
        addUsedArcana(code)
    )

    $("#edit-members").hammer().on 'tap', (e) ->
      e.preventDefault()
      toggleEditMode()

    $("#search").hammer().on 'tap', (e) ->
      e.preventDefault()
      searchTargets()
      $("#search-modal").modal('hide')

    $("#member-area").on 'click', 'button.close-member', (e) ->
      e.preventDefault()
      target = $(e.target).parents(".member-character")
      key = memberKeyFromArea(target)
      clearMemberArcana(key)
      calcCost()

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
      prevChoicePage()

    $("#pager-next").hammer().on 'tap', (e) ->
      e.preventDefault()
      nextChoicePage()

    $("#used-list").hammer().on 'tap', (e) ->
      e.preventDefault()
      searchUsedArcanas()

    $("#clear-used").hammer().on 'tap', (e) ->
      e.preventDefault()
      if window.confirm('アルカナの使用履歴を消去します。よろしいですか？')
        clearUsedArcana()
        window.alert('アルカナの使用履歴を消去しました。')

    @

  initMembers = ->
    ptm = $("#ptm").val()
    searchTargets()
    if ptm == ''
      toggleEditMode() unless isPhoneDevice()
      searchMembers(defaultMemberCode, onEdit)
    else
      searchMembers(ptm)
    @

$ -> (new Viewer())
