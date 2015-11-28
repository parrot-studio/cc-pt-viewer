class @QueryLogs

  queryLogSize = 10

  @lastQuery = null
  @querys = []

  @add: (q) ->
    return unless q
    return if q.isEmpty()
    @lastQuery = q
    return if q.isQueryForRecently()

    @querys = _.chain(_.flatten([q, @querys]))
      .uniq (oq) -> oq.encode()
      .take(queryLogSize)
      .value()
    cs = _.map @querys, (oq) ->
      {query: oq.encode(), detail: oq.detail.substr(0, 30)}

    Cookie.delete('query-log') # TODO delete
    QueryLogCookie.set({'query-log': cs})
    q

  @clear: ->
    @lastQuery = null
    @querys = []
    Cookie.delete('query-log') # TODO delete
    QueryLogCookie.delete('query-log')

  @init: ->
    @querys = []
    try
      # TODO delete
      cs = Cookie.valueFor('query-log') || QueryLogCookie.valueFor('query-log')
      return unless cs

      @querys = _.map cs, (c) ->
        q = Query.parse(c.query)
        return unless q
        q.detail = c.detail
        q
    catch
      @querys = []
