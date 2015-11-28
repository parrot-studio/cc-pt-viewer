class CookieBase

  $.cookie.json = true
  expireDate = 60

  @set = (base, data) ->
    d = _.merge @get(base), (data || {})
    $.cookie(base, d, {expires: expireDate})

  @get = (base) ->
    $.cookie(base) || {}

  @clear = (base) ->
    $.removeCookie(base)

  @replace = (base, data) ->
    $.cookie(base, (data || {}), {expires: expireDate})

  @delete = (base, key) ->
    c = @get(base)
    delete c[key]
    @replace(base, c)

  @valueFor = (base, key) ->
    c = @get(base)
    c[key]

class @Cookie

  cookieKey = 'ccpts'

  @set = (data) ->
    CookieBase.set(cookieKey, data)

  @get = ->
    CookieBase.get(cookieKey)

  @clear = ->
    CookieBase.clear(cookieKey)

  @replace = (data) ->
    CookieBase.replace(cookieKey, data)

  @delete = (key) ->
    CookieBase.delete(cookieKey, key)

  @valueFor = (key) ->
    CookieBase.valueFor(cookieKey, key)

class @QueryLogCookie

  cookieKey = 'ccpts_query_logs'

  @set = (data) ->
    CookieBase.set(cookieKey, data)

  @get = ->
    CookieBase.get(cookieKey)

  @clear = ->
    CookieBase.clear(cookieKey)

  @replace = (data) ->
    CookieBase.replace(cookieKey, data)

  @delete = (key) ->
    CookieBase.delete(cookieKey, key)

  @valueFor = (key) ->
    CookieBase.valueFor(cookieKey, key)
