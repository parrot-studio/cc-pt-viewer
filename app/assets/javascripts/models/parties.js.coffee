class @Parties

  ptSize = 10
  defalutMembersCode = 'V2F82F85K51NA38NP28NP24NNNNN'
  @parties = []
  @lastParty = defalutMembersCode
  @notifyStream = new Bacon.Bus()

  @clear = ->
    @parties = []
    Cookie.set({'parties': ""})
    @notifyStream.push(@parties)
    @parties

  @setLastParty = (party) ->
    @lastParty = party.createCode()
    Cookie.set({'last-members': @lastParty})
    @lastParty

  @partyFor = (order) ->
    @parties[order-1] || {}

  @addParty = (party, comment) ->
    code = party.createCode()
    return if _.isEmpty(code)
    comment ||= '名無しパーティー'
    if comment.length > 10
      comment = comment.substr(0, 10)

    data =
      code: code
      comment: comment
    @parties = _.chain(_.flatten([data, @parties]))
      .uniqBy (pt) -> pt.code
      .take(ptSize)
      .value()

    val = JSON.stringify(@parties)
    Cookie.set({'parties': val})
    @notifyStream.push(@parties)
    @parties

  @init: ->
    @parties = []
    try
      val = Cookie.valueFor('parties') || ""
      @parties = JSON.parse(val) unless _.isEmpty(val)
    catch
      @parties = []

    @lastParty = ""
    try
      @lastParty = (Cookie.valueFor('last-members') || "")
    catch
      @lastParty = ""
    @lastParty = defalutMembersCode if _.isEmpty(@lastParty)

    @
