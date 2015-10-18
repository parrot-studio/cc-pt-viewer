class window.Ability

  constructor: (data) ->
    @name = data.name || ''
    @explanation = data.explanation || ''
    @weaponName = data.weapon_name || ''
    @effects = []
    if data.effects
      for e in data.effects
        d =
          category: e.category
          condition: e.condition
          effect: e.effect
          target: e.target
          note: e.note || ''
        @effects.push d

class window.Skill

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
          multi_type: e.multi_type || ''
          multi_condition: e.multi_condition || ''
          subeffect1: e.subeffect1 || ''
          subeffect2: e.subeffect2 || ''
          subeffect3: e.subeffect3 || ''
          subeffect4: e.subeffect4 || ''
          subeffect5: e.subeffect5 || ''
          note: e.note || ''
        @effects.push d

  @subeffectForEffect: (ef) ->
    return [] unless ef
    ret = []
    ret.push(ef.subeffect1) unless ef.subeffect1 == ''
    ret.push(ef.subeffect2) unless ef.subeffect2 == ''
    ret.push(ef.subeffect3) unless ef.subeffect3 == ''
    ret.push(ef.subeffect4) unless ef.subeffect4 == ''
    ret.push(ef.subeffect5) unless ef.subeffect5 == ''
    ret

class window.Arcana

  JOB_NAME_SHORT =
    F: '戦'
    K: '騎'
    A: '弓'
    M: '魔'
    P: '僧'

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
    @jobName = data.job_name
    @jobNameShort = JOB_NAME_SHORT[@jobType]
    @rarityStars = '★★★★★★'.slice(0, @rarity)
    @jobClass = data.job_class
    @weaponType = data.weapon_type
    @weaponName = data.weapon_name
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
    @weaponAbility = new Ability(data.weapon_ability)
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

  @canUseChainAbility = (a, b) ->
    return false unless (a && b)
    return false unless a.jobType == b.jobType
    return false if a.name == b.name
    true

class window.Member

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
    return false if @arcana.name == @chainArcana.name
    true
