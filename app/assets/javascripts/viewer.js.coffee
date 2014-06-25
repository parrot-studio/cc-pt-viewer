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

class Viewer

  arcanas = {}
  allArcanas = []
  members = ['mem1', 'mem2', 'mem3', 'mem4', 'sub1', 'sub2', 'friend']

  constructor: ->
    promise = searchArcanas()
    promise.done (as) ->
      for a in as
        arcanas[a.jobCode] = a
      allArcanas = as
      renderTargets(as)
      renderMembers()
      initHandler()

  renderArcana = (a) ->
    if a
      div = "<div class='#{a.jobClass} member' data-job-code='#{a.jobCode}'>"
      div += "#{a.rarityStars}(#{a.cost})<br>"
      div += a.title + '<br>'
      div += a.name
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

  renderMembers = ->
    mems = $(".member-character")
    for mem in mems
      m = $(mem)
      replaceArcana(m, m.data("jobCode"))
    @

  searchArcanas = (query) ->
    query ?= {}
    query.ver = $("#data-ver").val()
    path = $("#app-path").val() + 'arcanas'

    d = new $.Deferred
    $.getJSON path, query, (datas) ->
      as = ((new Arcana(data)) for data in datas)
      d.resolve(as)
    d.promise()

  buildQuery = ->
    job = $("#job").val()
    rarity = $("#rarity").val()
    return if (job == '' && rarity == '')

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
      renderTargets(allArcanas)

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

  initHandler = =>
    $(document).on 'click touch', 'div.target', (e) ->
      target = $(e.target)
      code = target.data("jobCode")
      $("#selected").val(code)
      $(".selected").removeClass("selected")
      target.addClass("selected")
      true

    $(document).on 'click touch', 'div.member', (e) ->
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

    $(document).on 'click touch', 'button.close-member', (e) ->
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

$ -> (new Viewer())
