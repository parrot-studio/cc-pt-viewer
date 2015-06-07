class window.Skill

  SKILL_TABLE =
    attack:
      name: '攻撃'
      types: ['one/short', 'one/line', 'one/combo', 'one/dash', 'one/rear',
        'one/jump', 'one/random', 'one/combination', 'range/line',
        'range/dash', 'range/forward', 'range/self', 'range/explosion',
        'range/drop', 'range/jump', 'range/blast', 'range/random',
        'range/line2', 'range/all']
      subname:
        'one/short': '単体・目前'
        'one/line': '単体・直線'
        'one/combo': '単体・連続'
        'one/dash': '単体・ダッシュ'
        'one/rear': '単体・最後列'
        'one/jump': '単体・ジャンプ'
        'one/random': '単体・ランダム'
        'one/combination': '単体・コンビネーション'
        'range/line': '範囲・直線'
        'range/dash': '範囲・ダッシュ'
        'range/forward': '範囲・前方'
        'range/self': '範囲・自分中心'
        'range/explosion': '範囲・自爆'
        'range/drop': '範囲・落下物'
        'range/jump': '範囲・ジャンプ'
        'range/blast': '範囲・爆発'
        'range/random': '範囲・ランダム'
        'range/line2': '範囲・直線2ライン'
        'range/laser': '範囲・レーザー'
        'range/all': '範囲・全体'
    heal:
      name: '回復'
      types: ['all/instant', 'all/cycle', 'all/reaction', 'one/self', 'one/worst']
      subname:
        'all/instant': '全体・即時'
        'all/cycle': '全体・オート'
        'all/reaction': '全体・ダメージ反応'
        'one/self': '単体・自分'
        'one/worst': '単体・一番低い対象'
    'song/dance':
      name: '歌・舞'
      types: ['buff', 'debuff']
      subname:
        buff: '味方上昇'
        debuff: '敵状態異常'
    buff:
      name: '能力UP'
      types: ['self', 'all', 'random']
      subname:
        self: '自身'
        all: '全体'
        random: 'ランダム'
    barrier:
      name: 'バリア'
      types: ['self', 'all']
      subname:
        self: '自身'
        all: '全体'
    area:
      name: '設置/領域'
      types: ['obstacle', 'bomb', 'continual', 'atkup', 'defdown']
      subname:
        obstacle: '[設置] 障害物'
        bomb: '[設置] 爆弾'
        continual: '[領域] 継続ダメージ'
        atkup: '[領域] 与えるダメージ上昇'
        defdown: '[領域] 受けるダメージ増加'

  EFFECT_TABLE =
    attack:
      types: ['fire', 'ice', 'push', 'down', 'blind', 'slow', 'poison',
        'freeze', 'curse', 'charge', 'shield_break', 'heal_all', 'pain',
        'kill_pierce', 'return']
      effectname:
        blind: '暗闇追加'
        charge: '溜め'
        curse: '呪い追加'
        down: 'ダウン追加'
        fire: '火属性'
        freeze: '凍結追加'
        heal_all: '全員を回復'
        ice: '氷属性'
        kill_pierce: '倒したら貫通'
        pain: '自分もダメージ'
        poison: '毒追加'
        push: '弾き飛ばし'
        return: '元の位置に戻る'
        shield_break: '盾破壊'
        slow: 'スロウ追加'
    heal:
      types: ['poison', 'blind', 'slow', 'freeze',
        'seal', 'weaken', 'down', 'atkup', 'defup']
      effectname:
        atkup: '与えるダメージ上昇'
        blind: '暗闇解除'
        defup: '受けるダメージ軽減'
        down: 'ダウン解除'
        freeze: '凍結解除'
        poison: '毒解除'
        seal: '封印解除'
        slow: 'スロウ解除'
        weaken: '衰弱解除'
    'song/dance':
      types: ['fire', 'ice', 'element', 'blind', 'freeze', 'guard_debuff',
        'debuff_blind', 'debuff_slow', 'debuff_poison']
      effectname:
        blind: '暗闇耐性'
        debuff_blind: '暗闇付与'
        debuff_slow: 'スロウ付与'
        debuff_poison: '毒付与'
        element: '属性軽減'
        fire: '炎属性軽減'
        freeze: '凍結耐性'
        guard_debuff: '状態異常耐性'
        ice: '氷属性軽減'
    buff:
      types: ['atkup', 'defup', 'speedup', 'fire', 'ice', 'delayoff', 'atkdown', 'defdown']
      effectname:
        atkup: '攻撃UP'
        atkdown: '攻撃DOWN'
        defup: '防御UP'
        defdown: '防御DOWN'
        delayoff: '攻撃間隔短縮'
        fire: '炎属性付与'
        ice: '氷属性付与'
        speedup: '移動速度UP'
    barrier:
      types: ['ice', 'element', 'blind', 'freeze', 'slow', 'weaken', 'debuff', 'invincible']
      effectname:
        blind: '暗闇耐性'
        debuff: '状態異常耐性'
        element: '属性軽減'
        freeze: '凍結耐性'
        ice: '氷軽減'
        invincible: '無敵'
        slow: 'スロウ耐性'
        weaken: '衰弱耐性'
    area:
      types: ['fire', 'poison', 'slow', 'blind']
      effectname:
        fire: '炎属性'
        poison: '毒付与'
        slow: 'スロウ付与'
        blind: '暗闇付与'

  constructor: (data) ->
    @name = data.name || '？'
    @explanation = data.explanation || ''
    @cost = data.cost || '？'
    @effects = []
    if data.effects
      for e in data.effects
        d =
          category: e.category
          subcategory: e.subcategory
          subeffect1: e.subeffect1 || ''
          subeffect2: e.subeffect2 || ''
          subeffect3: e.subeffect3 || ''
        @effects.push d

  @subeffectForEffect: (ef) ->
    return [] unless ef
    ret = []
    ret.push(ef.subeffect1) unless ef.subeffect1 == ''
    ret.push(ef.subeffect2) unless ef.subeffect2 == ''
    ret.push(ef.subeffect3) unless ef.subeffect3 == ''
    ret

  @typeNameFor = (s) -> SKILL_TABLE[s]?.name || '？'
  @subtypesFor = (s) -> SKILL_TABLE[s]?.types || []
  @subnameFor = (skill, sub) -> SKILL_TABLE[skill]?.subname?[sub] || '？'
  @effectTypesFor = (s) -> EFFECT_TABLE[s]?.types || []
  @effectNameFor = (s, e) -> EFFECT_TABLE[s]?.effectname?[e] || ''
