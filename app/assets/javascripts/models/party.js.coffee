class @Party

  memberKeys = ['mem1', 'mem2', 'mem3', 'mem4', 'sub1', 'sub2', 'friend']
  @ptver = null

  @create: -> new Party()

  @build: (as) ->
    pt = new Party()
    pt.build(as)
    pt

  constructor: ->
    @members = {}
    @cost = 0

  createCode: ->
    header = 'V' + Party.ptver
    code = ''
    mems = @members
    _.forEach memberKeys, (k) ->
      m = mems[k]
      if m
        code += m.arcana.jobCode
        code += (if m.chainArcana then m.chainArcana.jobCode else 'N')
      else
        code += 'NN'
    if (/^N+$/).test(code) then '' else (header + code)

  build: (as) ->
    _.forEach memberKeys, (k) =>
      mb = as[k]
      mc = as[k + 'c']
      if mb
        mem = new Member(mb)
        mem.chainArcana = mc if mc
        @addMember(k, mem)
      else
        @addMember(k, null)
    @

  memberFor: (key) ->
    @members[key]

  addMember: (key, m) ->
    if (m && key != "friend")
      @members = removeDuplicateMember(@members, m)
    m.memberKey = key if m
    @members[key] = m
    @cost = costForMembers(@members)
    @

  removeMember: (key) ->
    @addMember(key, null)

  removeChain: (key) ->
    m = @memberFor(key)
    return unless m
    @addMember(key, new Member(m.arcana))

  reset: ->
    @members = {}
    @cost = 0

  swap: (ak, bk) ->
    am = @memberFor(ak)
    bm = @memberFor(bk)
    @addMember(ak, bm)
    @addMember(bk, am)

  copyFromFriend: (k) ->
    fm = @memberFor("friend")
    return unless fm
    m = new Member(fm.arcana)
    m.chainArcana = fm.chainArcana
    @addMember(k, m)

  removeDuplicateMember = (mems, target) ->
    ta = target.arcana
    tc = target.chainArcana

    _.forEach memberKeys, (k) ->
      return if k is 'friend'
      m = mems[k]
      return unless m

      if Arcana.sameArcana(m.arcana, ta) || Arcana.sameArcana(m.arcana, tc)
        mems[k] = null
        return

      return unless m.chainArcana
      if Arcana.sameArcana(m.chainArcana, ta) || Arcana.sameArcana(m.chainArcana, tc)
        mems[k] = new Member(m.arcana)
    mems

  costForMembers = (mems) ->
    cost = 0
    _.forEach mems, (m, k) ->
      return if (k == "friend" || !m)
      cost += m.chainedCost()
    cost
