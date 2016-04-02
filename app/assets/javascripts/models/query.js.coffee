class @Query

  @create: (param) ->
    new Query(param)

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

  isEmpty: ->
    q = (@q || {})
    if Object.keys(q).length <= 0 then true else false

  parse: (q) ->
    q ?= (location.search.replace(/(^\?)/,'') || '')
    @reset()
    return {} if _.isEmpty(q)

    ret = {}
    recently = false
    name = null
    r = /\+/g
    _.forEach q.split("&"), (qs) ->
      [n, v] = qs.split("=")
      val = decodeURIComponent(v).replace(r, ' ')
      return if n is 'ver'
      switch n
        when 'recently'
          recently = true
        when 'name'
          name = val
        when 'illustratorname'
          ret['illustrator'] = Conditions.illustratorIdFor(val)
        when 'actorname'
          ret['actor'] = Conditions.voiceactorIdFor(val)
        else
          ret[n] = val
    return if recently
    ret = {name: name} unless _.isEmpty(name)
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
          ret[n] = v unless _.isEmpty(v)
    query = {name: query.name} unless _.isEmpty(query.name)

    rs = []
    _.forEach query, (v, k) ->
      rs.push (encodeURIComponent(k) + "=" + encodeURIComponent(v))
    rs.join("&").replace(' ', "+")

  isQueryForRecently: ->
    return false unless @q
    if @q.recently then true else false

  isQueryForName: ->
    return false unless @q
    return false if @q.recently
    unless _.isEmpty(@q.name) then true else false

  createKey: ->
    query = _.omit (@q || {}), "ver"
    ObjectHash(query)
