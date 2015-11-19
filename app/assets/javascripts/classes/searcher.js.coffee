class @Searcher

  ver = $('#data-ver').val() || ''
  appPath = $("#app-path").val() || ''
  searchUrl = appPath + 'arcanas'
  ptmUrl = appPath + 'ptm'
  codesUrl = appPath + 'codes'
  condsUrl = appPath + 'conditions'
  requestUrl = appPath + 'request'

  arcanas = {}
  resultCache = {}
  detailCache = {}
  conditions = null

  toArcana = (d) ->
    return null unless d
    a = new Arcana(d)
    return null unless a
    arcanas[a.jobCode] = a unless arcanas[a.jobCode]
    a

  @search: (params, url) ->
    $("#error-area").hide()
    $("#loading-modal").modal('show')

    params ?= {}
    params.ver = ver
    result = Bacon.$.ajaxGetJSON(url, params)
    result.onError( (err) -> $("#error-area").show())
    result.onEnd( -> $("#loading-modal").modal('hide'))
    result

  @searchArcanas: (query) ->
    return unless query
    key = query.createKey()
    cached = resultCache[key]
    if cached
      as = (arcanas[code] for code in cached)
      query.detail = detailCache[key]
      return Bacon.once(as)

    result = @search(query.params(), searchUrl)
    result.flatMap (data) ->
      as = []
      cs = []
      for d in data.result
        a = toArcana(d)
        as.push a
        cs.push a.jobCode
      resultCache[key] = cs
      detailCache[key] = data.detail
      query.detail = data.detail
      Bacon.once(as)

  @searchMembers: (code) ->
    params = {ptm: code}

    result = @search(params, ptmUrl)
    result.flatMap (data) ->
      as = {}
      for aid, d of data
        continue unless d
        as[aid] = toArcana(d)
      Bacon.once(as)

  @searchCodes: (targets) ->
    return Bacon.once([]) if targets.length <= 0

    unknowns = []
    for c in targets
      continue if arcanas[c]
      unknowns.push c

    if unknowns.length <= 0
      as = (arcanas[c] for c in targets)
      return Bacon.once(as)

    params = {'codes': unknowns.join('/')}
    result = @search(params, codesUrl)
    result.flatMap (data) ->
      toArcana(d) for d in data
      as = (arcanas[c] for c in targets)
      Bacon.once(as)

  @loadConditions: ->
    return Bacon.once(conditions) if conditions

    result = @search({}, condsUrl)
    result.flatMap (data) ->
      conditions = data
      Bacon.once(conditions)

  @forCode: (code) ->
    arcanas[code]

  @unions: ->
    conditions?.unions || []

  @sourceTypesFor: (category) ->
    conditions?.sources?[category] || []

  @skillCategorys: ->
    conditions?.skillcategorys || []

  @skillSubtypesFor: (skill) ->
    conditions?.skillsubs?[skill] || []

  @skillEffectTypesFor: (skill) ->
    conditions?.skilleffects?[skill] || []

  @abirityCategorys: ->
    conditions?.abilitycategorys || []

  @abirityEffectsFor: (category) ->
    conditions?.abilityeffects?[category] || []

  @abirityConditionsFor: (category) ->
    conditions?.abilityconditions?[category] || []

  @chainAbirityCategorys: ->
    conditions?.chainabilitycategorys || []

  @chainAbirityEffectsFor: (category) ->
    conditions?.chainabilityeffects?[category] || []

  @chainAbirityConditionsFor: (category) ->
    conditions?.chainabilityconditions?[category] || []

  @voiceactors: ->
    conditions?.voiceactors || []

  @voiceactorIdFor: (name) ->
    return null unless name
    ret = null
    for v in @voiceactors()
      continue unless v[1] is name
      ret = v[0]
      break
    ret

  @voiceactorNameFor: (id) ->
    return '' unless id
    id = parseInt(id)
    ret = ''
    for v in @voiceactors()
      continue unless v[0] == id
      ret = v[1]
      break
    ret

  @illustrators: ->
    conditions?.illustrators || []

  @illustratorIdFor: (name) ->
    return null unless name
    ret = null
    for v in @illustrators()
      continue unless v[1] is name
      ret = v[0]
      break
    ret

  @illustratorNameFor: (id) ->
    return '' unless id
    id = parseInt(id)
    ret = ''
    for v in @illustrators()
      continue unless v[0] == id
      ret = v[1]
      break
    ret

  @request: (text) ->
    $("#error-area").hide()
    $("#loading-modal").modal('show')
    params = {}
    params.ver = ver
    params.text = text

    result = Bacon.$.ajaxPost(requestUrl, params)
    result.onError( (err) -> $("#error-area").show())
    result.onEnd( -> $("#loading-modal").modal('hide'))
    result
