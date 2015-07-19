class window.Searcher

  ver = $('#data-ver').val() || ''
  appPath = $("#app-path").val() || ''
  searchUrl = appPath + 'arcanas'
  ptmUrl = appPath + 'ptm'
  codesUrl = appPath + 'codes'
  condsUrl = appPath + 'conditions'

  arcanas = {}
  resultCache = {}
  detailCache = {}
  conditions = null

  @search: (params, url, callback) ->
    $("#error-area").hide()
    $("#loading-modal").modal('show')
    params ?= {}
    params.ver = ver

    xhr = $.getJSON url, params
    xhr.done (data) ->
      callback(data)
      $("#loading-modal").modal('hide')
    xhr.fail ->
      $("#loading-modal").modal('hide')
      $("#error-area").show()

  @searchArcanas: (query, callback) ->
    return unless query
    key = query.createKey()
    cached = resultCache[key]
    if cached
      as = (arcanas[code] for code in cached)
      detail = detailCache[key]
      callback(as, detail)
      return

    cb = (data) ->
      as = []
      cs = []
      for d in data.result
        a = new Arcana(d)
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as.push a
        cs.push a.jobCode
      resultCache[key] = cs
      detailCache[key] = data.detail
      callback(as, data.detail)

    @search(query.params(), searchUrl, cb)

  @searchMembers: (code, callback) ->
    params = {ptm: code}

    cb = (data) ->
      as = {}
      for aid, d of data
        continue unless d
        a = new Arcana(d)
        continue unless a
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as[aid] = a
      callback(as)

    @search(params, ptmUrl, cb)

  @searchCodes: (targets, callback) ->
    params = {'codes': targets.join('/')}

    cb = (data) ->
      as = []
      for d in data
        a = new Arcana(d)
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as.push a
      callback(as)

    @search(params, codesUrl, cb)

  @load_conditions: (callback) ->
    return if conditions
    cb = (data) ->
      conditions = data
      callback()

    @search({}, condsUrl, cb)

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
