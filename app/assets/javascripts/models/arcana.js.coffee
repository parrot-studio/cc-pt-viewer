class @Ability

  constructor: (data) ->
    @name = data.name || ''
    @explanation = data.explanation || ''
    @weaponName = data.weapon_name || ''
    @effects = []
    if data.effects
    　@effects = _.map data.effects, (e) ->
        d =
          category: e.category
          condition: e.condition
          effect: e.effect
          target: e.target
          note: e.note || ''

class @Skill

  constructor: (data) ->
    @name = data.name || '？'
    @explanation = data.explanation || ''
    @cost = data.cost || '？'
    @effects = []
    if data.effects
      @effects = _.map data.effects, (e) ->
        d =
          category: e.category
          subcategory: e.subcategory
          multi_type: e.multi_type || ''
          multi_condition: e.multi_condition || ''
          subeffect1: e.subeffect1 || ''
          subeffect2: e.subeffect2 || ''
          subeffect3: e.subeffect3 || ''
          subeffect4: e.subeffect4 || ''
          subeffect5: e.subeffect5 || ''
          note: e.note || ''

  @subEffectForEffect: (ef) ->
    return [] unless ef
    ret = []
    ret.push(ef.subeffect1) unless ef.subeffect1 == ''
    ret.push(ef.subeffect2) unless ef.subeffect2 == ''
    ret.push(ef.subeffect3) unless ef.subeffect3 == ''
    ret.push(ef.subeffect4) unless ef.subeffect4 == ''
    ret.push(ef.subeffect5) unless ef.subeffect5 == ''
    ret

class @Arcana

  JOB_NAME_SHORT =
    F: '戦'
    K: '騎'
    A: '弓'
    M: '魔'
    P: '僧'

  WIKI_URL = 'http://xn--eckfza0gxcvmna6c.gamerch.com/'

  arcanas = {}

  @forCode: (code) ->
    arcanas[code]

  @build = (d) ->
    return null unless d
    a = new Arcana(d)
    return null unless a
    arcanas[a.jobCode] = a unless arcanas[a.jobCode]
    a

  constructor: (data) ->
    @name = data.name
    @title = data.title
    @rarity = data.rarity
    @cost = data.cost
    @chainCost = data.chain_cost
    @jobType = data.job_type
    @jobIndex = data.job_index
    @jobCode = data.job_code
    @jobName = data.job_name
    @jobNameShort = JOB_NAME_SHORT[@jobType]
    @rarityStars = '★★★★★★'.slice(0, @rarity)
    @jobClass = data.job_class
    @weaponType = data.weapon_type
    @weaponName = data.weapon_name
    @voiceActor = data.voice_actor
    @voiceActor = '？' if _.isEmpty(@voiceActor)
    @illustrator = data.illustrator
    @illustrator = '？' if _.isEmpty(@illustrator)
    @union = data.union
    @sourceCategory = data.source_category
    @source = data.source
    @jobDetail = data.job_detail
    @maxAtk = (data.max_atk || '-')
    @maxHp = (data.max_hp || '-')
    @limitAtk = (data.limit_atk || '-')
    @limitHp = (data.limit_hp || '-')

    @firstSkill = new Skill(data.first_skill)
    @secondSkill = new Skill(data.second_skill) unless _.isEmpty(data.second_skill)
    @thirdSkill = new Skill(data.third_skill) unless _.isEmpty(data.third_skill)
    @firstAbility = new Ability(data.first_ability)
    @secondAbility = new Ability(data.second_ability)
    @weaponAbility = new Ability(data.weapon_ability)
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
      if _.isEmpty(@wikiName)
        WIKI_URL
      else
        WIKI_URL + encodeURIComponent(@wikiName)
    )

  @sameCharacter = (a, b) ->
    return false unless (a && b)
    # コラボキャラとオリジナルキャラの組み合わせはチェックしない
    return false if (a.union == "旅人" && b.union != "旅人")
    return false if (a.union != "旅人" && b.union == "旅人")
    if a.name == b.name then true else false

  @sameArcana = (a, b) ->
    return false unless (a && b)
    if a.jobCode == b.jobCode then true else false

  @canUseChainAbility = (a, b) ->
    return false unless (a && b)
    return false unless a.jobType == b.jobType
    true

class @Member

  constructor: (a) ->
    @arcana = a
    @chainArcana = null
    @memberKey = null

  chainedCost: ->
    c = @arcana.cost
    return c unless @chainArcana
    (c + @chainArcana.chainCost)

  canUseChainAbility: ->
    return false unless @chainArcana
    return false unless @arcana.jobType == @chainArcana.jobType
    true

  isSameUnion: ->
    return false unless @chainArcana
    return false unless @arcana.union == @chainArcana.union
    true
