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
    @job_type = data.job_type
    @job_index = data.job_index
    @job_code = data.job_code
    @job_name = JOB_NAME[@job_type]    

class Viewer

  constructor: ->
    @arcanas = []
    @selected = false

    promise = load_arcanas()
    promise.done (as) =>
      @arcanas = as
      render_arcanas(@arcanas)
      init_handler()

  load_arcanas = (query) ->
    d = new $.Deferred
    $.getJSON '/datas', query, (data) ->
      as = []
      $.each data, (i, d) ->
        as.push (new Arcana(d))
      d.resolve(as)
    d.promise()

  render_arcanas = (as) =>
    ul = $("#characters")
    for a in as
      li = $('<li class="listed-character"><div class="character">' + a.job_name + '・' + a.title + '' + a.name + '</div></li>')
      ul.append(li)
    @

  init_handler = =>
    $(document).on 'click touch', 'li.listed-character', (e) =>
      sc = $("#selected-character")
      sc.empty()
      sc.append($(e.target).text())
      @selected = true
      @

    $("div.selected-character").on 'click touch', (e) =>
      return false unless @selected
      d = $(e.target)
      sc = $("#selected-character")
      d.empty()
      d.append sc.text()
      sc.empty()
      @selected = false
      @

$ -> (new Viewer())
