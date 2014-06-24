class Arcana

  JOB_NAME =
    F: '戦士'
    K: '騎士'
    A: '弓使い'
    M: '魔法使い'
    P: '僧侶'

  constructor: (data) ->
    @name = data.name
    @title = data.title
    @rarity = data.rarity
    @jobType = data.job_type
    @jobIndex = data.job_index
    @jobCode = data.job_code
    @jobName = JOB_NAME[@jobType]

class Viewer

  arcanas = {}
  allArcanas = []
  selected = null
  data_path = '/arcanas'
  members = ['mem1', 'mem2', 'mem3', 'mem4', 'sub1', 'sub2']

  constructor: ->
    promise = loadArcanas(data_path)
    promise.done (as) ->
      for a in as
        arcanas[a.jobCode] = a
      allArcanas = as
      renderTargets(as)
      renderMembers()
      initHandler()

  renderArcana = (a) ->
    if a
      '<div class="character" data-job-code="' + a.jobCode + '">' + a.jobName + '・' + a.title + '' + a.name + '</div>'
    else
      '<div class="character"></div>'

  renderTargets = (as) ->
    ul = $("#target-characters")
    ul.empty()
    for a in as
      li = '<li class="listed-character">' + renderArcana(a) + '</li>'
      ul.append(li)
    @

  replaceArcana = (div, code) ->
    div.empty()
    div.append(renderArcana(arcanas[code]))
  @

  renderMembers = ->
    mems = $(".member")
    for mem in mems
      m = $(mem)
      replaceArcana(m, m.data("jobCode"))
    @

  loadArcanas = (path, query) ->
    query ?= {}
    query.ver = $("#data-ver").val()

    d = new $.Deferred
    $.getJSON path, query, (datas) ->
      as = ((new Arcana(data)) for data in datas)
      d.resolve(as)
    d.promise()

  searchArcanas = (query) ->
    loadArcanas(data_path, query)

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
      parent = $('#selected-character-' + m)
      func($(parent).children('div'))

  create_pt_code = ->
    code = 'V' + $("#data-ver").val()
    each_pt_members (ptm)->
      c = ($(ptm).data("jobCode") || 'N')
      code = code + c
    code

  initHandler = =>
    $(document).on 'click touch', 'li.listed-character', (e) ->
      code = $(e.target).data("jobCode")
      replaceArcana($("#selected-character"), code)
      selected = code
      true

    $("div.member").on 'click touch', (e) ->
      return false unless selected?
      replaceArcana($(e.target).parent(), selected)
      $("#selected-character").empty()
      selected = null
      true

    $("#search").on 'click touch', (e) ->
      search()
      true

    $("#create-code").on  'click touch', (e) ->
      code = create_pt_code()
      url = $("#pt-path").val() + code
      $("#code").val(url)
      true

$ -> (new Viewer())
