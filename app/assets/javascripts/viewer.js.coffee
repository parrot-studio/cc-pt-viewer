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
  members = ['mem1', 'mem2', 'mem3', 'mem4', 'sub1', 'sub2']

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

  each_pt_members = (func) ->
    for m in members
      func($("#member-character-#{m}").children('div'))

  create_pt_code = ->
    code = 'V' + $("#pt-ver").val()
    each_pt_members (ptm)->
      c = ($(ptm).data("jobCode") || 'N')
      code = code + c
    code

  initHandler = =>
    $(document).on 'click touch', 'li.listed-character', (e) ->
      target = $(e.target)
      code = target.data("jobCode")
      $("#selected").val(code)
      $(".selected").removeClass("selected")
      target.addClass('selected')
      true

    $("div.member-character").on 'click touch', (e) ->
      sel = $("#selected")
      code = sel.val()
      return false if code == ''
      replaceArcana($(e.target).parent(), code)
      sel.val('')
      $(".selected").removeClass("selected")
      true

    $("#search").on 'click touch', (e) ->
      search()
      true

    $("#create-code").on  'click touch', (e) ->
      code = create_pt_code()
      url = $("#app-path").val() + 'pt/' + code
      $("#code").val(url)
      true

$ -> (new Viewer())
