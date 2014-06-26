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
    $("#edit-area").hide()
    initHandler()
    initMembers()

  renderArcana = (a) ->
    if a
      div = "<div class='#{a.jobClass} member' data-job-code='#{a.jobCode}'>"
      div += "#{a.rarityStars}(#{a.cost})<br>"
      div += a.title + '<br>'
      div += a.name + '<br>'
      div += a.weaponName
      div += '</div>'
      div += '<button type="button" class="close close-member" aria-hidden="true">&times;</button>'
      div
    else
      "<div class='none member'></div>"

  renderArcanaSummary = (a) ->
    if a
      div = "<div class='#{a.jobClass} target' data-job-code='#{a.jobCode}'>"
      div += "#{a.rarityStars}(#{a.cost})<br>"
      div += a.title + '<br>'
      div += a.name
      div += '</div>'
      div
    else
      "<div class='none target'></div>"

  renderTargets = (as) ->
    ul = $('#target-characters')
    ul.empty()
    for a in as
      li = $("<li class='listed-character col-md-2 col-sm-2'>#{renderArcanaSummary(a)}</li>")
      li.hide()
      ul.append(li)
      li.fadeIn('slow')
    @

  replaceArcana = (div, code) ->
    div.empty()
    a = $(renderArcana(arcanas[code]))
    a.hide()
    div.append(a)
    a.fadeIn()
  @

  clearArcana = (div) ->
    replaceArcana(div)

  initMembers = ->
    ptm = $("#ptm").val()
    mems = ($(m) for m in $(".member-character"))  

    if ptm == ''
      clearArcana(m) for m in mems
      return

    promise = searchArcanas({ptm: ptm})
    promise.done (as) ->
      for m in mems
        replaceArcana(m, m.data("jobCode"))
      $("button.close-member").hide() unless onEdit
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
        renderTargets(as)
    else
      renderTargets([])

  eachMembers = (func) ->
    for m in members
      func($("#member-character-#{m}").children('div'))

  createMembersCode = ->
    code = 'V' + $("#pt-ver").val()
    eachMembers (ptm) ->
      c = ($(ptm).data("jobCode") || 'N')
      code = code + c
    code

  removeDuplicateMember = (code) ->
    mems = $(".member")
    for m in mems
      mem = $(m)
      parent = mem.parent()
      continue if parent.hasClass('friend')
      c = mem.data("jobCode")
      continue unless c == code
      clearArcana(parent)
    @

  toggleEditArea = ->
    area = $("#edit-area")
    btn = $("#edit-members")
    close = $("button.close-member")

    if onEdit
      close.hide()
      area.fadeOut()
      btn.text("編成を開く")
      onEdit = false
    else
      close.show()
      area.fadeIn()
      btn.text("編成を閉じる")
      onEdit = true
      search()
    @

  initHandler = =>
    $("#edit-area").on 'click touch', 'div.target', (e) ->
      target = $(e.target)
      code = target.data("jobCode")
      $("#selected").val(code)
      $(".selected").removeClass("selected")
      target.addClass("selected")
      true

    $("#member-area").on 'click touch', 'div.member', (e) ->
      sel = $("#selected")
      code = sel.val()
      return false if code == ''
      parent = $(e.target).parent()
      removeDuplicateMember(code) unless parent.hasClass('friend')
      replaceArcana(parent, code)
      sel.val('')
      $(".selected").removeClass("selected")
      true

    $("#search").on 'click touch', (e) ->
      search()
      true

    $("#member-area").on 'click touch', 'button.close-member', (e) ->
      member = $(e.target).parent()
      clearArcana(member)

    $("#share-modal").on 'show.bs.modal', (e) ->
      code = createMembersCode()
      url = $("#app-path").val() + code
      $("#code").val(url)
      true

    $("#code").on 'click touch forcus', (e) ->
      $(e.target).select()
      true

    $("#edit-members").on 'click touch', (e) ->
      toggleEditArea()
      true

$ -> (new Viewer())
