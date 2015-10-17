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
    @detail = ""

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
    abilityCategory = getInputValue("ability-category")
    abilityEffect = getInputValue("ability-effect")
    abilityCondition = getInputValue("ability-condition")
    chainAbilityCategory = getInputValue("chain-ability-category")
    chainAbilityEffect = getInputValue("chain-ability-effect")
    chainAbilityCondition = getInputValue("chain-ability-condition")
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
    query.abilitycategory = abilityCategory unless abilityCategory is ''
    query.abilityeffect = abilityEffect unless abilityEffect is ''
    query.abilitycondition = abilityCondition unless abilityCondition is ''
    query.chainabilitycategory = chainAbilityCategory unless chainAbilityCategory is ''
    query.chainabilityeffect = chainAbilityEffect unless chainAbilityEffect is ''
    query.chainabilitycondition = chainAbilityCondition unless chainAbilityCondition is ''
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
          ret['illustrator'] = Searcher.illustratorIdFor(val)
        when 'actorname'
          ret['actor'] = Searcher.voiceactorIdFor(val)
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
          ret['illustratorname'] = Searcher.illustratorNameFor(v)
        when 'actor'
          ret['actorname'] = Searcher.voiceactorNameFor(v)
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
    key += "abca#{query.abilitycategory}_" if query.abilitycategory
    key += "abe#{query.abilityeffect}_" if query.abilityeffect
    key += "abco#{query.abilitycondition}_" if query.abilitycondition
    key += "cabca#{query.chainabilitycategory}_" if query.chainabilitycategory
    key += "cabe#{query.chainabilityeffect}_" if query.chainabilityeffect
    key += "cabco#{query.chainabilitycondition}_" if query.chainabilitycondition
    key += "arco#{query.arcanacost}_" if query.arcanacost
    key += "chco#{query.chaincost}_" if query.chaincost
    key

  getInputValue = (name) ->
    document.getElementById(name)?.value || ''
