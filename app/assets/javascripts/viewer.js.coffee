class Skill

  SKILL_TABLE =
    attack:
      name: '攻撃'
      types: ['one/short', 'one/line', 'one/combo', 'one/dash', 'one/rear',
        'range/line', 'range/dash', 'range/forward', 'range/self', 'range/explosion',
        'range/drop', 'range/jump', 'range/random', 'range/all']
      subname:
        'one/short': '単体・目前'
        'one/line': '単体・直線'
        'one/combo': '単体・連続'
        'one/dash': '単体・ダッシュ'
        'one/rear': '単体・最後列'
        'range/line': '範囲・直線'
        'range/dash': '範囲・ダッシュ'
        'range/forward': '範囲・前方'
        'range/self': '範囲・自分中心'
        'range/explosion': '範囲・自爆'
        'range/drop': '範囲・落下物'
        'range/jump': '範囲・ジャンプ'
        'range/random': '範囲・ランダム'
        'range/all': '範囲・全体'
    heal:
      name: '回復'
      types: ['all/instant', 'all/cycle', 'one/self', 'one/worst']
      subname:
        'all/instant': '全体・即時'
        'all/cycle': '全体・オート'
        'one/self': '単体・自分'
        'one/worst': '単体・一番低い対象'
    'song/dance':
      name: '歌・舞'
      types: ['buff', 'debuff']
      subname:
        buff: '味方上昇'
        debuff: '敵状態異常'
    other:
      name: '補助'
      types: ['buff/self', 'buff/all', 'buff/random',
        'barrier', 'obstacle', 'invincible', 'element']
      subname:
        'buff/self': '自身能力UP'
        'buff/all': '全体能力UP'
        'buff/random': 'ランダムに一人能力UP'
        barrier: 'バリアー'
        obstacle: '障害物'
        invincible: '無敵'
        element: '属性付与'

  constructor: (data) ->
    @name = data.name || '？'
    @category = data.category || ''
    @subcategory = data.subcategory || ''
    @explanation = data.explanation || ''
    @cost = data.cost || '？'

  @typeNameFor = (s) -> SKILL_TABLE[s]?.name || '？'
  @subtypesFor = (s) -> SKILL_TABLE[s]?.types || []
  @subnameFor = (skill, sub) -> SKILL_TABLE[skill]?.subname?[sub] || '？'

class Ability

  CONDITION_TABLE =
    any: 'いつでも'
    attack: '通常攻撃時'
    battle_end: '戦闘終了時'
    battle_start: '戦闘開始時'
    boss_wave: 'BOSS WAVE時'
    critical: 'クリティカル時'
    cycle: '一定間隔で'
    dropout_member: '味方が脱落した時'
    dropout_self: '自身が脱落した時'
    for_debuff: '敵が状態異常時'
    heal: '回復時'
    hp_downto: 'HPが一定以下の時'
    hp_downto_more: 'HPがより低い時'
    hp_full: 'HPが満タンの時'
    hp_upto: 'HPが一定以上の時'
    hp_upto_more: 'HPがより高い時'
    in_combo: '攻撃を一定回数当てた時'
    in_debuff: '自分が状態異常時'
    in_field: '特定のフィールドで'
    in_move: '移動中'
    in_sub: 'サブパーティーにいる時'
    kill: '敵を倒した時'
    killer: '特定の敵に対して'
    mana_charged: 'マナが多いほど'
    skill: 'スキル使用時'
    union: '特定の職構成の時'
    wave_start: '各WAVE開始時'

  CONDITION_LIST = [
    'any'
    'hp_upto'
    'hp_downto'
    'hp_downto_more'
    'hp_full'
    'attack'
    'critical'
    'skill'
    'in_combo'
    'kill'
    'heal'
    'in_move'
    'killer'
    'mana_charged'
    'boss_wave'
    'wave_start'
    'cycle'
    'for_debuff'
    'in_debuff'
    'dropout_member'
    'dropout_self'
    'battle_start'
    'battle_end'
    'in_field'
    'union'
    'in_sub'
  ]

  EFFECT_TABLE =
    absorb:
      name: '与えたダメージを吸収'
      conditions: ['attack', 'critical']
    ap_recover:
      name: 'APを回復'
      conditions: []
    areaup:
      name: '回復範囲増加'
      conditions: []
    atkup:
      name: '与えるダメージ上昇'
      conditions: ['any', 'hp_upto', 'hp_upto_more', 'hp_downto', 'hp_downto_more',
        'hp_full', 'attack', 'critical', 'skill', 'in_combo', 'kill', 'killer',
        'mana_charged', 'boss_wave', 'wave_start', 'for_debuff', 'in_debuff',
        'dropout_member']
    atkup_all:
      name: '全員の与えるダメージ上昇'
      conditions: ['any', 'in_sub']
    boost_heal:
      name: '回復効果上昇'
      conditions: []
    buff:
      name: '自身のステータス上昇'
      conditions: ['any', 'hp_upto', 'hp_downto', 'hp_full', 'attack',
        'in_combo', 'kill', 'killer', 'boss_wave', 'wave_start', 'in_debuff',
        'dropout_member', 'in_field', 'union']
    buff_all:
      name: '全員のステータス上昇'
      conditions: ['any', 'in_sub', 'dropout_self']
    buff_jobs:
      name: '特定の職がステータス上昇'
      conditions: ['any', 'union']
    combat:
      name: '接近戦可能'
      conditions: []
    critup:
      name: 'クリティカル率上昇'
      conditions: []
    debuff:
      name: '状態異常付与'
      conditions: ['attack', 'critical', 'skill']
    defup:
      name: '受けるダメージ軽減'
      conditions: ['any', 'hp_downto', 'boss_wave', 'wave_start', 'in_debuff']
    defup_all:
      name: '全員のダメージ軽減'
      conditions: ['any', 'in_sub']
    delayoff:
      name: '攻撃間隔が早くなる'
      conditions: []
    element:
      name: '属性攻撃'
      conditions: []
    expup:
      name: '獲得経験値上昇'
      conditions: []
    goldup:
      name: '獲得金額上昇'
      conditions: []
    guard_debuff:
      name: '特定の状態異常無効'
      conditions: []
    guardup:
      name: '遠距離ダメージカット上昇'
      conditions: []
    heal_all:
      name: '全員を回復'
      conditions: ['wave_start', 'dropout_self']
    heal_self:
      name: '自身を回復'
      conditions: ['wave_start', 'cycle']
    heal_worst:
      name: '一番ダメージが大きい対象を回復'
      conditions: []
    healup:
      name: '回復量上昇'
      conditions: []
    invisible:
      name: '見えなくなる（遠距離無効）'
      conditions: []
    mana_boost:
      name: 'スロットで複数マナが出やすい'
      conditions: []
    mana_charge:
      name: 'マナを持って開始'
      conditions: []
    mana_drop:
      name: 'マナを落とす'
      conditions: []
    pierce:
      name: '貫通攻撃'
      conditions: ['attack', 'kill']
    slot_slow:
      name: 'マナスロットが遅くなる'
      conditions: []
    speedup:
      name: '移動速度上昇'
      conditions: ['any', 'in_combo']
    speedup_all:
      name: '全員の移動速度上昇'
      conditions: []
    treasure:
      name: '宝箱が出やすくなる'
      conditions: []

  EFFECT_LIST = [
    'atkup'
    'defup'
    'guardup'
    'speedup'
    'critup'
    'delayoff'
    'buff'
    'guard_debuff'
    'element'
    'healup'
    'areaup'
    'boost_heal'
    'heal_self'
    'heal_worst'
    'heal_all'
    'debuff'
    'absorb'
    'mana_drop'
    'invisible'
    'combat'
    'pierce'
    'atkup_all'
    'defup_all'
    'speedup_all'
    'buff_all'
    'buff_jobs'
    'mana_charge'
    'mana_boost'
    'slot_slow'
    'treasure'
    'expup'
    'goldup'
    'ap_recover'
  ]

  @conditions = -> CONDITION_LIST
  @conditionNameFor = (c) -> CONDITION_TABLE[c] || ''
  @effects = -> EFFECT_LIST
  @effectNameFor = (e) -> EFFECT_TABLE[e]?.name || ''
  @conditionsFor = (e) -> EFFECT_TABLE[e]?.conditions || []

  constructor: (data) ->
    @name = data.name || ''
    @conditionType = data.condition_type || ''
    @effectType = data.effect_type || ''
    @conditionTypeSecond = data.condition_type_second || ''
    @effectTypeSecond = data.effect_type_second || ''
    @explanation = data.explanation || ''

class Arcana

  JOB_NAME =
    F: '戦士'
    K: '騎士'
    A: '弓使い'
    M: '魔法使い'
    P: '僧侶'

  JOB_NAME_SHORT =
    F: '戦'
    K: '騎'
    A: '弓'
    M: '魔'
    P: '僧'

  CLASS_NAME =
    F: 'fighter'
    K: 'knight'
    A: 'archer'
    M: 'magician'
    P: 'priest'

  WEAPON_NAME =
    Sl: '斬'
    Bl: '打'
    Pi: '突'
    Ar: '弓'
    Ma: '魔'
    He: '聖'
    Pu: '拳'
    Gu: '銃'
    Sh: '狙'

  GROWTH_TYPE =
    fast:   '早熟'
    normal: '普通'
    slow:   '晩成'

  SOURCE_NAME =
    guildtown: '副都・酒場'
    holytown: '聖都・酒場'
    academy: '賢者の塔・酒場'
    mountain: '迷宮山脈・酒場'
    oasis: '湖都・酒場'
    forest: '精霊島・酒場'
    volcano: '九領・酒場'
    'forest-sea': '海風の港・酒場'
    dawnsea: '夜明けの大海・酒場'
    ring: 'リング'
    demon: '魔神戦'
    score: '戦の年代記'
    event: '期間限定'
    collaboration: 'コラボ限定'
    other: 'その他'

  constructor: (data) ->
    @name = data.name
    @title = data.title
    @rarity = data.rarity
    @cost = data.cost
    @jobType = data.job_type
    @jobIndex = data.job_index
    @jobCode = data.job_code
    @jobName = JOB_NAME[@jobType]
    @jobNameShort = JOB_NAME_SHORT[@jobType]
    @rarityStars = '★★★★★★'.slice(0, @rarity)
    @jobClass = CLASS_NAME[@jobType]
    @hometown = data.hometown
    @weaponType = data.weapon_type
    @weaponName = WEAPON_NAME[@weaponType]
    @voiceActor = data.voice_actor
    @voiceActor = '？' if @voiceActor == ''
    @illustrator = data.illustrator
    @illustrator = '？' if @illustrator == ''
    @growthType = data.growth_type
    @growthTypeName = GROWTH_TYPE[@growthType]
    @source = data.source
    @sourceName = SOURCE_NAME[@source]
    @jobDetail = data.job_detail
    @maxAtk = (data.max_atk || '-')
    @maxHp = (data.max_hp || '-')
    @limitAtk = (data.limit_atk || '-')
    @limitHp = (data.limit_hp || '-')

    @skill = new Skill(data.skill)
    @firstAbility = new Ability(data.first_ability)
    @secondAbility = new Ability(data.second_ability)

  @jobNameFor = (j) -> JOB_NAME[j]
  @jobShortNameFor = (j) -> JOB_NAME_SHORT[j]
  @weaponNameFor = (w) -> WEAPON_NAME[w]
  @growthTypeNameFor = (g) -> GROWTH_TYPE[g]
  @sourceNameFor = (s) -> SOURCE_NAME[s]

class Arcanas

  arcanas = {}
  resultCache = {}

  constructor: () ->

  createQueryKey = (query) ->
    key = ""
    key += "recently_" if query.recently
    key += "j#{query.job}_" if query.job
    key += "r#{query.rarity}_" if query.rarity
    key += "s#{query.source}_" if query.source
    key += "w#{query.weapon}_" if query.weapon
    key += "g#{query.growth}_" if query.growth
    if query.skill
      key += "sk#{query.skill}_"
      key += "subsk#{query.skillsub}_" if query.skillsub
    key += "a#{query.actor}_" if query.actor
    key += "i#{query.illustrator}_" if query.illustrator
    key += "abc#{query.abiritycond}_" if query.abiritycond
    key += "abe#{query.abirityeffect}_" if query.abirityeffect
    key

  search: (query, url, callbacks) ->
    key = createQueryKey(query)
    cached = resultCache[key]
    if cached
      as = (arcanas[code] for code in cached)
      callbacks.done(as)
      return

    xhr = $.getJSON url, query
    xhr.done (datas) ->
      as = []
      for data in datas
        a = new Arcana(data)
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as.push a
      cs = (a.jobCode for a in as)
      resultCache[key] = cs
      callbacks.done(as)
    xhr.fail ->
      callbacks.fail()

  searchMembers: (query, url, callbacks) ->
    xhr = $.getJSON url, query
    xhr.done (datas) ->
      as = {}
      for mem, data of datas
        continue unless data
        a = new Arcana(data)
        continue unless a
        arcanas[a.jobCode] = a unless arcanas[a.jobCode]
        as[mem] = a
      callbacks.done(as)
    xhr.fail ->
      callbacks.fail()

  forCode: (code) -> arcanas[code]

class Cookie

  $.cookie.json = true;
  cookieKey = 'ccpts'
  expireDate = 7

  @set = (data) ->
    d = $.extend(@get(), (data || {}));
    $.cookie(cookieKey, d, {expires: expireDate})

  @get = ->
    $.cookie(cookieKey) || {}

  @clear = ->
    $.removeCookie(cookieKey)

  @replace = (data) ->
    $.cookie(cookieKey, (data || {}), {expires: expireDate})

  @delete = (key) ->
    c = @get()
    delete c[key]
    @replace(c)

  @valueFor = (key) ->
    c = @get()
    c[key]

class Viewer

  arcanas = new Arcanas()
  members = ['mem1', 'mem2', 'mem3', 'mem4', 'sub1', 'sub2', 'friend']
  resultCache = {}
  onEdit = false
  defaultMemberCode = 'V1F36K7A1P2P24NN'

  constructor: ->
    initHandler()
    initMembers()

  eachMembers = (func) ->
    for m in members
      func(m)

  memberAreaFor = (m) ->
    $("#member-character-#{m}")

  eachMemberAreas = (func) ->
    eachMembers (m) ->
      func(memberAreaFor(m))

  eachMemberOnlyAreas = (func) ->
    eachMembers (m) ->
      func(memberAreaFor(m)) unless m == 'friend'

  eachMemberCode = (func) ->
    eachMemberAreas (area) ->
      c = area.children('div').data("jobCode")
      func(c)

  eachMemberOnlyCode = (func) ->
    eachMemberOnlyAreas (area) ->
      c = area.children('div').data("jobCode")
      func(c)

  renderFullSizeArcana = (a) ->
    if a
      "
        <div class='#{a.jobClass} full-size arcana' data-job-code='#{a.jobCode}'>
          <div class='#{a.jobClass}-title arcana-title small'>
            #{a.jobNameShort} : #{a.rarityStars}
            <span class='badge pull-right'>#{a.cost}</span>
          </div>
          <div class='arcana-body'>
            <p class='arcana-name'>
                <span class='text-muted small'>#{a.title}</span><br>
                <strong>#{a.name}</strong>
                <button type='button' class='btn btn-default btn-xs view-info pull-right' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>Info</button>
            </p>
            <dl class='small text-muted arcana-detail'>
              <dt>ATK / HP</dt>
              <dd> #{a.maxAtk} / #{a.maxHp}#{unless a.limitAtk == '-' then '<br>( ' + a.limitAtk + ' / ' + a.limitHp + ' )' else '' }</dd>
              <dt>Skill</dt>
              <dd>#{a.skill.name} (#{a.skill.cost})</dd>
              <dt>Ability</dt>
              <dd>#{if a.firstAbility.name != '' then a.firstAbility.name else 'なし'}#{if a.secondAbility.name != '' then (' / ' + a.secondAbility.name) else ''}</dd>
            </dl>
          </div>
          <div class='#{a.jobClass}-footer arcana-footer'>
          </div>
        </div>
      "
    else
      "<div class='none full-size arcana'></div>"

  renderSummarySizeArcana = (a, cl) ->
    if a
      div = "
        <div class='#{a.jobClass} #{cl} summary-size arcana' data-job-code='#{a.jobCode}'>
          <div class='#{a.jobClass}-title arcana-title small'>
            #{a.jobNameShort}:#{a.rarityStars} <span class='badge badge-sm pull-right'>#{a.cost}</span>
          </div>
          <div class='arcana-summary'>
            <p>
              <small>
                <span class='text-muted small'>#{a.title}</span><br>
                <strong>#{a.name}</strong>
                </small>
                <button type='button' class='btn btn-default btn-xs view-info pull-right' data-job-code='#{a.jobCode}' data-toggle='modal' data-target='#view-modal'>Info</button>
                </small>
            </p>
            <p>
              <small>
                <ul class='small text-muted list-unstyled'>
                  <li>ATK/HP:#{a.maxAtk}/#{a.maxHp}</li>
                  <li>#{a.skill.name} (#{a.skill.cost})</li>
                  <li>#{if a.firstAbility.name != '' then a.firstAbility.name else 'なし'}#{if a.secondAbility.name != '' then (' / ' + a.secondAbility.name) else ''}</li>
                </ul>
              </small>
            </p>
          </div>
      "
      if cl == 'member'
        div += '<button type="button" class="close close-member" aria-hidden="true">&times;</button>'
      div += '</div>'
      div

      d = $(div)
      d.draggable(
        connectToSortable: false
        containment: false
        helper: 'clone'
        opacity: 0.7
        zIndex: 10000
      )
    else
      d = $("<div class='none #{cl} summary-size arcana'></div>")
    d

  renderSummarySizeMember = (a) ->
    renderSummarySizeArcana(a, 'member')

  renderAbility = (ab) ->
    return "なし" if ab.name == ''

    render = "
      #{ab.name}
      <ul class='small text-muted list-unstyled ability-detail'>
        <li>#{Ability.conditionNameFor(ab.conditionType)} - #{Ability.effectNameFor(ab.effectType)}</li>
    "
    unless ab.conditionTypeSecond == ''
      render += "  <li>#{Ability.conditionNameFor(ab.conditionTypeSecond)} - #{Ability.effectNameFor(ab.effectTypeSecond)}</li>"
    render += "</ul>"
    render

  renderArcanaDetail = (a) ->
    return '' unless a

    "
      <div class='#{a.jobClass} arcana'>
        <div class='#{a.jobClass}-title arcana-title'>
          #{a.jobName} : #{a.rarityStars}
          <span class='badge pull-right'>#{a.cost}</span>
        </div>
        <div class='arcana-view-body'>
          <h4 class='arcana-name' id='view-modal-label'>
            <span class='text-muted'>#{a.title}</span>
            <strong>#{a.name}</strong>
          </h4>
          <div class='row'>
            <div class='col-xs-12 col-sm-6 col-md-6'>
              <dl class='small arcana-view-detail'>
                <dt>職業</dt>
                <dd>#{a.jobDetail}</dd>
                <dt>ATK / HP</dt>
                <dd> #{a.maxAtk} / #{a.maxHp}<br>( #{a.limitAtk} / #{a.limitHp} )</dd>
                <dt>武器タイプ</dt>
                <dd>#{a.weaponName}</dd>
                <dt>成長タイプ</dt>
                <dd>#{a.growthTypeName}</dd>
                <dt>声優</dt>
                <dd>#{a.voiceActor}</dd>
                <dt>イラストレーター</dt>
                <dd>#{a.illustrator}</dd>
              </dl>
            </div>
            <div class='col-xs-12 col-sm-6 col-md-6'>
              <dl class='small arcana-view-detail'>
                <dt>スキル</dt>
                <dd>
                  #{a.skill.name} (#{a.skill.cost})<br>
                  （#{Skill.typeNameFor(a.skill.category)} - #{Skill.subnameFor(a.skill.category, a.skill.subcategory)}）
                </dd>
                <dt>アビリティ1</dt>
                <dd>#{renderAbility(a.firstAbility)}</dd>
                <dt>アビリティ2</dt>
                <dd>#{renderAbility(a.secondAbility)}</dd>
                <dt>入手先</dt>
                <dd>#{a.sourceName}</dd>
              </dl>
            </div>
          </div>
        </div>
      </div>
    "

  replaceMemberArcana = (div, ra) ->
    div.empty()
    a = $(ra)
    a.hide()
    div.append(a)
    a.attr('data-parent-id', div.attr('id'))
    a.fadeIn()

  replaceMemberArea = ->
    eachMemberAreas (div) ->
      code = div.children('div').data("jobCode")
      a = arcanas.forCode(code)
      if onEdit
        replaceMemberArcana(div, renderSummarySizeMember(a))
      else
        replaceMemberArcana(div, renderFullSizeArcana(a))

  replaceChoiceArea = (as, detail) ->
    ul = $('#choice-characters')
    ul.empty()
    for a in as
      li = $("<li class='listed-character col-sm-4 col-md-3'></li>")
      li.html(renderSummarySizeArcana(a, 'choice'))
      li.hide()
      ul.append(li)
      li.fadeIn('slow')
    $("#detail").html(detail)
    @

  searchArcanas = (query, path, callback) ->
    $("#error").hide()
    query ?= {}
    query.ver = $("#data-ver").val()
    url = $("#app-path").val() + path
    callbacks =
      done: (as) -> callback(as)
      fail: -> $("#error-area").show()

    if path == 'ptm'
      arcanas.searchMembers(query, url, callbacks)
    else
      arcanas.search(query, url, callbacks)

  searchMembers = (ptm, edit) ->
    query = ptm: ptm
    searchArcanas query, 'ptm', (as) ->
      eachMembers (mem) ->
        div = memberAreaFor(mem)
        render = if edit
          renderSummarySizeMember(as[mem])
        else
          renderFullSizeArcana(as[mem])
        replaceMemberArcana div, render
      calcCost()

  resetQuery = ->
    $("#job").val('')
    $("#rarity").val('')
    $("#weapon").val('')
    $("#actor").val('')
    $("#illustrator").val('')
    $("#growth").val('')
    $("#source").val('')
    $("#skill").val('')
    $("#skill-sub").empty().append("<option value=''>-</option>")
    $("#ability-effect").val('')
    $("#ability-condition").empty().append("<option value=''>-</option>")

    $("#additional-condition").hide()
    $("#add-condition").show()
    @

  buildQuery = ->
    job = $("#job").val()
    rarity = $("#rarity").val()
    weapon = $("#weapon").val()
    actor = $("#actor").val()
    illst = $("#illustrator").val()
    growth = $("#growth").val()
    source = $("#source").val()
    skill = $("#skill").val()
    abirityCond = $("#ability-condition").val()
    abirityEffect = $("#ability-effect").val()
    return {recently: true} if (job == '' && rarity == '' && weapon == '' && actor == '' && illst == '' && growth == '' && source == '' && skill == '' && abirityCond == '' && abirityEffect == '')

    query = {}
    query.job = job unless job == ''
    query.rarity = rarity unless rarity == ''
    query.weapon = weapon unless weapon == ''
    query.actor = actor unless actor == ''
    query.illustrator = illst unless illst == ''
    query.growth = growth unless growth == ''
    query.source = source unless source == ''
    query.abiritycond = abirityCond unless abirityCond == ''
    query.abirityeffect = abirityEffect unless abirityEffect == ''

    unless skill == ''
      query.skill = skill
      skillsub = $("#skill-sub").val()
      query.skillsub = skillsub unless skillsub == ''
    query

  createQueryDetail = (query) ->
    elem = []
    if query.recently
      elem.push '最新'
    if query.job
      elem.push Arcana.jobNameFor(query.job)
    if query.rarity
      elem.push "★#{query.rarity.replace(/U/, '以上')}"
    if query.skill
      text = 'スキル - ' + Skill.typeNameFor(query.skill)
      text += ('（' + Skill.subnameFor(query.skill, query.skillsub) + '）') if query.skillsub
      elem.push text
    if query.abiritycond || query.abirityeffect
      text = 'アビリティ - ' + Ability.conditionNameFor(query.abiritycond) + ' ' + Ability.effectNameFor(query.abirityeffect)
      elem.push text
    if query.source
      elem.push '入手先 - ' + Arcana.sourceNameFor(query.source)
    if query.weapon
      elem.push '武器タイプ - ' + Arcana.weaponNameFor(query.weapon)
    if query.growth
      elem.push '成長タイプ - ' + Arcana.growthTypeNameFor(query.growth)
    if query.actor
      elem.push '声優 - ' + $("#actor :selected").text()
    if query.illustrator
      elem.push 'イラスト - ' + $("#illustrator :selected").text()
    ul = '<ul class="list-unstyled small">'
    for e in elem
      ul += "<li>#{e}</li>"
    ul += '</ul>'
    ul

  searchTargets = ->
    query = buildQuery()
    unless query
      replaceChoiceArea([], '')
      return
    searchArcanas query, 'arcanas', (as) ->
      replaceChoiceArea as, createQueryDetail(query)

  toggleEditMode = ->
    edit = $("#edit-area")
    member = $("#member-area")
    btn = $("#edit-members")
    title = $("#edit-title")
    reset = $("#reset-members")

    if onEdit
      onEdit = false
      btn.text("編集する")
      member.removeClass("well well-sm")
      title.hide()
      reset.hide()
      edit.fadeOut()
    else
      onEdit = true
      btn.text("編集終了")
      member.addClass("well well-sm")
      title.show()
      reset.show()
      edit.fadeIn()
      searchTargets()
    #replaceMemberArea()
    @

  clearMemberArcana = (div) ->
    replaceMemberArcana(div, renderSummarySizeMember(null))

  removeDuplicateMember = (code) ->
    mems = $(".member")
    for m in mems
      mem = $(m)
      parent = mem.parent()
      continue if parent.hasClass('friend')
      c = mem.data("jobCode")
      continue unless c == code
      clearMemberArcana(parent)
    @

  createMembersCode = ->
    header = 'V' + $("#pt-ver").val()
    code = ''
    eachMemberCode (c) ->
      code += (c || 'N')
    if (/^N+$/).test(code) then '' else (header + code)

  calcCost = ->
    cost = 0
    eachMemberOnlyCode (code) ->
      a = arcanas.forCode(code)
      return unless a
      cost = cost + a.cost
    $("#cost").text(cost)

  isFirstAccess = ->
    if Cookie.valueFor('tutorial') then false else true

  showTutorial = ->
    $("#tutorial").show()
    Cookie.set({tutorial: true})

  isShowLatestInfo = ->
    ver = $("#latest-info-ver").val()
    return true if ver == ''
    showed = Cookie.valueFor('latest-info')
    return false unless showed
    if ver == showed then true else false

  showLatestInfo = ->
    ver = $("#latest-info-ver").val()
    $("#latest-info").show()
    Cookie.set({'latest-info': ver})

  createSkillOptions = ->
    target = $("#skill-sub")
    target.empty()
    skill = $("#skill").val()
    if skill == ''
      target.append("<option value=''>-</option>")
      return
    types = Skill.subtypesFor(skill)
    target.append("<option value=''>（全て）</option>")
    for t in types
      target.append("<option value='#{t}'>#{Skill.subnameFor(skill, t)}</option>")
    @

  createArcanaDetail = (code) ->
    a = arcanas.forCode(code)
    view = $("#view-detail")
    view.empty()
    view.append(renderArcanaDetail(a))
    @

  createAbilityEffects = ->
    target = $("#ability-effect")
    target.empty()
    target.append("<option value=''>-</option>")
    for e in Ability.effects()
      target.append("<option value='#{e}'>#{Ability.effectNameFor(e)}</option>")
    @

  createAbilityConditions = ->
    target = $("#ability-condition")
    target.empty()
    abi = $("#ability-effect").val()
    if abi == ''
      target.append("<option value=''>-</option>")
      return
    conds = Ability.conditionsFor(abi)
    target.append("<option value=''>（全て）</option>")
    for c in conds
      target.append("<option value='#{c}'>#{Ability.conditionNameFor(c)}</option>")
    @

  initHandler = ->
    $("#error-area").hide()
    $("#error-area").removeClass("invisible")
    $("#edit-area").hide()
    $("#edit-area").removeClass("invisible")
    $("#edit-title").hide()
    $("#edit-title").removeClass("invisible")
    $("#tutorial").hide()
    $("#tutorial").removeClass("invisible")
    $("#reset-members").hide()
    $("#reset-members").removeClass("invisible")
    $("#additional-condition").hide()

    if isFirstAccess()
      showTutorial()
      $("#latest-info").hide()
    else
      if isShowLatestInfo()
        $("#latest-info").hide()
      else
        showLatestInfo()

    createAbilityEffects()

    $(".member-character").droppable(
      drop: (e, ui) ->
        e.preventDefault()
        drag = ui.draggable
        code = drag.data('jobCode')
        target = $(e.target)

        unless target.hasClass('friend')
          removeDuplicateMember(code)
          if drag.hasClass('member')
            orgCode = target.children('div').data("jobCode")
            replaceMemberArcana($("##{drag.data('parentId')}"),
              renderSummarySizeMember(arcanas.forCode(orgCode)))

        replaceMemberArcana(target,
          renderSummarySizeMember(arcanas.forCode(code)))
        calcCost()
    )

    $("#edit-members").hammer().on 'tap', (e) ->
      e.preventDefault()
      toggleEditMode()

    $("#search").hammer().on 'tap', (e) ->
      e.preventDefault()
      searchTargets()
      $("#search-modal").modal('hide')

    $("#member-area").on 'click', 'button.close-member', (e) ->
      e.preventDefault()
      member = $(e.target).parents(".member-character")
      clearMemberArcana(member)
      calcCost()

    $("#share-modal").on 'show.bs.modal', (e) ->
      code = createMembersCode()
      url = $("#app-path").val() + code
      $("#ptm-code").val(url)

      twitterUrl = "https://twitter.com/intent/tweet"
      twitterUrl += "?text=#{encodeURIComponent('チェンクロパーティーシミュレーター ' + url)}"
      twitterUrl += "&hashtags=ccpts"
      $("#twitter-share").attr('href', twitterUrl)
      true # for modal

    $("#ptm-code").on 'click forcus', (e) ->
      $(e.target).select()
      e.preventDefault()

    $("#reset-members").hammer().on 'tap', (e) ->
      e.preventDefault()
      eachMemberAreas (area) ->
        clearMemberArcana(area)
      $("#cost").text('0')

    $("#search-clear").hammer().on 'tap', (e) ->
      e.preventDefault()
      resetQuery()

    $("#add-condition").hammer().on 'tap', (e) ->
      e.preventDefault()
      $("#add-condition").hide()
      $("#additional-condition").fadeIn('fast')

    $("#skill").on 'change', (e) ->
      e.preventDefault()
      createSkillOptions()

    $("#ability-effect").on 'change', (e) ->
      e.preventDefault()
      createAbilityConditions()

    $("#view-modal").on 'show.bs.modal', (e) ->
      code = $(e.relatedTarget).data('jobCode')
      createArcanaDetail(code)
      true # for modal

    @

  initMembers = ->
    ptm = $("#ptm").val()
    if ptm == ''
      toggleEditMode() if window.innerWidth >= 768
      searchMembers(defaultMemberCode, onEdit)
    else
      searchMembers(ptm)
    @

$ -> (new Viewer())
