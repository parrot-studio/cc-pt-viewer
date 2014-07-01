class Arcana

  JOB_NAME =
    F: '戦士'
    K: '騎士'
    A: '弓使い'
    M: '魔法使い'
    P: '僧侶'

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

  constructor: (data) ->
    @name = data.name
    @title = data.title
    @rarity = data.rarity
    @cost = data.cost
    @jobType = data.job_type
    @jobIndex = data.job_index
    @jobCode = data.job_code
    @jobName = JOB_NAME[@jobType]
    @rarityStars = '☆☆☆☆☆'.slice(0, @rarity)
    @jobClass = CLASS_NAME[@jobType]
    @hometown = data.hometown
    @weaponType = data.weapon_type
    @weaponName = WEAPON_NAME[@weaponType]

class Viewer

  arcanas = {}
  members = ['mem1', 'mem2', 'mem3', 'mem4', 'sub1', 'sub2', 'friend']
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

  renderFullSizeArcana = (a) ->
    if a
      div = "<div class='#{a.jobClass} full-size arcana' data-job-code='#{a.jobCode}'>"
      div += "<div class='#{a.jobClass}-title'>#{a.rarityStars}</div>"
      div += "<div class='arcana-body'>"
      div += '<p>'
      div += a.title + '<br>'
      div += a.name + '<br>'
      div += a.weaponName + '<br>'
      div += "cost:#{a.cost}"
      div += '</p>'
      div += '</div>'
      div += '</div>'
      div
    else
      "<div class='none full-size arcana'></div>"

  renderSummarySizeArcana = (a, cl) ->
    if a
      div = "<div class='#{a.jobClass} #{cl} summary-size arcana' data-job-code='#{a.jobCode}'>"
      div += "<div class='#{a.jobClass}-title'>#{a.rarityStars} (#{a.cost})</div>"
      div += '<div class="arcana-summary"><p><small>'
      div += a.title + '<br>'
      div += a.name
      div += '</small></p></div>'
      if cl == 'member'
        div += '<button type="button" class="close close-member" aria-hidden="true">&times;</button>'
      div += '</div>'
      div
    else
      "<div class='none #{cl} summary-size arcana'></div>"

  replaceArcana = (div, ra) ->
    div.empty()
    a = $(ra)
    a.hide()
    div.append(a)
    a.fadeIn()

  replaceMemberArea = ->
    eachMemberAreas (div) ->
      code = div.children('div').data("jobCode")
      a = arcanas[code]
      if onEdit
        replaceArcana(div, renderSummarySizeArcana(a, 'member'))
      else
        replaceArcana(div, renderFullSizeArcana(a))

  replaceChoiceArea = (as) ->
    ul = $('#choice-characters')
    ul.empty()
    for a in as
      li = $("<li class='listed-character col-md-2 col-sm-2'>#{renderSummarySizeArcana(a, 'choice')}</li>")
      li.hide()
      ul.append(li)
      li.fadeIn('slow')
    @

  searchArcanas = (query) ->
    query ?= {}
    query.ver = $("#data-ver").val()
    path = $("#app-path").val() + 'arcanas'

    d = new $.Deferred
    $.getJSON path, query, (datas) ->
      as = []
      for data in datas
        a = new Arcana(data)
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as.push a
      d.resolve(as)
    d.promise()

  searchMembers = (ptm) ->
    query = {}
    query.ver = $("#data-ver").val()
    query.ptm = ptm
    path = $("#app-path").val() + 'ptm'

    $.getJSON path, query, (datas) ->
      eachMembers (m) ->
        div = memberAreaFor(m)
        data = datas[m]
        a = null
        if data
          a = new Arcana(data)
          arcanas[a.jobCode] = a
        replaceArcana(div, renderFullSizeArcana(a))

  buildQuery = ->
    job = $("#job").val()
    rarity = $("#rarity").val()
    return {recently: true}  if (job == '' && rarity == '')

    query = {}
    query.job = job unless job == ''
    query.rarity = rarity unless rarity == ''
    query

  search = ->
    query = buildQuery()
    if query
      promise = searchArcanas(query)
      promise.done (as) ->
        replaceChoiceArea(as)
    else
      replaceChoiceArea([])

  toggleEditMode = ->
    area = $("#edit-area")
    btn = $("#edit-members")

    if onEdit
      onEdit = false
      btn.text("編成を開く")
      area.fadeOut()
    else
      onEdit = true
      btn.text("編成を閉じる")
      area.fadeIn()
      search()
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
    code = 'V' + $("#pt-ver").val()
    eachMemberAreas (area) ->
      c = (area.children('div').data("jobCode") || 'N')
      code = code + c
    code

  initHandler = ->
    $("#edit-area").hide()

    $("#edit-members").on 'click', (e) ->
      toggleEditMode()
      true

    $("#search").on 'click', (e) ->
      search()
      true

    $("#edit-area").on 'click', 'div.choice', (e) ->
      target = $(e.target).parents(".choice")
      code = target.data("jobCode")
      $("#selected").val(code)
      $(".selected").removeClass("selected")
      target.addClass("selected")
      true

    $("#member-area").on 'click', 'div.member', (e) ->
      sel = $("#selected")
      code = sel.val()
      return false if code == ''
      parent = $(e.target).parents('.member-character')
      removeDuplicateMember(code) unless parent.hasClass('friend')
      ra = renderSummarySizeArcana(arcanas[code], 'member')
      replaceArcana(parent, ra)
      sel.val('')
      $(".selected").removeClass("selected")
      true

    $("#member-area").on 'click', 'button.close-member', (e) ->
      member = $(e.target).parents(".member-character")
      clearMemberArcana(member)

    $("#share-modal").on 'show.bs.modal', (e) ->
      code = createMembersCode()
      url = $("#app-path").val() + code
      $("#ptm-code").val(url)
      true

    $("#ptm-code").on 'click forcus', (e) ->
      $(e.target).select()
      true

  initMembers = ->
    ptm = $("#ptm").val()
    if ptm == ''
      eachMemberAreas (div) ->
        replaceArcana(div, renderFullSizeArcana())
    else
      searchMembers(ptm)
    @

$ -> (new Viewer())
