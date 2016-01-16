class @DatabaseView

  recentlySize = 16
  pagerSize = 8

  $arcanaTable = $("#arcana-table")

  @init: -> new DatabaseView()

  constructor: ->
    CommonView.init()
    CommonView.showLatestInfo()

    pagerSize = (if CommonView.isPhoneDevice() then 8 else 16)
    recentlySize = (if CommonView.isPhoneDevice() then 16 else 32)

    $arcanaTable.children("thead").append(renderTableHeader())

    view = new ArcanasView(pagerSize: pagerSize, recentlySize: recentlySize)
    view.targetArcanas.onValue (as) -> replaceTableArea(as)

    $("#share-query-modal")
      .asEventStream('show.bs.modal')
      .map -> QueryLogs.lastQuery?.encode()
      .map (qs) ->
        path = "db"
        path += "?#{qs}" unless _.isEmpty(qs)
        path
      .doAction ->
        $("#share-url-form").hide() if CommonView.isPhoneDevice()
      .onValue (path) -> view.setTwitterShare(path)

    if CommonView.isPhoneDevice()
      $arcanaTable.swipe (
        swipeLeft: (e) ->
          $('.pager-prev').click()
          e.preventDefault()
        swipeRight: (e) ->
          $('.pager-next').click()
          e.preventDefault()
      )

    sortTitleStream = $arcanaTable
      .asEventStream('click', 'th.sortable')
      .doAction('.preventDefault')
      .map (e) -> $(e.target)

    sortButtonStream = $arcanaTable
      .asEventStream('click', 'button.sortable')
      .doAction('.stopPropagation')
      .map (e) -> $(e.target).parents('th')

    sortColumnStream = sortTitleStream.merge(sortButtonStream)
      .map (target) -> target.data('colName')
      .filter (col) -> !_.isEmpty(col)

    view.sortColumn.plug sortColumnStream

    view.sortOrderState.onValue (state) -> renderOrderState(state)

  replaceTableArea = (as) ->
    $arcanaTable.hide()
    tbody = $arcanaTable.children("tbody")
    tbody.empty()

    _.forEach as, (a) ->
      tr = renderTableArcana(a)
      tbody.append(tr)
    $arcanaTable.fadeIn('slow')
    @

  renderTableHeader = ->
    tr = "
      <tr>
        <th class='sortable' data-col-name='name'>名前
          <button class='btn btn-default btn-xs sortable' type='button'>
            <i class='fa fa-sort'></i>
          </button>
        </th>
        <th>職</th>
        <th>★</th>
    "
    unless CommonView.isPhoneDevice()
      tr += "
        <th class='sortable' data-col-name='cost'>コスト
          <button class='btn btn-default btn-xs sortable' type='button'>
            <i class='fa fa-sort'></i>
          </button>
        </th>
        <th>武器</th>
        <th class='sortable' data-col-name='maxAtk'>最大ATK
          <button class='btn btn-default btn-xs sortable' type='button'>
            <i class='fa fa-sort'></i>
          </button>
        </th>
        <th class='sortable' data-col-name='maxHp'>最大HP
          <button class='btn btn-default btn-xs sortable' type='button'>
            <i class='fa fa-sort'></i>
          </button>
        </th>
        <th class='sortable' data-col-name='limitAtk'>限界ATK
          <button class='btn btn-default btn-xs sortable' type='button'>
            <i class='fa fa-sort'></i>
          </button>
        </th>
        <th class='sortable' data-col-name='limitHp'>限界HP
          <button class='btn btn-default btn-xs sortable' type='button'>
            <i class='fa fa-sort'></i>
          </button>
        </th>
        <th>所属</th>
      "
    tr += "</tr>"
    tr

  renderTableArcana = (a) ->
    return unless a
    phone = CommonView.isPhoneDevice()

    tr = "
      <tr>
        <td class='arcana-header '>
          <div class='#{a.jobClass}'>
    "
    if phone
      tr += "<span class='badge badge-sm pull-right'>#{a.cost} ( #{a.chainCost} )</span>"
    tr += "
            <span class='text-muted small'>#{a.title}</span><br>
            <a href='#' class='view-info' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>#{a.name}</button>
          </div>
        </td>
        <td>#{a.jobNameShort}</td>
        <td>★#{a.rarity}</td>
    "
    unless phone
      tr += "
        <td>#{a.cost} ( #{a.chainCost} )</td>
        <td>#{a.weaponName}</td>
        <td>#{a.maxAtk}</td>
        <td>#{a.maxHp}</td>
        <td>#{a.limitAtk}</td>
        <td>#{a.limitHp}</td>
        <td>#{a.union}</td>
      "
    tr += "</tr>"
    tr

  renderOrderState = (state) ->
    _.forEach $("th.sortable"), (c) ->
      col = $(c)
      name = col.data('colName')
      order = state[name] || ''
      icon = col.children('button').children('i.fa')

      switch order
        when 'desc'
          icon.removeClass('fa-sort')
          icon.removeClass('fa-sort-amount-asc')
          icon.addClass('fa-sort-amount-desc')
          icon.addClass('active')
        when 'asc'
          icon.removeClass('fa-sort')
          icon.removeClass('fa-sort-amount-desc')
          icon.addClass('fa-sort-amount-asc ')
          icon.addClass('active')
        else
          icon.removeClass('fa-sort-amount-desc')
          icon.removeClass('fa-sort-amount-asc')
          icon.removeClass('active')
          icon.addClass('fa-sort')
