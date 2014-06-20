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

  constructor: ->
    @arcanas = {}
    @selected = false

    promise = loadArcanas()
    promise.done (as) =>
      for a in as
        @arcanas[a.jobCode] = a
      renderTargets(as)
      renderMembers(@arcanas)
      initHandler()

  loadArcanas = (query) ->
    d = new $.Deferred
    $.getJSON '/datas', query, (datas) ->
      as = []
      for data in datas
        as.push (new Arcana(data))
      d.resolve(as)
    d.promise()

  renderArcana = (a) ->
    if a
      '<div class="character">' + a.jobName + '・' + a.title + '' + a.name + '</div>'
    else
      '<div class="character"></div>'

  renderTargets = (as) ->
    ul = $("#target-characters")
    ul.empty()
    for a in as
      li = '<li class="listed-character">' + renderArcana(a) + '</li>'
      ul.append(li)
    @

  renderMembers = (ah) ->
    mems = $(".member")
    for mem in mems
      m = $(mem)
      code = m.data("jobCode")
      block = renderArcana(ah[code])
      m.empty()
      m.append(block)
    @

  initHandler = =>
    $(document).on 'click touch', 'li.listed-character', (e) =>
      sc = $("#selected-character")
      sc.empty()
      sc.append($(e.target).text())
      @selected = true
      @

    $("div.member").on 'click touch', (e) =>
      return false unless @selected
      d = $(e.target)
      sc = $("#selected-character")
      d.empty()
      d.append sc.text()
      sc.empty()
      @selected = false
      @

$ -> (new Viewer())
