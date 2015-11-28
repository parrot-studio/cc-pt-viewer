class @CommonView

  $errorArea = $("#error-area")
  $topnav = $("#topnav")
  $requestTextarea = $("#request-textarea")
  $ads = $("#ads")
  $requestModal = $("#request-modal")
  $formRequest = $("#form-request")
  $twitterRequest = $("#twitter-request")
  $latestInfo = $("#latest-info")
  $latestInfoVer = $("#latest-info-ver")

  @init: -> new CommonView()

  @isPhoneDevice = ->
    if window.innerWidth < 768 then true else false

  @twitterUrl: (text) ->
    url = "https://twitter.com/intent/tweet"
    url += "?text=#{encodeURIComponent(text)}"
    url += "&hashtags=ccpts"
    url

  @showLatestInfo: ->
    return unless isShowLatestInfo()
    ver = $latestInfoVer.val()
    $latestInfo.show()
    Cookie.set({'latest-info': ver})

  constructor: ->
    initHandler()

  isShowLatestInfo = ->
    ver = $latestInfoVer.val()
    return false if _.isEmpty(ver)
    showed = Cookie.valueFor('latest-info')
    return true unless showed
    if ver == showed then false else true

  requestText = ->
    $requestTextarea.val().substr(0, 100)

  createRequestTweetUrl = (text) ->
    text ?= requestText()
    $twitterRequest.attr('href', CommonView.twitterUrl("@parrot_studio #{text}"))

  initHandler = () ->
    $errorArea.hide()
    $errorArea.removeClass("invisible")
    $topnav.hide()
    $topnav.removeClass("invisible")

    if CommonView.isPhoneDevice()
      $ads.hide()
    else
      $topnav.show()

    $latestInfo.hide()
    $latestInfo.removeClass("invisible")

    $requestModal
      .asEventStream('show.bs.modal')
      .onValue -> createRequestTweetUrl()

    $requestTextarea
      .asEventStream('keyup change')
      .delay(500)
      .map -> requestText()
      .debounce(300)
      .skipDuplicates()
      .onValue (text) -> createRequestTweetUrl(text)

    $formRequest
      .asEventStream('click')
      .doAction('.preventDefault')
      .map -> requestText()
      .filter (text) ->
        rsl = (text.length > 0)
        window.alert("メッセージを入力してください") unless rsl
        rsl
      .filter (text) -> window.confirm("メッセージを送信します。よろしいですか？")
      .doAction( -> $requestModal.modal('hide'))
      .map (text) -> Searcher.request(text)
      .onValue ->
        $requestTextarea.val('')
        createRequestTweetUrl('')
        window.alert("メッセージを送信しました")
