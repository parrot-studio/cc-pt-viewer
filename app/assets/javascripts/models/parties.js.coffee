class @Parties

  ptSize = 10
  @parties = []

  @partyFor = (order) ->
    @parties[order-1] || {}

  @addParty = (code, comment) ->
    comment ||= '名無しパーティー'
    if comment.length > 10
      comment = comment.substr(0, 10)

    data =
      code: code
      comment: comment
    @parties = _.chain(_.flatten([data, @parties]))
      .uniq (pt) -> pt.code
      .take(ptSize)
      .value()

    val = JSON.stringify(@parties)
    Cookie.set({'parties': val})
    @parties

  @init: ->
    @parties = []
    try
      val = Cookie.valueFor('parties')
      return unless val
      @parties = JSON.parse(val)
    catch
      @parties = []
    @
