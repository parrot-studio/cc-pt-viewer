class window.Query

  @create: (param) ->
    new Query(param)

  @build: ->
    query = new Query()
    query.build()
    query

  @parse: (q) ->
    query = new Query()
    query.parse(q)
    query

  constructor: (q) ->
    @q = (q || {})

  reset: ->
    @q = {}

  params: ->
    @q || {}

  build: ->
    job = getInputValue("job")
    rarity = getInputValue("rarity")
    weapon = getInputValue("weapon")
    actor = getInputValue("actor")
    illst = getInputValue("illustrator")
    union = getInputValue("union")
    sourcecategory = getInputValue("source-category")
    source = getInputValue("source")
    skill = getInputValue("skill")
    skillcost = getInputValue("skill-cost")
    abilityCond = getInputValue("ability-condition")
    abilityEffect = getInputValue("ability-effect")
    chainAbilityCond = getInputValue("chain-ability-condition")
    chainAbilityEffect = getInputValue("chain-ability-effect")
    arcanacost = getInputValue("arcana-cost")
    chaincost = getInputValue("chain-cost")

    query = {}
    query.job = job unless job is ''
    query.rarity = rarity unless rarity is ''
    query.weapon = weapon unless weapon is ''
    query.actor = actor unless actor is ''
    query.illustrator = illst unless illst is ''
    query.union = union unless union is ''
    unless sourcecategory is ''
      query.sourcecategory = sourcecategory
      query.source = source unless source is ''
    query.abilitycond = abilityCond unless abilityCond is ''
    query.abilityeffect = abilityEffect unless abilityEffect is ''
    query.chainabilitycond = chainAbilityCond unless chainAbilityCond is ''
    query.chainabilityeffect = chainAbilityEffect unless chainAbilityEffect is ''
    query.arcanacost = arcanacost unless arcanacost is ''
    query.chaincost = chaincost unless chaincost is ''

    unless (skill is '' && skillcost is '')
      query.skill = skill unless skill is ''
      query.skillcost = skillcost unless skillcost is ''
      skillsub = getInputValue("skill-sub")
      query.skillsub = skillsub unless skillsub is ''
      skilleffect = getInputValue("skill-effect")
      query.skilleffect = skilleffect unless skilleffect is ''

    @q = query
    @q

  isEmpty: ->
    q = (@q || {})
    if Object.keys(q).length <= 0 then true else false

  parse: (q) ->
    q ?= (location.search.replace(/(^\?)/,'') || '')
    @reset()
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
    return if recently
    @q = ret
    @q

  encode: ->
    return '' unless @q

    ret = {}
    recently = false
    for n, v of @q
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

    rs = []
    for k, v of ret
      rs.push (encodeURIComponent(k) + "=" + encodeURIComponent(v))
    rs.join("&").replace(' ', "+")

  isQueryForRecently: ->
    return false unless @q
    if @q.recently then true else false

  createKey: ->
    query = (@q || {})
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

  createDetail: ->
    query = (@q || {})
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

  getInputValue = (name) ->
    document.getElementById(name)?.value || ''

  getSelectboxText = (sname, v) ->
    ret = null
    for opt in (document.getElementById(sname)?.options || [])
      continue unless opt.value is v
      ret = opt.text
      break
    ret

  getSelectboxValue = (sname, v) ->
    ret = null
    for opt in (document.getElementById(sname)?.options || [])
      continue unless opt.text is v
      ret = opt.value
      break
    ret
