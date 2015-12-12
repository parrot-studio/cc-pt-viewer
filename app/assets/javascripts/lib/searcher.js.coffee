class @Searcher

  ver = $('#data-ver').val() || ''
  appPath = $("#app-path").val() || ''
  searchUrl = appPath + 'arcanas'
  ptmUrl = appPath + 'ptm'
  codesUrl = appPath + 'codes'
  condsUrl = appPath + 'conditions'
  requestUrl = appPath + 'request'
  nameUrl = appPath + 'name'

  resultCache = {}
  detailCache = {}

  @search: (params, url) ->
    $("#error-area").hide()
    $("#loading-modal").modal('show')

    params ?= {}
    params.ver = ver
    result = Bacon.fromPromise($.getJSON(url, params))
    result.onError (err) -> $("#error-area").show()
    result.onEnd -> $("#loading-modal").modal('hide')
    result

  @searchArcanas: (query) ->
    return unless query
    return @searchFromName(query) if query.isQueryForName()

    key = query.createKey()
    cached = resultCache[key]
    if cached
      as = _.map cached, (c) -> Arcana.forCode(c)
      query.detail = detailCache[key]
      return Bacon.once(as)

    result = @search(query.params(), searchUrl)
    result.flatMap (data) ->
      as = _.map data.result, (d) -> Arcana.build(d)
      cs = _.map as, (a) -> a.jobCode
      resultCache[key] = cs
      detailCache[key] = data.detail
      query.detail = data.detail
      Bacon.once(as)

  @searchMembers: (code) ->
    params = {ptm: code}

    result = @search(params, ptmUrl)
    result.flatMap (data) ->
      as = _.mapValues data, (d) -> Arcana.build(d)
      Bacon.once(as)

  @searchCodes: (targets) ->
    return Bacon.once([]) if targets.length <= 0

    unknowns = _.reject targets, (c) -> Arcana.forCode(c)
    if unknowns.length <= 0
      as = _.map targets, (c) -> Arcana.forCode(c)
      return Bacon.once(as)

    params = {'codes': unknowns.join('/')}
    result = @search(params, codesUrl)
    result.flatMap (data) ->
      _.forEach data, (d) -> Arcana.build(d)
      as = _.map targets, (c) -> Arcana.forCode(c)
      Bacon.once(as)

  @loadConditions: ->
    @search({}, condsUrl)

  @request: (text) ->
    $("#error-area").hide()
    $("#loading-modal").modal('show')
    params = {}
    params.ver = ver
    params.text = text

    result = Bacon.fromPromise($.post(requestUrl, params))
    result.onError( (err) -> $("#error-area").show())
    result.onEnd( -> $("#loading-modal").modal('hide'))
    result

  @searchFromName: (query) ->
    @search(query.params(), nameUrl).flatMap (data) ->
      _.map data, (d) -> Arcana.build(d)
