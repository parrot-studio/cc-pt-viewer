class @ArcanasView

  pagerSize = 8
  recentlySize = 36

  pager = new Pager([])

  $appPath = $("#app-path")
  $twitterShare = $("#twitter-share")
  $queryUrl = $("#query-url")
  $arcanaName = $('#arcana-name')

  $searchSkill = $("#skill")
  $searchSkillAdd = $("#skill-add")
  $searchSourceCategory = $("#source-category")
  $searchAbilityCategory = $("#ability-category")
  $searchAbilityAdd = $("#ability-add")
  $searchChainAbilityCategory = $("#chain-ability-category")
  $searchChainAbilityAdd = $("#chain-ability-add")
  $searchAddCondition = $("#add-condition")
  $searchAdditionalCondition = $("#additional-condition")

  sortArcanasFor: (col, ord) ->
    pager.sort(col, ord)
    pager.get()

  setTwitterShare: (path) ->
    url = $appPath.val() + path
    $queryUrl.val(url)
    $twitterShare.attr('href', CommonView.twitterUrl("チェンクロ パーティーシミュレーター #{url}"))

  constructor: (params) ->
    pagerSize = (params?.pagerSize || pagerSize)
    queryLogSize = (params?.queryLogSize || queryLogSize)
    recentlySize = (params?.recentlySize || recentlySize)

    $viewModal = $("#view-modal")
    $linkModal = $("#link-modal")
    $outsideLink = $("#outside-link")

    $searchAdditionalCondition.hide()
    $searchSkillAdd.hide()
    $searchAbilityAdd.hide()
    $searchChainAbilityAdd.hide()

    createUnionList()
    createSkillCategorys()
    createAbilityCategorys()
    createChainAbilityCategorys()
    createActors()
    createIllustrators()

    QueryLogs.init()
    Favorites.init()

    # streams
    recentQuery = Query.create(recently: recentlySize)

    queryFromSearch = $(".search")
      .asEventStream('click')
      .doAction('.preventDefault')
      .doAction -> $("#search-modal").modal('hide')
      .map -> Query.build()

    queryfromQueryLog = $("#search-menu")
      .asEventStream('click', 'a.search-log')
      .doAction('.preventDefault')
      .map (e) -> parseInt($(e.target).data('order'))
      .filter (n) -> n > 0
      .map (n) -> QueryLogs.querys[n-1]
      .filter (q) -> q
      .doAction (q) -> setConditions(q)

    queryFromDefaultList = $("#default-list")
      .asEventStream('click')
      .doAction('.preventDefault')
      .map -> recentQuery

    queryFromInit = Bacon.once(parseQuery())

    queryStream = queryFromSearch
      .merge queryfromQueryLog
      .merge queryFromDefaultList
      .merge queryFromInit

    querySearchStream = queryStream
      .map (q) -> (if q.isEmpty() then recentQuery else q)
      .doAction -> $arcanaName.val('')
      .flatMap (query) -> searchTargets(query)

    favSearchStream = $("#favorite-list")
      .asEventStream('click')
      .doAction('.preventDefault')
      .map -> Favorites.list()
      .flatMap (favs) -> searchFavs(favs)

    arcanaNameStream = $arcanaName
      .asEventStream('keyup change')
      .delay(500)
      .map -> $arcanaName.val()
      .debounce(300)
      .skipDuplicates()

    nameSearchStream = arcanaNameStream
      .filter (name) -> name.length > 1
      .flatMap (name) -> searchName(name)

    emptyNameSearchStream = arcanaNameStream
      .filter (name) -> _.isEmpty(name)
      .flatMap -> searchTargets(recentQuery)

    arcanaNameSearchStream = nameSearchStream.merge(emptyNameSearchStream)

    searchStream = querySearchStream
      .merge favSearchStream
      .merge arcanaNameSearchStream

    searchResult = searchStream
      .flatMap (as) -> createPager(as, pagerSize)

    prevPageStream = $('.pager-prev')
      .asEventStream('click')
      .doAction('.preventDefault')
      .filter -> pager.hasPrevPage()
      .doAction -> pager.prevPage()

    nextPageStream = $('.pager-next')
      .asEventStream('click')
      .doAction('.preventDefault')
      .filter -> pager.hasNextPage()
      .doAction -> pager.nextPage()

    jumpPageStream = $(".pagination")
      .asEventStream('click', 'span.jump-page')
      .doAction('.preventDefault')
      .map (e) -> $(e.target).data('page')
      .map (p) -> parseInt(p)
      .doAction (page) -> pager.jumpPage(page)

    @targetArcanas = searchResult
      .merge prevPageStream
      .merge nextPageStream
      .merge jumpPageStream
      .doAction -> renderPager()
      .map -> pager.get()

    $("#clear-fav")
      .asEventStream('click')
      .doAction('.preventDefault')
      .filter -> window.confirm('お気に入りを消去します。よろしいですか？')
      .doAction -> Favorites.clear()
      .onValue -> window.alert('お気に入りを消去しました。')

    $("#clear-log")
      .asEventStream('click')
      .doAction('.preventDefault')
      .filter -> window.confirm('検索履歴を消去します。よろしいですか？')
      .doAction -> clearQueryLogs()
      .onValue -> window.alert('検索履歴を消去しました。')

    $("#clear-all")
      .asEventStream('click')
      .doAction('.preventDefault')
      .filter -> window.confirm('全ての履歴（お気に入り/検索）を消去します。よろしいですか？')
      .doAction -> Favorites.clear()
      .doAction -> clearQueryLogs()
      .onValue -> window.alert('全ての履歴を消去しました。')

    $viewModal
      .asEventStream('show.bs.modal')
      .map (e) -> $(e.relatedTarget).data('jobCode')
      .onValue (code) -> createArcanaDetail(code)

    $viewModal
      .asEventStream('click', 'button.wiki-link')
      .doAction('.preventDefault')
      .map (e) -> $(e.target).data('jobCode')
      .map (code) -> Arcana.forCode(code)
      .filter (a) -> a
      .onValue (a) ->
        lt = if _.isEmpty(a.wikiName)
          "Wikiで最新情報を確認する"
        else
          "Wikiで #{a.wikiName} を確認する"

        $outsideLink.attr('href', a.wikiUrl)
        $("#outside-link-text").text(lt)
        $("#outside-site-name").text("チェインクロニクル攻略・交流Wiki")
        $viewModal.modal('hide')
        $linkModal.modal('show')

    $outsideLink
      .asEventStream('click')
      .onValue -> $linkModal.modal('hide')

    $queryUrl
      .asEventStream('click forcus')
      .doAction('.preventDefault')
      .map (e) -> $(e.target)
      .onValue (target) -> target.select()

    $searchAddCondition
      .asEventStream('click')
      .doAction('.preventDefault')
      .onValue ->
        $searchAddCondition.hide()
        $searchAdditionalCondition.fadeIn('fast')

    $searchSkill
      .asEventStream('change')
      .doAction('.preventDefault')
      .map -> $searchSkill.val()
      .onValue (val) -> createSkillOptions(val)

    $searchAbilityCategory
      .asEventStream('change')
      .doAction('.preventDefault')
      .map -> $searchAbilityCategory.val()
      .onValue (val) ->
        createAbilityEffects(val)
        createAbilityConditions(val)
        if _.isEmpty(val)
          $searchAbilityAdd.hide()
        else
          $searchAbilityAdd.show()

    $searchChainAbilityCategory
      .asEventStream('change')
      .doAction('.preventDefault')
      .map -> $searchChainAbilityCategory.val()
      .onValue (val) ->
        createChainAbilityEffects(val)
        createChainAbilityConditions(val)
        if _.isEmpty(val)
          $searchChainAbilityAdd.hide()
        else
          $searchChainAbilityAdd.show()

    $searchSourceCategory
      .asEventStream('change')
      .doAction('.preventDefault')
      .map -> $searchSourceCategory.val()
      .onValue (val) -> createSourceOptions(val)

    $(".search-clear")
      .asEventStream('click')
      .doAction('.preventDefault')
      .onValue -> resetConditions()

  # private ------------------

  replaceDetail = (text) -> $(".search-detail").text(text)

  searchTargets = (query) ->
    Searcher.searchArcanas(query).flatMap (as) ->
      replaceDetail(query.detail)
      QueryLogs.add(query)
      renderQueryLog(QueryLogs.querys)
      as

  searchFavs = (favs) ->
    Searcher.searchCodes(favs).flatMap (as) ->
      replaceDetail('お気に入り')
      as

  searchName = (name) ->
    Searcher.searchFromName(name).flatMap (as) ->
      replaceDetail('名前から検索 : ' + name)
      as

  clearQueryLogs = ->
    QueryLogs.clear()
    renderQueryLog(QueryLogs.querys)

  parseQuery = ->
    q = Query.parse()
    setConditions(q)
    q

  resetConditions = ->
    $("#job").val('')
    $("#rarity").val('')
    $("#weapon").val('')
    $("#actor").val('')
    $("#illustrator").val('')
    $("#union").val('')
    $searchSourceCategory.val('')
    $("#source").empty().append("<option value=''>-</option>")
    $searchSkill.val('')
    $("#skill-cost").val('')
    $("#skill-sub").empty().append("<option value=''>-</option>")
    $("#skill-effect").empty().append("<option value=''>-</option>")
    $searchAbilityCategory.val('')
    $("#ability-effect").empty().append("<option value=''>-</option>")
    $("#ability-condition").empty().append("<option value=''>-</option>")
    $searchChainAbilityCategory.val('')
    $("#chain-ability-effect").empty().append("<option value=''>-</option>")
    $("#chain-ability-condition").empty().append("<option value=''>-</option>")
    $("#arcana-cost").val('')
    $("#chain-cost").val('')

    $searchAdditionalCondition.hide()
    $searchSkillAdd.hide()
    $searchAbilityAdd.hide()
    $searchChainAbilityAdd.hide()
    $searchAddCondition.show()
    @

  setConditions = (q) ->
    return unless q
    resetConditions()
    return if q.isEmpty() || q.isQueryForRecently()
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
      cate = query.sourcecategory
      $searchSourceCategory.val(cate)
      createSourceOptions(cate)
      if query.source
        $("#source").val(query.source)

    add = false
    if query.actor
      $("#actor").val(query.actor)
      add = true
    if query.actorname
      id = Conditions.voiceactorIdFor(query.actorname)
      $("#actor").val(id)
      add = true
    if query.illustrator
      $("#illustrator").val(query.illustrator)
      add = true
    if query.illustratorname
      id = Conditions.illustratorIdFor(query.illustratorname)
      $("#illustrator").val(id)
      add = true
    if query.skillcost
      add = true
      $("#skill-cost").val(query.skillcost)
    if query.skill
      add = true
      skill = query.skill
      $searchSkill.val(skill)
      createSkillOptions(skill)
      $searchSkillAdd.show()
      if query.skillsub
        $("#skill-sub").val(query.skillsub)
      if query.skilleffect
        $("#skill-effect").val(query.skilleffect)
    if query.abilitycategory
      add = true
      cate = query.abilitycategory
      $searchAbilityCategory.val(cate)
      createAbilityEffects(cate)
      createAbilityConditions(cate)
      unless _.isEmpty(cate)
        $searchAbilityAdd.show()
      if query.abilityeffect
        $("#ability-effect").val(query.abilityeffect)
      if query.abilitycondition
        $("#ability-condition").val(query.abilitycondition)
    if query.chainabilitycategory
      add = true
      cate = query.chainabilitycategory
      $searchChainAbilityCategory.val(cate)
      createChainAbilityEffects(cate)
      createChainAbilityConditions(cate)
      unless _.isEmpty(cate)
        $searchChainAbilityAdd.show()
      if query.chainabilityeffect
        $("#chain-ability-effect").val(query.chainabilityeffect)
      if query.chainabilitycondition
        $("#chain-ability-condition").val(query.chainabilitycondition)

    if add
      $searchAdditionalCondition.show()
      $searchAddCondition.hide()
    @

  createUnionList = ->
    li = $('#union')
    li.empty()
    li.append("<option value=''>-</option>")

    _.forEach Conditions.unions(), (u) ->
      li.append("<option value='#{u[0]}'>#{u[1]}</option>")
    @

  createSkillCategorys = ->
    target = $searchSkill
    target.empty()
    target.append("<option value=''>-</option>")
    _.forEach Conditions.skillCategorys(), (s) ->
      target.append("<option value='#{s[0]}'>#{s[1]}</option>")
    @

  createSkillOptions = (skill) ->
    sub = $("#skill-sub")
    sub.empty()
    effect = $("#skill-effect")
    effect.empty()
    add = $searchSkillAdd

    if _.isEmpty(skill)
      sub.append("<option value=''>-</option>")
      effect.append("<option value=''>-</option>")
      add.hide()
      return

    sub.append("<option value=''>（全て）</option>")
    _.forEach Conditions.skillSubtypesFor(skill), (t) ->
      sub.append("<option value='#{t[0]}'>#{t[1]}</option>")

    effect.append("<option value=''>（全て）</option>")
    _.forEach Conditions.skillEffectTypesFor(skill), (t) ->
      effect.append("<option value='#{t[0]}'>#{t[1]}</option>")

    add.show()
    @

  createSourceOptions = (cate) ->
    sources = $("#source")
    sources.empty()

    if _.isEmpty(cate)
      sources.append("<option value=''>-</option>")
      return

    sources.append("<option value=''>（全て）</option>")
    _.forEach Conditions.sourceTypesFor(cate), (t) ->
      sources.append("<option value='#{t[0]}'>#{t[1]}</option>")
    @

  createArcanaDetail = (code) ->
    m = Arcana.forCode(code)
    view = $("#view-detail")
    view.empty()
    view.append(renderArcanaDetail(m))

    $(".fav-detail").bootstrapSwitch({
      state: Favorites.stateFor(code)
      size: 'mini'
      onColor: 'success'
      labelText: 'お気に入り'
      onSwitchChange: (e, state) ->
        target = $(e.target)
        Favorites.setState(target.data('jobCode'), state)
    })
    @

  createAbilityCategorys = ->
    target = $searchAbilityCategory
    target.empty()
    target.append("<option value=''>-</option>")
    _.forEach Conditions.abirityCategorys(), (c) ->
      target.append("<option value='#{c[0]}'>#{c[1]}</option>")
    @

  createChainAbilityCategorys = ->
    target = $searchChainAbilityCategory
    target.empty()
    target.append("<option value=''>-</option>")
    _.forEach Conditions.chainAbirityCategorys(), (c) ->
      target.append("<option value='#{c[0]}'>#{c[1]}</option>")
    @

  createAbilityEffects = (cate) ->
    target = $("#ability-effect")
    target.empty()
    if _.isEmpty(cate)
      target.append("<option value=''>-</option>")
      return
    target.append("<option value=''>（全て）</option>")
    _.forEach Conditions.abirityEffectsFor(cate), (c) ->
      target.append("<option value='#{c[0]}'>#{c[1]}</option>")
    @

  createAbilityConditions = (cate) ->
    target = $("#ability-condition")
    target.empty()
    if _.isEmpty(cate)
      target.append("<option value=''>-</option>")
      return
    target.append("<option value=''>（全て）</option>")
    _.forEach Conditions.abirityConditionsFor(cate), (c) ->
      target.append("<option value='#{c[0]}'>#{c[1]}</option>")
    @

  createChainAbilityEffects = (cate) ->
    target = $("#chain-ability-effect")
    target.empty()
    if _.isEmpty(cate)
      target.append("<option value=''>-</option>")
      return
    target.append("<option value=''>（全て）</option>")
    _.forEach Conditions.chainAbirityEffectsFor(cate), (c) ->
      target.append("<option value='#{c[0]}'>#{c[1]}</option>")
    @

  createChainAbilityConditions = (cate) ->
    target = $("#chain-ability-condition")
    target.empty()
    if _.isEmpty(cate)
      target.append("<option value=''>-</option>")
      return
    target.append("<option value=''>（全て）</option>")
    _.forEach Conditions.chainAbirityConditionsFor(cate), (c) ->
      target.append("<option value='#{c[0]}'>#{c[1]}</option>")
    @

  createActors = ->
    target = $("#actor")
    target.empty()
    target.append("<option value=''>-</option>")
    _.forEach Conditions.voiceactors(), (a) ->
      target.append("<option value='#{a[0]}'>#{a[1]}</option>")
    @

  createIllustrators = ->
    target = $("#illustrator")
    target.empty()
    target.append("<option value=''>-</option>")
    _.forEach Conditions.illustrators(), (i) ->
      target.append("<option value='#{i[0]}'>#{i[1]}</option>")
    @

  createPager = (list, psize) ->
    pager = new Pager(list, psize)

  renderPager = ->
    prev = $('.pager-prev')
    next = $('.pager-next')
    $('.each-page').remove()

    if pager.hasPrevPage()
      prev.removeClass('disabled')
    else
      prev.addClass('disabled')

    if CommonView.isPhoneDevice()
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

    _.forEach list, (p) ->
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

  renderQueryLog = (querys) ->
    $(".search-log").remove()
    return if querys.length < 1

    base = $("#search-log-header")
    limit = if CommonView.isPhoneDevice() then 20 else 30

    _.forEach [querys.length..1], (i) ->
      q = querys[i-1]
      return unless q
      detail = q.detail || ''
      if detail.length > limit
        detail = detail.slice(0, limit-3) + '...'
      li = "<li><a data-target='#' data-order='#{i}' class='search-log'>#{detail}</a></li>"
      base.after(li)
    @

  renderSkill = (sk) ->
    render = "
    #{sk.name} (#{sk.cost})<br>
    <ul class='small list-unstyled ability-detail'>"
    _.forEach sk.effects, (ef, i) ->
      multi = if ef.multi_type is 'forward'
        ' => '
      else if ef.multi_type is 'either'
        ' または '
      else
        ''

      unless _.isEmpty(ef.multi_condition)
        multi = "（#{multi} #{ef.multi_condition}）"

      render += "<li>#{multi}#{ef.category} - #{ef.subcategory}"
      li = Skill.subeffectForEffect(ef)
      unless _.isEmpty(ef.note)
        li.push ef.note
      if li.length > 0
        render += " ( #{li.join(' / ')} )"
      render += '</li>'
    render += "</ul>"
    render

  renderAbility = (ab) ->
    return "なし" if _.isEmpty(ab.name)

    render = "#{ab.name}"
    unless _.isEmpty(ab.weaponName)
      render += "（#{ab.weaponName}）"
    render += "<ul class='small list-unstyled ability-detail'>"
    _.forEach ab.effects, (e) ->
      str = "#{e.condition} - #{e.effect}"
      unless _.isEmpty(e.target)
        str += ":#{e.target}"
      unless _.isEmpty(e.note)
        str += " (#{e.note})"
      render += "<li>#{str}</li>"
    render += "</ul>"
    render

  renderArcanaDetail = (a) ->
    return '' unless a

    weapon = unless _.isEmpty(a.weaponAbility?.name)
      "<dt>専用武器アビリティ</dt><dd>#{renderAbility(a.weaponAbility)}</dd>"
    else
      ''

    skill2 = unless _.isEmpty(a.skill2?.name)
      "#{renderSkill(a.skill2)}"
    else
      ''

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
                <dd>#{renderSkill(a.skill)}#{skill2}</dd>
                <dt>アビリティ1</dt>
                <dd>#{renderAbility(a.firstAbility)}</dd>
                <dt>アビリティ2</dt>
                <dd>#{renderAbility(a.secondAbility)}</dd>
                #{weapon}
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
