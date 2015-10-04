class Viewer

  members = {}
  memberKeys = ['mem1', 'mem2', 'mem3', 'mem4', 'sub1', 'sub2', 'friend']
  pager = null
  pagerSize = null
  onEdit = true
  recentlySize = 36
  defaultMemberCode = 'V2F82F85K51NA38NP28NP24NNNNN'
  mode = null
  lastQuery = null
  querys = []
  queryLogSize = 12
  favs = {}
  sortOrderDefault = {name: 'asc'}
  sortOrder = {}
  parties = []
  ptSize = 10

  constructor: ->
    mode = $("#mode").val() || ''

    if mode is 'database'
      pagerSize = (if isPhoneDevice() then 8 else 16)
      recentlySize = (if isPhoneDevice() then 16 else 32)

      promise = initDatabaseHandler()
      promise.then ->
        query = Query.parse()
        if query.isEmpty()
          searchRecentlyTargets()
        else
          searchTargets(query)
          setConditions(query)
    else if mode is 'ptedit'
      pagerSize = 8
      initEditHandler()

      ptm = $("#ptm").val() || ''
      if isPhoneDevice()
        toggleEditMode()
      else
        toggleEditMode() unless ptm is ''
        searchRecentlyTargets()
      if ptm is ''
        searchLastMembers()
      else
        buildMembersArea(ptm)
    else
      commonHandler()

  isPhoneDevice = ->
    if window.innerWidth < 768 then true else false

  createPager = (list, size) ->
    s = size || pagerSize
    new Pager(list, s)

  eachMemberKey = (func) ->
    for m in memberKeys
      func(m)

  eachMember = (func) ->
    eachMemberKey (k) ->
      func(members[k])

  eachMemberOnly = (func) ->
    eachMemberKey (k) ->
      func(members[k]) unless k is 'friend'

  memberFor = (k) ->
    members[k]

  setMember = (k, m) ->
    m.memberKey = k if m
    members[k] = m
    m

  removeMember = (k) ->
    members[k] = null

  memberAreaFor = (m) ->
    $("#member-character-#{m}")

  memberKeyFromArea = (div) ->
    div.attr('id').replace('member-character-', '')

  collectFavriteList = ->
    fl = []
    for code, state of favs
      fl.push code if state
    fl.sort()
    fl

  renderArcanaCost = (m) ->
    render = "#{m.arcana.cost}"
    if m.chainArcana
      render += " + #{m.chainArcana.chainCost}"
    render

  renderChainAbility = (m, cl) ->
    return '' unless m

    if (cl is 'member' || cl is 'chain' || cl is 'full')
      c = m.chainArcana
      if c
        render = ''
        render += if cl is 'member'
          "
            <button type='button' class='close close-chain'>&times;</button>
            <a href='#' data-job-code='#{c.jobCode}' data-toggle='modal' data-target='#view-modal'>#{c.name}</a>
          "
        else if cl is 'full'
          "<a href='#' data-job-code='#{c.jobCode}' data-toggle='modal' data-target='#view-modal'>#{c.name}</a>"
        else
          "<span class='chained-ability'>#{c.name}</span>"
        render += ' / '
        render += if m.canUseChainAbility()
          "<span class='chained-ability'>#{c.chainAbility.name}</span>"
        else
          "<s>#{c.chainAbility.name}</s>"
        render
      else
        "（#{m.arcana.chainAbility.name}）"
    else
      m.arcana.chainAbility.name

  renderSkill = (sk) ->
    render = "
    #{sk.name} (#{sk.cost})<br>
    <ul class='small list-unstyled ability-detail'>"
    for ef, i in sk.effects
      multi = if ef.multi_type is 'forward'
        ' => '
      else if ef.multi_type is 'either'
        ' または '
      else
        ''

      unless ef.multi_condition is ''
        multi = "（#{multi} #{ef.multi_condition}）"

      render += "<li>#{multi}#{ef.category} - #{ef.subcategory}"
      li = []
      for e in Skill.subeffectForEffect(ef)
        li.push e
      unless ef.note is ''
        li.push ef.note
      if li.length > 0
        render += " ( #{li.join(' / ')} )"
      render += '</li>'
    render += "</ul>"
    render

  renderAbility = (ab) ->
    return "なし" if ab.name == ''

    render = "#{ab.name}<ul class='small list-unstyled ability-detail'>"
    for e in ab.effects
      str = "#{e.condition} - #{e.effect}"
      unless e.target is ''
        str += ":#{e.target}"
      unless e.note is ''
        str += " (#{e.note})"
      render += "<li>#{str}</li>"
    render += "</ul>"
    render

  renderFullSizeArcana = (m) ->
    return renderSummarySizeArcana(m, 'full') if isPhoneDevice()

    if m
      a = m.arcana

      "
        <div class='#{a.jobClass} full-size arcana' data-job-code='#{a.jobCode}'>
          <div class='#{a.jobClass}-title arcana-title small'>
            #{a.jobNameShort} : #{a.rarityStars}
            <span class='badge pull-right'>#{renderArcanaCost(m)}</span>
          </div>
          <div class='arcana-body'>
            <p class='arcana-name'>
                <button type='button' class='btn btn-default btn-xs view-info pull-right' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>Info</button>
                <span class='text-muted small'>#{a.title}</span><br>
                <strong>#{a.name}</strong>
            </p>
            <dl class='small text-muted arcana-detail'>
              <dt>ATK / HP</dt>
              <dd> #{a.maxAtk} (#{a.limitAtk}) / #{a.maxHp} (#{a.limitHp})</dd>
              <dt>Skill</dt>
              <dd>#{a.skill.name} (#{a.skill.cost})</dd>
              <dt>Ability</dt>
              <dd>
                <ul class='list-unstyled'>
                  <li>#{if a.firstAbility.name != '' then a.firstAbility.name else 'なし'}</li>
                  <li>#{if a.secondAbility.name != '' then a.secondAbility.name else 'なし'}</li>
                </ul>
              </dd>
              <dt class='chain-ability-name'>ChainAbility</dt>
              <dd class='small'>#{renderChainAbility(m, 'full')}</dd>
            </dl>
          </div>
          <div class='#{a.jobClass}-footer arcana-footer'>
          </div>
        </div>
      "
    else
      "<div class='none full-size arcana'></div>"

  renderChoiceArcana = (a) ->
    if a
      div = "
        <div class='#{a.jobClass} choice summary-size arcana' data-job-code='#{a.jobCode}'>
          <div class='#{a.jobClass}-title arcana-title small'>
            #{a.jobNameShort}:#{a.rarityStars} <span class='badge badge-sm pull-right'>#{a.cost} ( #{a.chainCost} )</span>
          </div>
          <div class='arcana-summary'>
            <p style='margin-top: -8px'>
              <small>
                <div class='pull-right mini'>
                  <input type='checkbox' id='fav-#{a.jobCode}' class='' data-job-code='#{a.jobCode}'>
                  <button type='button' class='btn btn-default btn-xs view-info' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>Info</button>
                </div>
                <div class='pull-left'>
                  <span class='text-muted small'>#{a.title}</span><br>
                  <strong>#{a.name}</strong>
                </div>
              </small>
            </p>
            <p class='clearfix'></p>
            <p>
              <small>
                <ul class='small text-muted list-unstyled summary-detail'>
                  <li>#{a.maxAtk} / #{a.maxHp}</li>
                  <li>#{a.skill.name} (#{a.skill.cost})</li>
                  <li>#{if a.firstAbility.name != '' then a.firstAbility.name else 'なし'}<br>#{if a.secondAbility.name != '' then a.secondAbility.name else 'なし'}</li>
                  <li class='chain-ability-name'>（#{a.chainAbility.name}）</li>
                </ul>
              </small>
            </p>
          </div>
        </div>
      "
      d = setDraggable(div)
    else
      d = $("<div class='none #{cl} summary-size arcana'></div>")
    d

  renderSummarySizeArcana = (m, cl) ->
    if m
      a = m.arcana

      div = "
        <div class='#{a.jobClass} #{cl} summary-size arcana' data-job-code='#{a.jobCode}'>
          <div class='#{a.jobClass}-title arcana-title small'>
            #{a.jobNameShort}:#{a.rarityStars} <span class='badge badge-sm pull-right'>#{renderArcanaCost(m)}</span>
          </div>
          <div class='arcana-summary'>
            <p>
              <small>
                <button type='button' class='btn btn-default btn-xs view-info pull-right' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>Info</button>
                <span class='text-muted small'>#{a.title}</span><br>
                <strong>#{a.name}</strong>
              </small>
            </p>
            <p>
              <small>
                <ul class='small text-muted list-unstyled summary-detail'>
                  <li>#{a.maxAtk} / #{a.maxHp}</li>
                  <li>#{a.skill.name} (#{a.skill.cost})</li>
                  <li>#{if a.firstAbility.name != '' then a.firstAbility.name else 'なし'}<br>#{if a.secondAbility.name != '' then a.secondAbility.name else 'なし'}</li>
                  <li class='chain-ability-name'>#{renderChainAbility(m, cl)}</li>
                </ul>
              </small>
            </p>
          </div>
      "
      if cl is 'member'
        div += '<button type="button" class="close close-member" aria-hidden="true">&times;</button>'
      div += '</div>'
      div
      return div if (cl is 'chain' || cl is 'full')

      d = setDraggable(div)
    else
      d = $("<div class='none #{cl} summary-size arcana'></div>")
    d

  setDraggable = (div) ->
    d = $(div)
    d.draggable(
      connectToSortable: false
      containment: false
      helper: 'clone'
      opacity: 0.7
      zIndex: 10000
      start: ->
        $("#search-area").hide()
        $("#help-area").show()
      stop: ->
        $("#search-area").show()
        $("#help-area").hide()
    )
    d

  renderSummarySizeMember = (m) ->
    renderSummarySizeArcana(m, 'member')

  renderArcanaDetail = (a) ->
    return '' unless a

    "
      <div class='#{a.jobClass} arcana'>
        <div class='#{a.jobClass}-title arcana-title'>
          #{a.jobName} : #{a.rarityStars}
          <span class='badge pull-right'>#{a.cost} ( #{a.chainCost} )</span>
        </div>
        <div class='arcana-view-body'>
          <h4 class='arcana-name' id='view-modal-label'>
            <span class='text-muted'>#{a.title}</span>
            <strong>#{a.name}</strong>
          </h4>
          <div class='row'>
            <div class='col-xs-12 hidden-sm hidden-md hidden-lg'>
              <p class='pull-right'>
                <input type='checkbox' class='fav-detail' data-job-code='#{a.jobCode}'>
              </p>
            </div>
            <div class='col-xs-12 col-sm-4 col-md-4'>
              <dl class='small arcana-view-detail'>
                <dt>職業</dt>
                <dd>#{a.jobDetail}</dd>
                <dt>ATK / HP</dt>
                <dd> #{a.maxAtk} / #{a.maxHp}<br>( #{a.limitAtk} / #{a.limitHp} )</dd>
                <dt>武器タイプ</dt>
                <dd>#{a.weaponName}</dd>
                <dt>所属</dt>
                <dd>#{a.union}</dd>
                <dt>声優</dt>
                <dd>#{a.voiceActor}</dd>
                <dt>イラストレーター</dt>
                <dd>#{a.illustrator}</dd>
                <dt>入手先</dt>
                <dd>#{a.sourceCategory} - #{a.source}</dd>
              </dl>
            </div>
            <div class='col-xs-12 col-sm-8 col-md-8'>
              <dl class='small arcana-view-detail'>
                <dt>スキル</dt>
                <dd>#{renderSkill(a.skill)}</dd>
                <dt>アビリティ1</dt>
                <dd>#{renderAbility(a.firstAbility)}</dd>
                <dt>アビリティ2</dt>
                <dd>#{renderAbility(a.secondAbility)}</dd>
                <dt>絆アビリティ</dt>
                <dd>#{renderAbility(a.chainAbility)}</dd>
              </dl>
            </div>
            <div class='col-xs-12 col-sm-12 col-md-12'>
              <p class='pull-left'>
                <button type='button' class='btn btn-default btn-sm wiki-link' data-job-code='#{a.jobCode}'>Wikiで確認</button>
              </p>
              <p class='pull-right hidden-xs'>
                <input type='checkbox' class='fav-detail' data-job-code='#{a.jobCode}'>
              </p>
            </div>
          </div>
        </div>
      </div>
    "

  renderTableHeader = ->
    tr = "
      <tr>
        <th class='sortable' data-col-name='name'>名前
          <button class='btn btn-default btn-xs sortable' type='button'>
            <span class='glyphicon glyphicon-sort' aria-hidden='true'></span>
          </button>
        </th>
        <th>職</th>
        <th>★</th>
    "
    unless isPhoneDevice()
      tr += "
        <th class='sortable' data-col-name='cost'>コスト
          <button class='btn btn-default btn-xs sortable' type='button'>
            <span class='glyphicon glyphicon-sort' aria-hidden='true'></span>
          </button>
        </th>
        <th>武器</th>
        <th class='sortable' data-col-name='maxAtk'>最大ATK
          <button class='btn btn-default btn-xs sortable' type='button'>
            <span class='glyphicon glyphicon-sort' aria-hidden='true'></span>
          </button>
        </th>
        <th class='sortable' data-col-name='maxHp'>最大HP
          <button class='btn btn-default btn-xs sortable' type='button'>
            <span class='glyphicon glyphicon-sort' aria-hidden='true'></span>
          </button>
        </th>
        <th class='sortable' data-col-name='limitAtk'>限界ATK
          <button class='btn btn-default btn-xs sortable' type='button'>
            <span class='glyphicon glyphicon-sort' aria-hidden='true'></span>
          </button>
        </th>
        <th class='sortable' data-col-name='limitHp'>限界HP
          <button class='btn btn-default btn-xs sortable' type='button'>
            <span class='glyphicon glyphicon-sort' aria-hidden='true'></span>
          </button>
        </th>
        <th>所属</th>
      "
    tr += "</tr>"
    tr

  renderTableArcana = (a) ->
    return unless a

    tr = "
      <tr>
        <td class='arcana-header '>
          <div class='#{a.jobClass}'>
    "
    if isPhoneDevice()
      tr += "<span class='badge badge-sm pull-right'>#{a.cost} ( #{a.chainCost} )</span>"
    tr += "
            <span class='text-muted small'>#{a.title}</span><br>
            <a href='#' class='view-info' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>#{a.name}</button>
          </div>
        </td>
        <td>#{a.jobNameShort}</td>
        <td>★#{a.rarity}</td>
    "
    unless isPhoneDevice()
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

  renderPager = ->
    pager ||= createPager([])
    prev = $('.pager-prev')
    next = $('.pager-next')
    $('.each-page').remove()

    if pager.hasPrevPage()
      prev.removeClass('disabled')
    else
      prev.addClass('disabled')

    if isPhoneDevice()
      $('.pagination').addClass('pagination-sm')
      body = 3
      edge = 1
    else
      body = 5
      edge = 2

    list = if pager.maxPage <= (body + edge * 2 + 2)
      [1 .. pager.maxPage]
    else
      switch
        when pager.page <= (edge + (body+1)/2)
          li = [1 .. (body + edge)]
          li.push '..'
          li = li.concat [(pager.maxPage - edge + 1) .. pager.maxPage]
          li
        when pager.page >= (pager.maxPage - (edge + (body+1)/2) + 1)
          li = [1 .. edge]
          li.push '..'
          li = li.concat [(pager.maxPage-(body + edge)+1) .. pager.maxPage]
          li
        else
          li = [1 .. edge]
          li.push '..'
          li = li.concat [(pager.page - edge) .. (pager.page + edge)]
          li.push '..'
          li = li.concat [(pager.maxPage - edge + 1) .. pager.maxPage]
          li

    for p in list
      pa = $("<li class='each-page'><span data-page='#{p}'>#{p}</span></li>")
      if p is '..'
        pa.addClass('disable')
      else if p == pager.page
        pa.addClass('active')
      else
        pa.children('span').addClass('jump-page')
      next.before(pa)

    if pager.hasNextPage()
      next.removeClass('disabled')
    else
      next.addClass('disabled')

    count = $('.pager-count')
    count.empty()
    if pager.size > 0
      count.append("（#{pager.head() + 1} - #{pager.tail() + 1} / #{pager.size}件）")
    else
      count.append("（0件）")
    @

  renderMemberArcana = (k) ->
    div = memberAreaFor(k)
    div.empty()
    mem = members[k]
    render = if onEdit
      r = $(renderSummarySizeMember(mem))
      r.attr('data-parent-key', k)
      r
    else
      $(renderFullSizeArcana(mem))
    render.hide()
    div.append(render)
    render.fadeIn()

  renderOrderState = ->
    $(".sortable").map ->
      col = $(this)
      name = col.data('colName')
      order = sortOrder[name] || ''
      span = col.children('button').children('span')

      switch order
        when 'desc'
          span.removeClass('glyphicon-sort')
          span.removeClass('glyphicon-sort-by-attributes')
          span.addClass('glyphicon-sort-by-attributes-alt')
          span.addClass('active')
        when 'asc'
          span.removeClass('glyphicon-sort')
          span.removeClass('glyphicon-sort-by-attributes-alt')
          span.addClass('glyphicon-sort-by-attributes')
          span.addClass('active')
        else
          span.removeClass('glyphicon-sort-by-attributes-alt')
          span.removeClass('glyphicon-sort-by-attributes')
          span.removeClass('active')
          span.addClass('glyphicon-sort')

  reloadMemberAreas = ->
    eachMemberKey (k) ->
      renderMemberArcana(k)

  replaceTargetArea = ->
    if mode is 'database'
      replaceTableArea()
    else
      replaceChoiceArea()

  replaceChoiceArea = ->
    as = pager?.get() || []
    ul = $('#choice-characters')
    ul.empty()
    for a in as
      li = $("<li class='listed-character col-sm-3 col-md-3 col-xs-6'></li>")
      li.html(renderChoiceArcana(a))
      li.hide()
      ul.append(li)

      $("#fav-#{a.jobCode}").bootstrapSwitch({
        state: favs[a.jobCode]
        size: 'mini'
        onColor: 'warning'
        onText: '☆'
        offText: '★'
        labelWidth: '2'
        onSwitchChange: (e, state) ->
          target = $(e.target)
          toggleFavoriteArcana(target.data('jobCode'), state)
      })

      li.fadeIn('slow')
    renderPager()
    @

  replaceTableArea = ->
    as = pager?.get() || []
    tbody = $('#table-body')
    tbody.empty()
    tbody.append(renderTableHeader())

    for a in as
      tr = renderTableArcana(a)
      tbody.append(tr)
    renderPager()
    renderOrderState()
    @

  replaceTargetAreaForFavorite = ->
    as = []
    for c in collectFavriteList()
      as.push Searcher.forCode(c)
    $(".search-detail").text('お気に入り')
    pager = createPager(as)
    replaceTargetArea()

  buildMembersArea = (ptm) ->
    Searcher.searchMembers ptm, (as) ->
      eachMemberKey (k) ->
        mb = as[k]
        mc = as[k + 'c']
        if mb
          mem = new Member(mb)
          mem.chainArcana = mc if mc
          setMember(k, mem)
        else
          setMember(k, null)
        renderMemberArcana(k)
      calcCost()

  resetConditions = ->
    $("#job").val('')
    $("#rarity").val('')
    $("#weapon").val('')
    $("#actor").val('')
    $("#illustrator").val('')
    $("#union").val('')
    $("#source-category").val('')
    $("#source").empty().append("<option value=''>-</option>")
    $("#skill").val('')
    $("#skill-cost").val('')
    $("#skill-sub").empty().append("<option value=''>-</option>")
    $("#skill-effect").empty().append("<option value=''>-</option>")
    $("#ability-category").val('')
    $("#ability-effect").empty().append("<option value=''>-</option>")
    $("#chain-ability-category").val('')
    $("#chain-ability-effect").empty().append("<option value=''>-</option>")
    $("#arcana-cost").val('')
    $("#chain-cost").val('')

    $("#additional-condition").hide()
    $("#skill-add").hide()
    $("#add-condition").show()
    @

  setConditions = (q) ->
    return unless q
    resetConditions()
    query = q.params()

    if query.job
      $("#job").val(query.job)
    if query.rarity
      $("#rarity").val(query.rarity)
    if query.weapon
      $("#weapon").val(query.weapon)
    if query.union
      $("#union").val(query.union)
    if query.arcanacost
      $("#arcana-cost").val(query.arcanacost)
    if query.chaincost
      $("#chain-cost").val(query.chaincost)
    if query.sourcecategory
      $("#source-category").val(query.sourcecategory)
      createSourceOptions()
      if query.source
        $("#source").val(query.source)

    add = false
    if query.actor
      $("#actor").val(query.actor)
      add = true
    if query.actorname
      id = getSelectboxValue(query.actorname)
      $("#actor").val(id)
      add = true
    if query.illustrator
      $("#illustrator").val(query.illustrator)
      add = true
    if query.illustratorname
      id = getSelectboxValue(query.illustratorname)
      $("#illustrator").val(id)
      add = true
    if query.skillcost
      add = true
      $("#skill-cost").val(query.skillcost)
    if query.skill
      add = true
      $("#skill").val(query.skill)
      createSkillOptions()
      $("#skill-add").show()
      if query.skillsub
        $("#skill-sub").val(query.skillsub)
      if query.skilleffect
        $("#skill-effect").val(query.skilleffect)
    if query.abilitycategory
      add = true
      $("#ability-category").val(query.abilitycategory)
      createAbilityEffects()
      if query.abilityeffect
        $("#ability-effect").val(query.abilityeffect)
    if query.chainabilitycategory
      add = true
      $("#chain-ability-category").val(query.chainabilitycategory)
      createChainAbilityEffects()
      if query.chainabilityeffect
        $("#chain-ability-effect").val(query.chainabilityeffect)

    if add
      $("#additional-condition").show()
      $("#add-condition").hide()
    @

  addQueryLog = (q) ->
    lastQuery = q
    return if q.isQueryForRecently()
    nl = [q]
    eq = q.encode()
    cs = []
    cs.push {query: eq, detail: q.detail}
    for oq in querys
      break if nl.length == queryLogSize
      oqe = oq.encode()
      continue if (eq is oqe)
      nl.push oq
      cs.push {query: oqe, detail: oq.detail}
    querys = nl
    Cookie.set({'query-log': cs})
    q

  initQueryLog = ->
    querys = []
    try
      cs = Cookie.valueFor('query-log')
      return unless cs

      for c in cs
        q = Query.parse(c.query)
        q.detail = c.detail
        querys.push(q) if q
    catch
      querys = []
    @

  clearQueryLog = ->
    lastQuery = null
    querys = []
    Cookie.delete('query-log')
    renderQueryLog()

  renderQueryLog = ->
    $(".search-log").remove()
    return if querys.length < 1

    base = $("#search-log-header")
    limit = if isPhoneDevice() then 20 else 30

    for i in [queryLogSize..1]
      q = querys[i-1]
      continue unless q
      detail = q.detail || ''
      if detail.length > limit
        detail = detail.slice(0, limit-3) + '...'
      li = "<li><a data-target='#' data-order='#{i}' class='search-log'>#{detail}</a></li>"
      base.after(li)
    @

  searchTargets = (q) ->
    query = q || Query.build()
    if query.isEmpty()
      query = Query.create({recently: recentlySize})
    Searcher.searchArcanas query, (as, detail) ->
      query.detail = detail
      $(".search-detail").text query.detail
      pager = createPager(as)
      resetSortOrder()
      replaceTargetArea()
      addQueryLog(query)
      renderQueryLog()

  searchRecentlyTargets = ->
    searchTargets Query.create({recently: recentlySize})
    resetConditions()

  searchFavoriteArcanas = ->
    fl = collectFavriteList()
    if fl.length <= 0
      replaceTargetAreaForFavorite()
      return

    targets = []
    for c in fl
      continue if Searcher.forCode(c)
      targets.push c

    if targets.length <= 0
      replaceTargetAreaForFavorite()
      return

    Searcher.searchCodes targets, (as) ->
      replaceTargetAreaForFavorite()

  toggleEditMode = ->
    edit = $("#edit-area")
    member = $("#member-area")
    btnText = $("#edit-state")
    btnIcon = $("#edit-icon")
    title = $("#edit-title")
    clear = $("#clear-area")

    if onEdit
      onEdit = false
      btnText.text("編集する")
      btnIcon.removeClass("glyphicon-check")
      btnIcon.addClass("glyphicon-edit")
      member.removeClass("well well-sm")
      title.hide()
      edit.fadeOut()
      clear.hide()
    else
      onEdit = true
      btnText.text("編集終了")
      btnIcon.removeClass("glyphicon-edit")
      btnIcon.addClass("glyphicon-check")
      member.addClass("well well-sm")
      title.show()
      edit.fadeIn()
      clear.show()
    reloadMemberAreas()
    @

  clearMemberArcana = (key) ->
    removeMember(key)
    renderMemberArcana(key)

  removeDuplicateMember = (target) ->
    name1 = target.arcana.name
    name2 = target.chainArcana?.name

    eachMemberKey (k) ->
      return if k is 'friend'
      m = memberFor(k)
      return unless m

      if m.arcana.name == name1 || (name2 && m.arcana.name == name2)
        clearMemberArcana(k)
        return

      return unless m.chainArcana
      if m.chainArcana.name == name1 || (name2 && m.chainArcana.name == name2)
        m.chainArcana = null
        setMemberArcana(k, m)
    @

  createMembersCode = ->
    header = 'V' + $("#pt-ver").val()
    code = ''
    eachMember (m) ->
      if m
        code += m.arcana.jobCode
        code += (if m.chainArcana then m.chainArcana.jobCode else 'N')
      else
        code += 'NN'
    if (/^N+$/).test(code) then '' else (header + code)

  calcCost = ->
    cost = 0
    eachMemberOnly (m) ->
      cost += m.chainedCost() if m
    $("#cost").text(cost)

  isShowTutorial = ->
    if Cookie.valueFor('tutorial') then false else true

  showTutorial = ->
    $("#tutorial").show()
    Cookie.set({tutorial: true})

  isShowLatestInfo = ->
    ver = $("#latest-info-ver").val()
    return false if ver == ''
    showed = Cookie.valueFor('latest-info')
    return true unless showed
    if ver == showed then false else true

  showLatestInfo = ->
    ver = $("#latest-info-ver").val()
    $("#latest-info").show()
    Cookie.set({'latest-info': ver})

  createUnionList = ->
    li = $('#union')
    li.empty()
    li.append("<option value=''>-</option>")

    for u in Searcher.unions()
      li.append("<option value='#{u[0]}'>#{u[1]}</option>")
    @

  createSkillCategorys = ->
    target = $("#skill")
    target.empty()
    target.append("<option value=''>-</option>")
    for s in Searcher.skillCategorys()
      target.append("<option value='#{s[0]}'>#{s[1]}</option>")
    @

  createSkillOptions = ->
    sub = $("#skill-sub")
    sub.empty()
    effect = $("#skill-effect")
    effect.empty()
    add = $("#skill-add")

    skill = $("#skill").val()
    if skill == ''
      sub.append("<option value=''>-</option>")
      effect.append("<option value=''>-</option>")
      add.hide()
      return

    subtypes = Searcher.skillSubtypesFor(skill)
    sub.append("<option value=''>（全て）</option>")
    for t in subtypes
      sub.append("<option value='#{t[0]}'>#{t[1]}</option>")

    effecttypes = Searcher.skillEffectTypesFor(skill)
    effect.append("<option value=''>（全て）</option>")
    for t in effecttypes
      effect.append("<option value='#{t[0]}'>#{t[1]}</option>")

    add.show()
    @

  createSourceOptions = ->
    cate = $("#source-category").val()
    sources = $("#source")
    sources.empty()

    if cate == ''
      sources.append("<option value=''>-</option>")
      return

    types = Searcher.sourceTypesFor(cate)
    sources.append("<option value=''>（全て）</option>")
    for t in types
      sources.append("<option value='#{t[0]}'>#{t[1]}</option>")
    @

  createArcanaDetail = (code) ->
    m = Searcher.forCode(code)
    view = $("#view-detail")
    view.empty()
    view.append(renderArcanaDetail(m))

    $(".fav-detail").bootstrapSwitch({
      state: favs[code]
      size: 'mini'
      onColor: 'success'
      labelText: 'お気に入り'
      onSwitchChange: (e, state) ->
        target = $(e.target)
        toggleFavoriteArcana(target.data('jobCode'), state)
    })
    @

  createAbilityCategorys = ->
    target = $("#ability-category")
    target.empty()
    target.append("<option value=''>-</option>")
    for c in Searcher.abirityCategorys()
      target.append("<option value='#{c[0]}'>#{c[1]}</option>")
    @

  createChainAbilityCategorys = ->
    target = $("#chain-ability-category")
    target.empty()
    target.append("<option value=''>-</option>")
    for c in Searcher.abirityCategorys()
      target.append("<option value='#{c[0]}'>#{c[1]}</option>")
    @

  createAbilityEffects = ->
    target = $("#ability-effect")
    target.empty()
    cate = $("#ability-category").val()
    if cate == ''
      target.append("<option value=''>-</option>")
      return
    conds = Searcher.abirityEffectsFor(cate)
    target.append("<option value=''>（全て）</option>")
    for c in conds
      target.append("<option value='#{c[0]}'>#{c[1]}</option>")
    @

  createChainAbilityEffects = ->
    target = $("#chain-ability-effect")
    target.empty()
    cate = $("#chain-ability-category").val()
    if cate == ''
      target.append("<option value=''>-</option>")
      return
    conds = Searcher.abirityEffectsFor(cate)
    target.append("<option value=''>（全て）</option>")
    for c in conds
      target.append("<option value='#{c[0]}'>#{c[1]}</option>")
    @

  createActors = ->
    target = $("#actor")
    target.empty()
    target.append("<option value=''>-</option>")
    for a in Searcher.voiceactors()
      target.append("<option value='#{a[0]}'>#{a[1]}</option>")
    @

  createIllustrators = ->
    target = $("#illustrator")
    target.empty()
    target.append("<option value=''>-</option>")
    for i in Searcher.illustrators()
      target.append("<option value='#{i[0]}'>#{i[1]}</option>")
    @

  initSearchConditions = ->
    d = new $.Deferred()

    Searcher.load_conditions ->
      createUnionList()
      createSkillCategorys()
      createAbilityCategorys()
      createChainAbilityCategorys()
      createActors()
      createIllustrators()
      initFavoriteArcana()
      initQueryLog()
      initParties()
      d.resolve()
    d.promise()

  prevTargetPage = ->
    if pager?.hasPrevPage()
      pager.prevPage()
      replaceTargetArea()
    @

  nextTargetPage = ->
    if pager?.hasNextPage()
      pager.nextPage()
      replaceTargetArea()
    @

  toggleFavoriteArcana = (code, state) ->
    favs[code] = state
    storeFavoriteArcana()
    @

  initFavoriteArcana = ->
    favs = {}

    try
      list = Cookie.valueFor('fav-arcana')
      return unless list
      for code in list.split('/')
        favs[code] = true
    catch
      favs = {}
    @

  storeFavoriteArcana = ->
    fl = collectFavriteList()
    Cookie.set({'fav-arcana': fl.join('/')})
    @

  clearFavoriteArcana = ->
    favs = {}
    Cookie.delete('fav-arcana')
    @

  storeLastMembers = ->
    code = createMembersCode()
    Cookie.set({'last-members': code})

  searchLastMembers = ->
    code = Cookie.valueFor('last-members') || ''
    code = defaultMemberCode if code is ''
    buildMembersArea(code)

  clearLastMembers = ->
    Cookie.delete('last-members')

  handleDropedArcana = (target, drag) ->
    code = drag.data('jobCode')
    key = memberKeyFromArea(target)
    org = memberFor(key)
    swapKey = drag.data('parentKey')
    return if key == swapKey

    d = new Member(Searcher.forCode(code))
    if (org && org.arcana.name != d.arcana.name)
      spr = $('#select-proposal-replace')
      spr.empty()
      spr.append(renderSummarySizeArcana(d, 'chain'))

      pc = new Member(org.arcana)
      pc.chainArcana = d.arcana
      rpc = renderSummarySizeArcana(pc, 'chain')

      spc = $('#select-proposal-chain')
      spc.empty()
      spc.append(rpc)

      st = $('#select-chain-status')
      if Arcana.canUseChainAbility(org.arcana, d.arcana)
        st.text('絆アビリティ使用可能')
        st.addClass('label-success')
        st.removeClass('label-danger')
      else
        st.text('絆アビリティ使用不可')
        st.removeClass('label-success')
        st.addClass('label-danger')

      us = $('#select-union-status')
      if org.arcana.union == d.arcana.union
        us.text('所属ボーナスあり')
        us.addClass('label-success')
        us.removeClass('label-warning')
      else
        us.text('所属ボーナスなし')
        us.removeClass('label-success')
        us.addClass('label-warning')

      $('#select-position-key').val(key)
      $('#select-swap-position-key').val(swapKey)
      $('#select-droped-code').val(code)
      $('#select-modal').modal('show')
    else
      replaceMemberArea(key, code, swapKey)
    @

  replaceMemberArea = (pos, code, swapPos) ->
    fromMember = (if (swapPos && swapPos != '') then true else false)
    m = new Member(Searcher.forCode(code))
    if fromMember
      m.chainArcana = (memberFor(swapPos)).chainArcana
    removeDuplicateMember(m) unless pos is 'friend'

    if (! fromMember) || pos is 'friend'
      setMemberArcana(pos, m)
      return

    setMemberArcana(swapPos, memberFor(pos))
    setMemberArcana(pos, m)
    @

  setMemberArcana = (key, m) ->
    setMember(key, m)
    renderMemberArcana(key)
    calcCost()
    storeLastMembers()
    @

  resetSortOrder = ->
    sortOrder = {}
    @

  updateSortOrder = (col, order) ->
    resetSortOrder()
    sortOrder[col] = order
    @

  reverseOrder = (order) ->
    switch order
      when 'asc' then 'desc'
      when 'desc' then 'asc'
      else null

  sortTargets = (col, ord) ->
    order = ord || reverseOrder(sortOrder[col]) || sortOrderDefault[col] || 'desc'
    pager?.sort(col, order)
    replaceTargetArea()
    updateSortOrder(col, order)
    renderOrderState()
    @

  initParties = ->
    parties = []

    try
      val = Cookie.valueFor('parties')
      return unless val
      parties = JSON.parse(val)
      renderPartyList()
    catch
      parties = []
    @

  loadParty = (order) ->
    pt = parties[order-1] || {}
    code = pt.code || ''
    code = defaultMemberCode if code is ''
    comment = pt.comment || ""
    $("#members-comment").val(comment)
    buildMembersArea(code)

  storeParty = (comment) ->
    code = createMembersCode()
    comment ||= '名無しパーティー'
    if comment.length > 10
      comment = comment.substr(0, 10)

    data =
      code: code
      comment: comment
    npt = [data]
    for pt in parties
      break if parties.length == ptSize
      continue if pt.code == code
      npt.push pt
    parties = npt
    renderPartyList()

    val = JSON.stringify(parties)
    Cookie.set({'parties': val})
    parties

  renderPartyList = ->
    $(".party-list").remove()
    return if parties.length < 1

    base = $("#party-list-header")
    for i in [ptSize..1]
      pt = parties[i-1]
      continue unless pt
      comment = pt.comment || '名無しパーティー'
      li = "<li><a data-target='#' data-order='#{i}' class='party-list'>#{comment}</a></li>"
      base.after(li)
    @

  twitterUrl = (text) ->
    url = "https://twitter.com/intent/tweet"
    url += "?text=#{encodeURIComponent(text)}"
    url += "&hashtags=ccpts"
    url

  createRequestTweetUrl = ->
    text = $("#request-textarea").val()
    text = text.substr(0, 100) if text.length > 100
    $("#twitter-request").attr('href', twitterUrl("@parrot_studio #{text}"))

  commonHandler = ->
    $("#error-area").hide()
    $("#error-area").removeClass("invisible")
    $("#topnav").hide()
    $("#topnav").removeClass("invisible")
    if isPhoneDevice()
      $("#ads").hide()
    else
      $("#topnav").show()

    $("#request-modal").on 'show.bs.modal', (e) ->
      createRequestTweetUrl()
      true # for modal

    $("#request-textarea").on 'change', (e) ->
      createRequestTweetUrl()

    $("#form-request").on 'click', (e) ->
      e.preventDefault()

      text = $("#request-textarea").val()
      text = text.substr(0, 100) if text.length > 100
      if text.length < 1
        alert("メッセージを入力してください")
        return
      return unless confirm("メッセージを送信します。よろしいですか？")

      $("#request-modal").modal('hide')
      Searcher.request text, ->
        $("#request-textarea").val('')
        createRequestTweetUrl()
        alert("メッセージを送信しました")

  searchHandler = ->
    commonHandler()

    $("#latest-info").hide()
    $("#latest-info").removeClass("invisible")
    $("#additional-condition").hide()
    $("#skill-add").hide()

    $(".search").on 'click', (e) ->
      e.preventDefault()
      searchTargets()
      $("#search-modal").modal('hide')

    $(".search-clear").on 'click', (e) ->
      e.preventDefault()
      resetConditions()

    $("#add-condition").on 'click', (e) ->
      e.preventDefault()
      $("#add-condition").hide()
      $("#additional-condition").fadeIn('fast')

    $("#skill").on 'change', (e) ->
      e.preventDefault()
      createSkillOptions()

    $("#ability-category").on 'change', (e) ->
      e.preventDefault()
      createAbilityEffects()

    $("#chain-ability-category").on 'change', (e) ->
      e.preventDefault()
      createChainAbilityEffects()

    $("#source-category").on 'change', (e) ->
      e.preventDefault()
      createSourceOptions()

    $("#view-modal").on 'show.bs.modal', (e) ->
      code = $(e.relatedTarget).data('jobCode')
      createArcanaDetail(code)
      true # for modal

    $(".pager-prev").on 'click', (e) ->
      e.preventDefault()
      prevTargetPage()

    $(".pager-next").on 'click', (e) ->
      e.preventDefault()
      nextTargetPage()

    $(".pagination").on 'click', 'span.jump-page', (e) ->
      e.preventDefault()
      page = $(e.target).data('page')
      pager?.jumpPage(page)
      replaceTargetArea()

    $("#default-list").on 'click', (e) ->
      e.preventDefault()
      searchRecentlyTargets()

    $("#clear-fav").on 'click', (e) ->
      e.preventDefault()
      if window.confirm('お気に入りを消去します。よろしいですか？')
        clearFavoriteArcana()
        window.alert('お気に入りを消去しました。')

    $("#clear-log").on 'click', (e) ->
      e.preventDefault()
      if window.confirm('検索履歴を消去します。よろしいですか？')
        clearQueryLog()
        window.alert('検索履歴を消去しました。')

    $("#clear-all").on 'click', (e) ->
      e.preventDefault()
      if window.confirm('全ての履歴（お気に入り/検索）を消去します。よろしいですか？')
        clearFavoriteArcana()
        clearLastMembers()
        clearQueryLog()
        window.alert('全ての履歴を消去しました。')

    $("#search-menu").on 'click', 'a.search-log', (e) ->
      e.preventDefault()
      n = parseInt($(e.target).data('order'))
      if n > 0
        query = querys[n-1]
        if query
          searchTargets(query)
          setConditions(query)

    $("#favorite-list").on 'click', (e) ->
      e.preventDefault()
      searchFavoriteArcanas()

    $("#view-modal").on 'click', 'button.wiki-link', (e) ->
      e.preventDefault()
      code = $(e.target).data('jobCode')
      a = Searcher.forCode(code)
      return false unless a

      lt = if a.wikiName is ''
        "Wikiで最新情報を確認する"
      else
        "Wikiで #{a.wikiName} を確認する"

      $("#outside-link-text").text(lt)
      $("#outside-link").attr('href', a.wikiUrl)
      $("#outside-site-name").text("チェインクロニクル攻略・交流Wiki")

      $("#view-modal").modal('hide')
      $("#link-modal").modal('show')

    $("#outside-link").on 'click', (e) ->
      $("#link-modal").modal('hide')
      true

    # return promise
    initSearchConditions()

  initEditHandler = ->
    promise = searchHandler()

    $("#tutorial").hide()
    $("#tutorial").removeClass("invisible")
    $("#help-area").hide()
    $("#help-area").removeClass("invisible")
    $("#help-text").hide()

    if isShowTutorial()
      showTutorial()
    else if isShowLatestInfo()
      showLatestInfo()

    $(".member-character").droppable(
      drop: (e, ui) ->
        e.preventDefault()
        handleDropedArcana($(e.target), ui.draggable)
    )

    $("#edit-members").on 'click', (e) ->
      e.preventDefault()
      toggleEditMode()

    $("#member-area").on 'click', 'button.close-member', (e) ->
      e.preventDefault()
      target = $(e.target).parents(".member-character")
      key = memberKeyFromArea(target)
      clearMemberArcana(key)
      calcCost()
      false

    $("#member-area").on 'click', 'button.close-chain', (e) ->
      e.preventDefault()
      target = $(e.target).parents(".member-character")
      key = memberKeyFromArea(target)
      mem = memberFor(key)
      if mem
        mem.chainArcana = null
        setMemberArcana(key, mem)
      false

    $("#share-ptm-modal").on 'show.bs.modal', (e) ->
      code = createMembersCode()
      url = $("#app-path").val() + code
      $("#ptm-code").val(url)
      $("#twitter-share").attr('href', twitterUrl("チェンクロ パーティーシミュレーター #{url}"))
      true # for modal

    $("#ptm-code").on 'click forcus', (e) ->
      $(e.target).select()
      e.preventDefault()

    $("#reset-members").on 'click', (e) ->
      e.preventDefault()
      eachMemberKey (k) ->
        clearMemberArcana(k)
      $("#cost").text('0')
      $("#reset-modal").modal('hide')

    $("#last-members").on 'click', (e) ->
      e.preventDefault()
      searchLastMembers()

    $("#select-btn-chain").on 'click', (e) ->
      e.preventDefault()
      key = $('#select-position-key').val()
      code = $('#select-droped-code').val()
      mem = memberFor(key)
      if mem
        mem.chainArcana = Searcher.forCode(code)
      removeDuplicateMember(mem) unless key is 'friend'
      setMemberArcana(key, mem)
      $('#select-modal').modal('hide')

    $("#select-btn-replace").on 'click', (e) ->
      e.preventDefault()
      key = $('#select-position-key').val()
      swapKey = $('#select-swap-position-key').val()
      code = $('#select-droped-code').val()
      replaceMemberArea(key, code, swapKey)
      $('#select-modal').modal('hide')

    $("#help-text-btn").on 'click', (e) ->
      e.preventDefault()
      $("#help-text").show()
      $("#help-text-btn").hide()

    $("#store-members").on 'click', (e) ->
      e.preventDefault()
      comment = $("#members-comment").val()
      storeParty(comment)
      $("#store-modal").modal('hide')

    $("#party-menu").on 'click', 'a.party-list', (e) ->
      e.preventDefault()
      n = parseInt($(e.target).data('order'))
      loadParty(n) if n > 0

    promise

  initDatabaseHandler = ->
    promise = searchHandler()

    showLatestInfo() if isShowLatestInfo()

    $("#share-query-modal").on 'show.bs.modal', (e) ->
      query = lastQuery || {}
      qs = query.encode() || ''

      url = "#{$("#app-path").val()}db"
      url += "?#{qs}" unless qs is ''
      if isPhoneDevice()
        $("#share-url-form").hide()
      else
        $("#query-url").val(url)
      $("#twitter-share").attr('href', twitterUrl("チェンクロ パーティーシミュレーター #{url}"))
      true # for modal

    $("#query-url").on 'click forcus', (e) ->
      $(e.target).select()
      e.preventDefault()

    if isPhoneDevice()
      $("#arcana-table").swipe (
        swipeLeft: (e) ->
          prevTargetPage()
          e.preventDefault()
        swipeRight: (e) ->
          nextTargetPage()
          e.preventDefault()
      )

    $("#arcana-table").on 'click', 'th.sortable', (e) ->
      e.preventDefault()
      target = $(e.target)
      col = target.data('colName') || ''
      sortTargets(col) unless col is ''

    $("#arcana-table").on 'click', 'button.sortable', (e) ->
      target = $(e.target).parents('th')
      col = target.data('colName') || ''
      sortTargets(col) unless col is ''
      false

    promise

$ ->
  FastClick.attach(document.body)
  new Viewer()
