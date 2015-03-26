class window.Searcher

  ver = $('#data-ver').val() || ''
  appPath = $("#app-path").val() || ''
  searchUrl = appPath + 'arcanas'
  ptmUrl = appPath + 'ptm'
  codesUrl = appPath + 'codes'

  arcanas = {}
  resultCache = {}

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
      as = (new Member(arcanas[code]) for code in cached)
      callback(as)
      return

    cb = (data) ->
      as = []
      cs = []
      for d in data
        a = new Arcana(d)
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as.push (new Member(a))
        cs.push a.jobCode
      resultCache[key] = cs
      callback(as)

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
        as[aid] = (new Member(a))
      callback(as)

    @search(params, ptmUrl, cb)

  @searchCodes: (targets, callback) ->
    params = {'codes': targets.join('/')}

    cb = (data) ->
      as = []
      for d in data
        a = new Arcana(d)
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as.push (new Member(a))
      callback(as)

    @search(params, codesUrl, cb)

  @forCode: (code) ->
    a = arcanas[code]
    return unless a
    new Member(a)
