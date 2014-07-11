class Arcana

  JOB_NAME =
    F: '戦士'
    K: '騎士'
    A: '弓使い'
    M: '魔法使い'
    P: '僧侶'

  JOB_NAME_SHORT =
    F: '戦'
    K: '騎'
    A: '弓'
    M: '魔'
    P: '僧'

  CLASS_NAME =
    F: 'fighter'
    K: 'knight'
    A: 'archer'
    M: 'magician'
    P: 'priest'

  WEAPON_NAME =
    S: '斬'
    B: '打'
    P: '突'
    A: '弓'
    M: '魔'
    H: '聖'

  GROWTH_TYPE =
    fast:   '早熟'
    normal: '普通'
    slow:   '晩成'

  SOURCE_NAME =
    guildtown: '副都'
    holytown: '聖都'
    academy: '賢者の塔'
    mountain: '迷宮山脈'
    oasis: '湖都'
    forest: '精霊島'
    volcano: '九領'
    ring: 'リング交換'
    demon: '魔神戦'
    event: '期間限定'
    collaboration: 'コラボ限定'
    other: 'その他'

  constructor: (data) ->
    @name = data.name
    @title = data.title
    @rarity = data.rarity
    @cost = data.cost
    @jobType = data.job_type
    @jobIndex = data.job_index
    @jobCode = data.job_code
    @jobName = JOB_NAME[@jobType]
    @jobNameShort = JOB_NAME_SHORT[@jobType]
    @rarityStars = '★★★★★★'.slice(0, @rarity)
    @jobClass = CLASS_NAME[@jobType]
    @hometown = data.hometown
    @weaponType = data.weapon_type
    @weaponName = WEAPON_NAME[@weaponType]
    @voiceActor = data.voice_actor
    @illustrator = data.illustrator
    @growthType = data.growth_type
    @growthTypeName = GROWTH_TYPE[@growthType]
    @source = data.source
    @sourceName = SOURCE_NAME[@source]

  @jobNameFor = (j) -> JOB_NAME[j]
  @jobShortNameFor = (j) -> JOB_NAME_SHORT[j]
  @weaponNameFor = (w) -> WEAPON_NAME[w]
  @growthTypeNameFor = (g) -> GROWTH_TYPE[g]
  @sourceNameFor = (s) -> SOURCE_NAME[s]

class Arcanas

  arcanas = {}
  resultCache = {}

  constructor: () ->

  createQueryKey = (query) ->
    key = ""
    key += "recently_" if query.recently
    key += "j#{query.job}_" if query.job
    key += "r#{query.rarity}_" if query.rarity
    key += "s#{query.source}_" if query.source
    key += "w#{query.weapon}_" if query.weapon
    key += "g#{query.growth}_" if query.growth
    key += "a#{query.actor}_" if query.actor
    key += "i#{query.illustrator}_" if query.illustrator
    key

  search: (query, url, callbacks) ->
    key = createQueryKey(query)
    cached = resultCache[key]
    if cached
      as = (arcanas[code] for code in cached)
      callbacks.done(as)
      return

    xhr = $.getJSON url, query
    xhr.done (datas) ->
      as = []
      for data in datas
        a = new Arcana(data)
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as.push a
      cs = (a.jobCode for a in as)
      resultCache[key] = cs
      callbacks.done(as)
    xhr.fail ->
      callbacks.fail()

  searchMembers: (query, url, callbacks) ->
    xhr = $.getJSON url, query
    xhr.done (datas) ->
      as = {}
      for mem, data of datas
        continue unless data
        a = new Arcana(data)
        continue unless a
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as[mem] = a
      callbacks.done(as)
    xhr.fail ->
      callbacks.fail()

   forCode: (code) -> arcanas[code]

class Viewer

  arcanas = new Arcanas()
  members = ['mem1', 'mem2', 'mem3', 'mem4', 'sub1', 'sub2', 'friend']
  resultCache = {}
  onEdit = false

  constructor: ->
    initHandler()
    initMembers()

  eachMembers = (func) ->
    for m in members
      func(m)

  memberAreaFor = (m) ->
    $("#member-character-#{m}")

  eachMemberAreas = (func) ->
    eachMembers (m) ->
      func(memberAreaFor(m))

  eachMemberOnlyAreas = (func) ->
    eachMembers (m) ->
      func(memberAreaFor(m)) unless m == 'friend'

  eachMemberCode = (func) ->
    eachMemberAreas (area) ->
      c = area.children('div').data("jobCode")
      func(c)

  eachMemberOnlyCode = (func) ->
    eachMemberOnlyAreas (area) ->
      c = area.children('div').data("jobCode")
      func(c)

  renderFullSizeArcana = (a) ->
    if a
      "
        <div class='#{a.jobClass} full-size arcana' data-job-code='#{a.jobCode}'>
          <div class='#{a.jobClass}-title arcana-title'>
            #{a.jobNameShort} : #{a.rarityStars}
            <span class='badge pull-right'>#{a.cost}</span>
          </div>
          <div class='arcana-body'>
            <p class='arcana-name'>
                <span class='text-muted small'>#{a.title}</span><br>
                <strong>#{a.name}</strong>
            </p>
              <dl class='small text-muted'>
                <dt>type</dt>
                <dd>#{a.weaponName} / #{a.growthTypeName}</dd>
                <dt>illust</dt>
                <dd>#{a.illustrator}</dd>
                <dt>voice</dt>
                <dd>#{a.voiceActor}</dd>
              </dl>
          </div>
          <div class='#{a.jobClass}-footer arcana-footer'>
          </div>
        </div>
      "
    else
      "<div class='none full-size arcana'></div>"

  renderSummarySizeArcana = (a, cl) ->
    if a
      div = "
        <div class='#{a.jobClass} #{cl} summary-size arcana' data-job-code='#{a.jobCode}'>
          <div class='#{a.jobClass}-title arcana-title'>
            #{a.jobNameShort}:#{a.rarityStars} <span class='badge badge-sm pull-right'>#{a.cost}</span>
          </div>
          <div class='arcana-summary'>
            <p>
              <small>
                <span class='text-muted small'>#{a.title}</span><br>
                <strong>#{a.name}</strong>
              </small>
            </p>
          </div>
      "
      if cl == 'member'
        div += '<button type="button" class="close close-member" aria-hidden="true">&times;</button>'
      div += '</div>'
      div

      d = $(div)
      d.draggable(
        connectToSortable: false
        containment: false
        helper: 'clone'
        opacity: 0.7
        zindex: 100000
      )
    else
      d = $("<div class='none #{cl} summary-size arcana'></div>")
    d

  replaceArcana = (div, ra) ->
    div.empty()
    a = $(ra)
    a.hide()
    div.append(a)
    a.fadeIn()

  replaceMemberArea = ->
    eachMemberAreas (div) ->
      code = div.children('div').data("jobCode")
      a = arcanas.forCode(code)
      if onEdit
        replaceArcana(div, renderSummarySizeArcana(a, 'member'))
      else
        replaceArcana(div, renderFullSizeArcana(a))

  replaceChoiceArea = (as, detail) ->
    ul = $('#choice-characters')
    ul.empty()
    for a in as
      li = $("<li class='listed-character col-md-2 col-sm-2'></li>")
      li.html(renderSummarySizeArcana(a, 'choice'))
      li.hide()
      ul.append(li)
      li.fadeIn('slow')
    $("#detail").text(detail)
    @

  searchArcanas = (query, path, callback) ->
    $("#error").hide()
    query ?= {}
    query.ver = $("#data-ver").val()
    url = $("#app-path").val() + path
    callbacks =
      done: (as) -> callback(as)
      fail: $("#error").show()

    if path == 'ptm'
      arcanas.searchMembers(query, url, callbacks)
    else
      arcanas.search(query, url, callbacks)

  searchMembers = (ptm) ->
    query = ptm: ptm
    searchArcanas query, 'ptm', (as) ->
　　   eachMembers (mem) ->
        replaceArcana memberAreaFor(mem), renderFullSizeArcana(as[mem])
      calcCost()

  resetQuery = ->
    $("#job").val('')
    $("#rarity").val('')
    $("#weapon").val('')
    $("#actor").val('')
    $("#illustrator").val('')
    $("#growth").val('')
    $("#source").val('')

    $("#additional-condition").hide()
    $("#add-condition").show()
    @

  buildQuery = ->
    job = $("#job").val()
    rarity = $("#rarity").val()
    weapon = $("#weapon").val()
    actor = $("#actor").val()
    illst = $("#illustrator").val()
    growth = $("#growth").val()
    source = $("#source").val()
    return {recently: true}  if (job == '' && rarity == '' && weapon == '' && actor == '' && illst == '' && growth == '' && source == '')

    query = {}
    query.job = job unless job == ''
    query.rarity = rarity unless rarity == ''
    query.weapon = weapon unless weapon == ''
    query.actor = actor unless actor == ''
    query.illustrator = illst unless illst == ''
    query.growth = growth unless growth == ''
    query.source = source unless source == ''
    query

  createQueryDetail = (query) ->
    elem = []
    if query.recently
      elem.push '新着'
    if query.job
      elem.push Arcana.jobNameFor(query.job)
    if query.rarity
      elem.push "★#{query.rarity.replace(/U/, '以上')}"
    if query.source
      elem.push Arcana.sourceNameFor(query.source)
    if query.weapon
      elem.push Arcana.weaponNameFor(query.weapon)
    if query.growth
      elem.push Arcana.growthTypeNameFor(query.growth)
    if query.actor
      elem.push '声優 - ' + $("#actor :selected").text()
    if query.illustrator
      elem.push 'イラスト - ' + $("#illustrator :selected").text()
    elem.join(' / ')

  searchTargets = ->
    query = buildQuery()
    unless query
      replaceChoiceArea([], '')
      return
    searchArcanas query, 'arcanas', (as) ->
      replaceChoiceArea as, createQueryDetail(query)

  toggleEditMode = ->
    edit = $("#edit-area")
    member = $("#member-area")
    btn = $("#edit-members")
    title = $("#edit-title")

    if onEdit
      onEdit = false
      btn.text("編集する")
      member.removeClass("well well-sm")
      title.hide()
      edit.fadeOut()
    else
      onEdit = true
      btn.text("編集終了")
      member.addClass("well well-sm")
      title.show()
      edit.fadeIn()
      searchTargets()
    replaceMemberArea()
    @

  clearMemberArcana = (div) ->
    ra = renderSummarySizeArcana(null, 'member')
    replaceArcana(div, ra)

  removeDuplicateMember = (code) ->
    mems = $(".member")
    for m in mems
      mem = $(m)
      parent = mem.parent()
      continue if parent.hasClass('friend')
      c = mem.data("jobCode")
      continue unless c == code
      clearMemberArcana(parent)
    @

  createMembersCode = ->
    header = 'V' + $("#pt-ver").val()
    code = ''
    eachMemberCode (c) ->
      code += (c || 'N')
    if (/^N+$/).test(code) then '' else (header + code)

  calcCost = ->
    cost = 0
    eachMemberOnlyCode (code) ->
      a = arcanas.forCode(code)
      return unless a
      cost = cost + a.cost
    $("#cost").text(cost)

  initHandler = ->
    $("#error-area").hide()
    $("#error-area").removeClass("invisible")
    $("#edit-area").hide()
    $("#edit-area").removeClass("invisible")
    $("#edit-title").hide()
    $("#edit-title").removeClass("invisible")
    $("#additional-condition").hide()

    $(".member-character").droppable(
      drop: (e, ui) ->
        code = ui.draggable.data('jobCode')
        target = $(e.target)
        removeDuplicateMember(code) unless target.hasClass('friend')
        ra = renderSummarySizeArcana(arcanas.forCode(code), 'member')
        replaceArcana(target, ra)
        calcCost()
        e.preventDefault()
    )

    $("#edit-members").hammer().on 'tap', (e) ->
      toggleEditMode()
      e.preventDefault()

    $("#search").hammer().on 'tap', (e) ->
      searchTargets()
      $("#search-modal").modal('hide')
      e.preventDefault()

    $("#member-area").on 'click', 'button.close-member', (e) ->
      member = $(e.target).parents(".member-character")
      clearMemberArcana(member)
      calcCost()
      e.preventDefault()

    $("#share-modal").on 'show.bs.modal', (e) ->
      code = createMembersCode()
      url = $("#app-path").val() + code
      $("#ptm-code").val(url)

      twitterUrl = "https://twitter.com/intent/tweet"
      twitterUrl += "?text=#{encodeURIComponent('チェンクロパーティーシミュレーター ' + url)}"
      twitterUrl += "&hashtags=ccpts"
      $("#twitter-share").attr('href', twitterUrl)
      true # for modal

    $("#ptm-code").on 'click forcus', (e) ->
      $(e.target).select()
      e.preventDefault()

    $("#reset-members").hammer().on 'tap', (e) ->
      eachMemberAreas (area) ->
        replaceArcana(area, renderSummarySizeArcana('', 'member'))
      $("#cost").text('0')
      e.preventDefault()

    $("#search-clear").hammer().on 'tap', (e) ->
      resetQuery()
      e.preventDefault()

    $("#add-condition").hammer().on 'tap', (e) ->
       $("#add-condition").hide()
       $("#additional-condition").fadeIn('fast')
       e.preventDefault()

  initMembers = ->
    ptm = $("#ptm").val()
    if ptm == ''
      eachMemberAreas (div) ->
        replaceArcana(div, renderFullSizeArcana())
      $("#cost").text('0')
    else
      searchMembers(ptm)
    @

$ -> (new Viewer())
