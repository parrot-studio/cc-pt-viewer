class @Favorites

  favs = {}

  @stateFor: (code) ->
    return false unless code
    if favs[code] then true else false

  @setState: (code, state) ->
    favs[code] = state
    store()
    state

  @list: ->
    _.chain(favs)
      .map (s, c) -> if s then c else ''
      .compact()
      .value()
      .sort()

  @clear: ->
    favs = {}
    Cookie.delete('fav-arcana')
    favs

  store = ->
    fl = Favorites.list()
    Cookie.set({'fav-arcana': fl.join('/')})
    favs

  @init: ->
    try
      list = Cookie.valueFor('fav-arcana')
      return unless list
      favs = _.reduce list.split('/'), ((f, c) -> f[c] = true; f),  {}
    catch
      favs = {}
