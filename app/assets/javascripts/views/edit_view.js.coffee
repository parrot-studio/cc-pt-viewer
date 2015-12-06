class @EditView

  recentlySize = 36
  pagerSize = 8

  members = {}
  editMode = true
  memberKeys = ['mem1', 'mem2', 'mem3', 'mem4', 'sub1', 'sub2', 'friend']
  defalutMembersCode = 'V2F82F85K51NA38NP28NP24NNNNN'

  $memberArea = $("#member-area")
  $tutorial = $("#tutorial")
  $helpArea = $("#help-area")
  $helpText = $("#help-text")
  $helpTextBtn = $("#help-text-btn")
  $selectModal = $('#select-modal')
  $membersComment = $("#members-comment")

  @init: -> new EditView()

  constructor: ->
    CommonView.init()

    $tutorial.hide()
    $tutorial.removeClass("invisible")
    $helpArea.hide()
    $helpArea.removeClass("invisible")
    $helpText.hide()

    Parties.init()

    if isShowTutorial()
      showTutorial()
    else
      CommonView.showLatestInfo()

    view = new ArcanasView(pagerSize: pagerSize, recentlySize: recentlySize)
    view.targetArcanas.onValue (as) -> renderChoiceArea(as)

    # streams
    ptmCode = Bacon.once($("#ptm").val())
      .filter (c) -> !_.isEmpty(c)
      .doAction -> setEditMode(false)

    lastEditMembersCode = Bacon.once(lastMembersCode())
      .doAction -> setEditMode(true)

    firstMembersCode = ptmCode
      .concat lastEditMembersCode
      .take(1)

    lastMembersClickCode = $("#last-members")
      .asEventStream('click')
      .doAction('.preventDefault')
      .map -> lastMembersCode()

    partyMenuClickCode = $("#party-menu")
      .asEventStream('click', 'a.party-list')
      .doAction('.preventDefault')
      .map (e) -> parseInt($(e.target).data('order'))
      .filter (n) -> n > 0
      .map (n) -> Parties.partyFor(n)
      .map (pt) -> pt?.code
      .filter (code) -> !_.isEmpty(code)

    membersCodeStream = firstMembersCode
      .merge lastMembersClickCode
      .merge partyMenuClickCode

    membersCodeStream
      .flatMap (code) -> Searcher.searchMembers(code)
      .map (as) -> buildMembers(as)
      .doAction -> calcCost()
      .onValue -> reloadMemberAreas()

    $(".member-character").droppable(
      drop: (e, ui) ->
        e.preventDefault()
        handleDropedArcana($(e.target), ui.draggable)
    )

    $("#edit-members")
      .asEventStream('click')
      .doAction('.preventDefault')
      .doAction -> setEditMode(!editMode)
      .onValue -> reloadMemberAreas()

    $memberArea
      .asEventStream('click', 'button.close-member')
      .doAction('.preventDefault')
      .map (e) -> $(e.target).parents(".member-character")
      .map (target) -> memberKeyFromArea(target)
      .onValue (key) -> clearMemberArcana(key)

    $memberArea
      .asEventStream('click', 'button.close-chain')
      .doAction('.preventDefault')
      .map (e) -> $(e.target).parents(".member-character")
      .map (target) -> memberKeyFromArea(target)
      .map (k) -> members[k]
      .filter (mem) -> mem
      .onValue (mem) ->
        mem.chainArcana = null
        updateMemberArcana(mem)

    $("#reset-members")
      .asEventStream('click')
      .doAction('.preventDefault')
      .onValue ->
        _.forEach memberKeys, (k) -> clearMemberArcana(k)
        $("#reset-modal").modal('hide')

    $("#select-btn-chain")
      .asEventStream('click')
      .doAction('.preventDefault')
      .map -> $('#select-position-key').val()
      .map (key) -> members[key]
      .filter (mem) -> mem
      .onValue (mem) ->
        code = $('#select-droped-code').val()
        mem.chainArcana = Arcana.forCode(code)
        removeDuplicateMember(mem) unless mem.memberKey is 'friend'
        updateMemberArcana(mem)
        $selectModal.modal('hide')

    $("#select-btn-replace")
      .asEventStream('click')
      .doAction('.preventDefault')
      .onValue ->
        key = $('#select-position-key').val()
        swapKey = $('#select-swap-position-key').val()
        code = $('#select-droped-code').val()
        replaceMemberArea(key, code, swapKey)
        $selectModal.modal('hide')

    $("#share-ptm-modal")
      .asEventStream('show.bs.modal')
      .map -> createMembersCode()
      .onValue (path) -> view.setTwitterShare(path)

    $helpTextBtn
      .asEventStream('click')
      .doAction('.preventDefault')
      .onValue ->
        $helpText.show()
        $helpTextBtn.hide()

    $("#store-members")
      .asEventStream('click')
      .doAction('.preventDefault')
      .map -> $membersComment.val()
      .onValue (comment) ->
        storeParty(comment)
        $("#store-modal").modal('hide')

  # private ------------------

  memberKeyFromArea = (div) ->
    div.attr('id').replace('member-character-', '')

  lastMembersCode = ->
    code = Cookie.valueFor('last-members')
    code = defalutMembersCode if _.isEmpty(code)
    code

  calcCost = ->
    cost = 0
    _.forEach memberKeys, (k) ->
      return if k is 'friend'
      m = members[k]
      cost += m.chainedCost() if m
    $("#cost").text(cost)

  buildMembers = (as) ->
    _.forEach memberKeys, (k) ->
      mb = as[k]
      mc = as[k + 'c']
      if mb
        mem = new Member(mb)
        mem.chainArcana = mc if mc
        mem.memberKey = k
        members[k] = mem
      else
        members[k] = null
    members

  createMembersCode = ->
    header = 'V' + $("#pt-ver").val()
    code = ''
    _.forEach memberKeys, (k) ->
      m = members[k]
      if m
        code += m.arcana.jobCode
        code += (if m.chainArcana then m.chainArcana.jobCode else 'N')
      else
        code += 'NN'
    if (/^N+$/).test(code) then '' else (header + code)

  storeLastMembers = ->
    code = createMembersCode()
    Cookie.set({'last-members': code})

  reloadMemberAreas = ->
    _.forEach memberKeys, (k) -> renderMemberArcana(k)

  renderMemberArcana = (k) ->
    div = $("#member-character-#{k}")
    div.empty()
    mem = members[k]
    render = if editMode
      r = $(renderSummarySizeMember(mem))
      r.attr('data-parent-key', k)
      r
    else
      $(renderFullSizeArcana(mem))
    render.hide()
    div.append(render)
    render.fadeIn()

  isShowTutorial = ->
    if Cookie.valueFor('tutorial') then false else true

  showTutorial = ->
    $tutorial.show()
    Cookie.set({tutorial: true})

  storeParty = (com) ->
    code = createMembersCode()
    comment = com || '名無しパーティー'
    Parties.addParty(code, comment)
    renderPartyList(Parties.parties)

  renderChoiceArea = (as) ->
    ul = $('#choice-characters')
    ul.empty()
    _.forEach as, (a) ->
      li = $("<li class='listed-character col-sm-3 col-md-3 col-xs-6'></li>")
      li.html(renderChoiceArcana(a))
      li.hide()
      ul.append(li)
      addFavHandlerForChoice(a)
      li.fadeIn('slow')

  renderSkillName = (a) ->
    return '' unless a
    render = "#{a.skill.name}"
    unless _.isEmpty(a.skill2)
      render += "/#{a.skill2.name}"
    render

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
                <div class='pull-right mini info'>
                  <input type='checkbox' id='fav-#{a.jobCode}' class='' data-job-code='#{a.jobCode}'>
                  <button type='button' class='btn btn-default btn-xs view-info' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>Info</button>
                </div>
                <div class='pull-left overflow'>
                  <span class='text-muted small'>#{a.title}</span><br>
                  <strong>#{a.name}</strong>
                </div>
              </small>
            </p>
            <p class='clearfix'></p>
            <p>
              <small>
                <ul class='small text-muted list-unstyled summary-detail overflow'>
                  <li>#{a.maxAtk} / #{a.maxHp}</li>
                  <li>#{renderSkillName(a)} (#{a.skill.cost})</li>
                  <li>#{unless _.isEmpty(a.firstAbility.name) then a.firstAbility.name else 'なし'}<br>#{unless _.isEmpty(a.secondAbility.name) then a.secondAbility.name else 'なし'}</li>
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

  renderSummarySizeMember = (m) ->
    renderSummarySizeArcana(m, 'member')

  renderSummarySizeChain = (m) ->
    renderSummarySizeArcana(m, 'chain')

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
                <button type='button' class='btn btn-default btn-xs view-info pull-right info overflow' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>Info</button>
                <span class='text-muted small'>#{a.title}</span><br>
                <strong>#{a.name}</strong>
              </small>
            </p>
            <p>
              <small>
                <ul class='small text-muted list-unstyled summary-detail overflow'>
                  <li>#{a.maxAtk} / #{a.maxHp}</li>
                  <li>#{renderSkillName(a)} (#{a.skill.cost})</li>
                  <li>#{unless _.isEmpty(a.firstAbility.name) then a.firstAbility.name else 'なし'}<br>#{unless _.isEmpty(a.secondAbility.name) then a.secondAbility.name else 'なし'}</li>
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

  renderFullSizeArcana = (m) ->
    return renderSummarySizeArcana(m, 'full') if CommonView.isPhoneDevice()

    if m
      a = m.arcana

      "
        <div class='#{a.jobClass} full-size arcana' data-job-code='#{a.jobCode}'>
          <div class='#{a.jobClass}-title arcana-title small'>
            #{a.jobNameShort} : #{a.rarityStars}
            <span class='badge pull-right'>#{renderArcanaCost(m)}</span>
          </div>
          <div class='arcana-body'>
            <p class='arcana-name overflow'>
                <button type='button' class='btn btn-default btn-xs view-info pull-right info' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>Info</button>
                <span class='text-muted small'>#{a.title}</span><br>
                <strong>#{a.name}</strong>
            </p>
            <dl class='small text-muted arcana-detail overflow'>
              <dt>ATK / HP</dt>
              <dd> #{a.maxAtk} (#{a.limitAtk}) / #{a.maxHp} (#{a.limitHp})</dd>
              <dt>Skill</dt>
              <dd>#{renderSkillName(a)}(#{a.skill.cost})</dd>
              <dt>Ability</dt>
              <dd>
                <ul class='list-unstyled'>
                  <li>#{unless _.isEmpty(a.firstAbility.name) then a.firstAbility.name else 'なし'}</li>
                  <li>#{unless _.isEmpty(a.secondAbility.name) then a.secondAbility.name else 'なし'}</li>
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

  renderPartyList = (parties) ->
    $(".party-list").remove()
    return if parties.length < 1

    base = $("#party-list-header")
    _.forEach [(parties.length)..1], (i) ->
      pt = parties[i-1]
      return unless pt?.code
      comment = pt.comment || '名無しパーティー'
      li = "<li><a data-target='#' data-order='#{i}' class='party-list'>#{comment}</a></li>"
      base.after(li)
    @

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

  addFavHandlerForChoice = (a) ->
    $("#fav-#{a.jobCode}").bootstrapSwitch({
      state: Favorites.stateFor(a.jobCode)
      size: 'mini'
      onColor: 'warning'
      onText: '☆'
      offText: '★'
      labelWidth: '2'
      onSwitchChange: (e, state) ->
        target = $(e.target)
        Favorites.setState(target.data('jobCode'), state)
    })

  setEditMode = (mode) ->
    edit = $("#edit-area")
    btnText = $("#edit-state")
    btnIcon = $("#edit-icon")
    title = $("#edit-title")
    clear = $("#clear-area")

    if mode
      btnText.text("編集終了")
      btnIcon.removeClass("glyphicon-edit")
      btnIcon.addClass("glyphicon-check")
      $memberArea.addClass("well well-sm")
      title.show()
      edit.fadeIn()
      clear.show()
      renderPartyList(Parties.parties)
    else
      btnText.text("編集する")
      btnIcon.removeClass("glyphicon-check")
      btnIcon.addClass("glyphicon-edit")
      $memberArea.removeClass("well well-sm")
      title.hide()
      edit.fadeOut()
      clear.hide()
    editMode = mode
    @

  handleDropedArcana = (target, drag) ->
    code = drag.data('jobCode')
    key = memberKeyFromArea(target)
    org = members[key]
    swapKey = drag.data('parentKey')
    return if key == swapKey

    d = new Member(Arcana.forCode(code))
    if (org && org.arcana.name != d.arcana.name)
      spr = $('#select-proposal-replace')
      spr.empty()
      spr.append(renderSummarySizeChain(d))

      pc = new Member(org.arcana)
      pc.chainArcana = d.arcana
      rpc = renderSummarySizeChain(pc)

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
      $selectModal.modal('show')
    else
      replaceMemberArea(key, code, swapKey)
    @

  replaceMemberArea = (pos, code, swapPos) ->
    fromMember = (unless _.isEmpty(swapPos) then true else false)
    m = new Member(Arcana.forCode(code))
    if fromMember
      m.chainArcana = members[swapPos].chainArcana
    removeDuplicateMember(m) unless pos is 'friend'

    if (! fromMember) || pos is 'friend'
      setMemberArcana(pos, m)
      return

    setMemberArcana(swapPos, members[pos])
    setMemberArcana(pos, m)
    @

  removeDuplicateMember = (target) ->
    name1 = target.arcana.name
    name2 = target.chainArcana?.name

    _.forEach memberKeys, (k) ->
      return if k is 'friend'
      m = members[k]
      return unless m

      if m.arcana.name == name1 || (name2 && m.arcana.name == name2)
        clearMemberArcana(k)
        return

      return unless m.chainArcana
      if m.chainArcana.name == name1 || (name2 && m.chainArcana.name == name2)
        m.chainArcana = null
        setMemberArcana(k, m)
    @

  clearMemberArcana = (key) ->
    setMemberArcana(key, null)

  updateMemberArcana = (m) ->
    setMemberArcana(m.memberKey, m)

  setMemberArcana = (key, m) ->
    m.memberKey = key if m
    members[key] = m
    renderMemberArcana(key)
    calcCost()
    storeLastMembers()
    @
