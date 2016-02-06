class @QueryLogs

  queryLogSize = 10

  @lastQuery = null
  @querys = []
  @notifyStream = new Bacon.Bus()

  @add: (q) ->
    return unless q
    return if q.isEmpty()
    @lastQuery = q
    return if q.isQueryForRecently()
    return if q.isQueryForName()

    @querys = _.chain(_.flatten([q, @querys]))
      .uniqBy (oq) -> oq.encode()
      .take(queryLogSize)
      .value()
    cs = _.map @querys, (oq) ->
      {query: oq.encode(), detail: oq.detail.substr(0, 30)}

    QueryLogCookie.set({'query-log': cs})
    @notifyStream.push @querys
    q

  @clear: ->
    @lastQuery = null
    @querys = []
    QueryLogCookie.delete('query-log')
    @notifyStream.push []

  @init: ->
    @querys = []
    try
      cs = QueryLogCookie.valueFor('query-log')
      return unless cs

      @querys = _.map cs, (c) ->
        q = Query.parse(c.query)
        return unless q
        q.detail = c.detail
        q
    catch
      @querys = []
