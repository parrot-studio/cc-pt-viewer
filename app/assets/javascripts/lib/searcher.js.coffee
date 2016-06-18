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
  memberCache = {}

  @search: (params, url) ->
    $("#error-area").hide()

    params ?= {}
    params.ver = ver
    result = Bacon.fromPromise(Agent.get(url).query(params))
    result.onError (err) -> $("#error-area").show()
    result.onEnd -> $("#loading-modal").modal('hide')
    result.flatMap (res) -> Bacon.once(res.body)

  @searchArcanas: (query) ->
    return unless query
    return @searchFromName(query) if query.isQueryForName()

    key = query.createKey()
    cached = resultCache[key]
    if cached
      as = _.map cached, (c) -> Arcana.forCode(c)
      query.detail = detailCache[key]
      QueryLogs.add(query)
      return Bacon.once(QueryResult.create(as, detailCache[key]))

    $("#loading-modal").modal('show')
    @search(query.params(), searchUrl).flatMap (data) ->
      as = _.map data.result, (d) -> Arcana.build(d)
      cs = _.map as, (a) -> a.jobCode
      resultCache[key] = cs
      detailCache[key] = data.detail
      query.detail = data.detail
      QueryLogs.add(query)
      Bacon.once(QueryResult.create(as, data.detail))

  @searchMembers: (code) ->
    cache = memberCache[code]
    return Bacon.once(cache) if (cache)

    params = {ptm: code}
    @search(params, ptmUrl).flatMap (data) ->
      as = _.mapValues data, (d) -> Arcana.build(d)
      memberCache[code] = as
      Bacon.once(as)

  @searchCodes: (targets) ->
    return Bacon.once([]) if targets.length <= 0

    unknowns = _.reject targets, (c) -> Arcana.forCode(c)
    if unknowns.length <= 0
      as = _.map targets, (c) -> Arcana.forCode(c)
      return Bacon.once(QueryResult.create(as))

    $("#loading-modal").modal('show')
    params = {'codes': unknowns.join('/')}
    @search(params, codesUrl).flatMap (data) ->
      _.forEach data, (d) -> Arcana.build(d)
      as = _.map targets, (c) -> Arcana.forCode(c)
      Bacon.once(QueryResult.create(as))

  @loadConditions: ->
    @search({}, condsUrl)

  @request: (text) ->
    $("#error-area").hide()
    $("#loading-modal").modal('show')
    params = {}
    params.ver = ver
    params.text = text

    # NOTE: add CSRF header automatically if use jQuery's Ajax with jquery-rails
    token = $('meta[name="csrf-token"]').attr('content')
    post = Agent.post(requestUrl).set('X-CSRF-Token', token).send(params)

    result = Bacon.fromPromise(post)
    result.onError (err) -> $("#error-area").show()
    result.onEnd -> $("#loading-modal").modal('hide')
    result.flatMap (res) -> Bacon.once(res.body)

  @searchFromName: (query) ->
    @search(query.params(), nameUrl).flatMap (data) ->
      as = _.map data, (d) -> Arcana.build(d)
      query.detail = "名前から検索 : #{query.params().name}"
      QueryLogs.add(query)
      Bacon.once(QueryResult.create(as, query.detail))
