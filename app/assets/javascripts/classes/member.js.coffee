class window.Member

  constructor: (a) ->
    @arcana = a
    @chainArcana = null

  chainedCost: ->
    c = @arcana.cost
    return c unless @chainArcana
    (c + @chainArcana.chainCost)

  canUseChainAbility: ->
    return false unless @chainArcana
    return false unless @arcana.jobType == @chainArcana.jobType
    return false if @arcana.name == @chainArcana.name
    true
