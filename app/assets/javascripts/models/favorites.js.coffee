class @Favorites

  favs = {}
  @notifyStream = new Bacon.Bus()

  @stateFor: (code) ->
    return false unless code
    if favs[code] then true else false

  @setState: (code, state) ->
    favs[code] = state
    store()
    @notifyStream.push(favs)
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
    @notifyStream.push(favs)
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
