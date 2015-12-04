class @Conditions

  conditions = {}

  @init: ->
    Searcher.loadConditions().flatMap (data)->
      conditions = data
      Bacon.once(conditions)

  @unions: ->
    conditions?.unions || []

  @sourceTypesFor: (category) ->
    conditions?.sources?[category] || []

  @skillCategorys: ->
    conditions?.skillcategorys || []

  @skillSubtypesFor: (skill) ->
    conditions?.skillsubs?[skill] || []

  @skillEffectTypesFor: (skill) ->
    conditions?.skilleffects?[skill] || []

  @abirityCategorys: ->
    conditions?.abilitycategorys || []

  @abirityEffectsFor: (category) ->
    conditions?.abilityeffects?[category] || []

  @abirityConditionsFor: (category) ->
    conditions?.abilityconditions?[category] || []

  @chainAbirityCategorys: ->
    conditions?.chainabilitycategorys || []

  @chainAbirityEffectsFor: (category) ->
    conditions?.chainabilityeffects?[category] || []

  @chainAbirityConditionsFor: (category) ->
    conditions?.chainabilityconditions?[category] || []

  @voiceactors: ->
    conditions?.voiceactors || []

  @voiceactorIdFor: (name) ->
    return null unless name
    rsl = _.find @voiceactors(), (v) -> v[1] is name
    return null unless rsl
    rsl[0]

  @voiceactorNameFor: (id) ->
    return '' unless id
    id = parseInt(id)
    rsl = _.find @voiceactors(), (v) -> v[0] is id
    return '' unless rsl
    rsl[1]

  @illustrators: ->
    conditions?.illustrators || []

  @illustratorIdFor: (name) ->
    return null unless name
    rsl = _.find @illustrators(), (v) -> v[1] is name
    return null unless rsl
    rsl[0]

  @illustratorNameFor: (id) ->
    return '' unless id
    id = parseInt(id)
    rsl = _.find @illustrators(), (v) -> v[0] is id
    return '' unless rsl
    rsl[1]
