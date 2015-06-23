class window.Arcana

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
    beasts: 'ケ者の大陸'
    criminal: '罪の大陸'
    life: '薄命の大陸'
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
      types: ['forest-sea', 'dawnsea', 'beasts', 'criminal', 'life', 'other']
      details:
        'forest-sea': '海風の港・酒場'
        'dawnsea': '夜明けの大海・酒場'
        'beasts': 'ケ者の大陸・酒場'
        'criminal': '罪の大陸・酒場'
        'life': '薄命の大陸・酒場'
        'other': 'その他'
    ring:
      name: 'リング系'
      types: ['trade', 'random']
      details:
        'trade': '交換'
        'random': 'ガチャ'
    event:
      name: 'イベント限定'
      types: ['festival', 'demon', 'score', 'war', 'other']
      details:
        'festival': 'フェス'
        'demon': '魔神戦'
        'score': '戦の年代記'
        'war': '討伐戦'
        'other': 'その他'
    collaboration:
      name: 'コラボ限定'
      types: ['shiningblade', 'maoyu', 'trefle', 'mediafactory',
        'loghorizon', 'bakidou', 'atelier-twilight', 'monokuma',
        'falcom-sen2', 'sevensins', 'other']
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
        'sevensins': '七つの大罪'
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
      else if @jobCode is 'A82'
        "#{@title}セガ・マークⅢ"
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

  @canUseChainAbility = (a, b) ->
    return false unless (a && b)
    return false unless a.jobType == b.jobType
    return false if a.name == b.name
    true
