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
  selected = false

  constructor: ->
    promise = loadArcanas()
    promise.done (as) =>
      for a in as
        arcanas[a.jobCode] = a
      renderTargets(as)
      renderMembers()
      initHandler()

  loadArcanas = (query) ->
    d = new $.Deferred
    $.getJSON '/datas', query, (datas) ->
      as = ((new Arcana(data)) for data in datas)
      d.resolve(as)
    d.promise()

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
    a = arcanas[code]
    div.empty()
    div.append(renderArcana(arcanas[code]))
  @

  renderMembers = =>
    mems = $(".member")
    for mem in mems
      m = $(mem)
      replaceArcana(m, m.data("jobCode"))
    @

  initHandler = =>
    $(document).on 'click touch', 'li.listed-character', (e) =>
      code = $(e.target).data("jobCode")
      replaceArcana($("#selected-character"), code)
      selected = code
      @

    $("div.member").on 'click touch', (e) =>
      return false unless selected?
      replaceArcana($(e.target), selected)
      $("#selected-character").empty()
      selected = null
      @

$ -> (new Viewer())
