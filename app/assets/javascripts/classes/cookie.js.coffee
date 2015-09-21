class window.Cookie

  $.cookie.json = true
  cookieKey = 'ccpts'
  expireDate = 60

  @set = (data) ->
    d = $.extend(@get(), (data || {}))
    $.cookie(cookieKey, d, {expires: expireDate})

  @get = ->
    $.cookie(cookieKey) || {}

  @clear = ->
    $.removeCookie(cookieKey)

  @replace = (data) ->
    $.cookie(cookieKey, (data || {}), {expires: expireDate})

  @delete = (key) ->
    c = @get()
    delete c[key]
    @replace(c)

  @valueFor = (key) ->
    c = @get()
    c[key]
