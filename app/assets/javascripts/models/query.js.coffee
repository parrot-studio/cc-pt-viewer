class @Query

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
    @detail = ''

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
    query.job = job unless _.isEmpty(job)
    query.rarity = rarity unless _.isEmpty(rarity)
    query.weapon = weapon unless _.isEmpty(weapon)
    query.actor = actor unless _.isEmpty(actor)
    query.illustrator = illst unless _.isEmpty(illst)
    query.union = union unless _.isEmpty(union)
    unless _.isEmpty(sourcecategory)
      query.sourcecategory = sourcecategory
      query.source = source unless _.isEmpty(source)
    query.abilitycategory = abilityCategory unless _.isEmpty(abilityCategory)
    query.abilityeffect = abilityEffect unless _.isEmpty(abilityEffect)
    query.abilitycondition = abilityCondition unless _.isEmpty(abilityCondition)
    query.chainabilitycategory = chainAbilityCategory unless _.isEmpty(chainAbilityCategory)
    query.chainabilityeffect = chainAbilityEffect unless _.isEmpty(chainAbilityEffect)
    query.chainabilitycondition = chainAbilityCondition unless _.isEmpty(chainAbilityCondition)
    query.arcanacost = arcanacost unless _.isEmpty(arcanacost)
    query.chaincost = chaincost unless _.isEmpty(chaincost)

    unless (_.isEmpty(skill) && _.isEmpty(skillcost))
      query.skill = skill unless _.isEmpty(skill)
      query.skillcost = skillcost unless _.isEmpty(skillcost)
      skillsub = getInputValue("skill-sub")
      query.skillsub = skillsub unless _.isEmpty(skillsub)
      skilleffect = getInputValue("skill-effect")
      query.skilleffect = skilleffect unless _.isEmpty(skilleffect)

    @q = query
    @q

  isEmpty: ->
    q = (@q || {})
    if Object.keys(q).length <= 0 then true else false

  parse: (q) ->
    q ?= (location.search.replace(/(^\?)/,'') || '')
    @reset()
    return {} if _.isEmpty(q)

    ret = {}
    recently = false
    r = /\+/g
    _.forEach q.split("&"), (qs) ->
      [n, v] = qs.split("=")
      val = decodeURIComponent(v).replace(r, ' ')
      return if n is 'ver'
      switch n
        when 'recently'
          recently = true
        when 'illustratorname'
          ret['illustrator'] = Conditions.illustratorIdFor(val)
        when 'actorname'
          ret['actor'] = Conditions.voiceactorIdFor(val)
        else
          ret[n] = val
    return if recently
    @q = ret
    @q

  encode: ->
    return '' unless @q
    return '' if @q.recently

    query = _.transform @q, (ret, v, n) ->
      return if n is 'ver'
      switch n
        when 'illustrator'
          ret['illustratorname'] = Conditions.illustratorNameFor(v)
        when 'actor'
          ret['actorname'] = Conditions.voiceactorNameFor(v)
        else
          ret[n] = v

    rs = []
    _.forEach query, (v, k) ->
      rs.push (encodeURIComponent(k) + "=" + encodeURIComponent(v))
    rs.join("&").replace(' ', "+")

  isQueryForRecently: ->
    return false unless @q
    if @q.recently then true else false

  createKey: ->
    query = (@q || {})
    key = ''
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
