class Arcana

  JOB_NAME = 
    F: '戦'
    K: '騎'
    A: '弓'
    M: '魔'
    P: '僧'

  constructor: (data) ->
    @name = data.name
    @title = data.title
    @rarity = data.rarity
    @job_type = data.job_type
    @job_index = data.job_index

  job_name_for_view: =>
    JOB_NAME[@job_type]

selected = false

init_data = ->
  ul = $("#characters");
  $.getJSON '/datas', {}, (data) ->
    $.each data, (i, d) ->
      a = new Arcana(d)
      li = $('<li class="listed-character"><div class="character">' + a.job_name_for_view() + '・' + a.title + '' + a.name + '</div></li>')
      ul.append(li)
      @

$ ->
  init_data()

  $(document).on 'click touch', 'li.listed-character', (e) ->
    sc = $("#selected-character")
    sc.empty()
    sc.append($(e.target).text())
    selected = true
    @

  $("div.selected-character").on 'click touch', (e) ->
    return false unless selected
    d = $(e.target)
    sc = $("#selected-character")
    d.empty()
    d.append sc.text()
    sc.empty()
    selected = false
    @
