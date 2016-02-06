class @QueryResult

  @create: (arcanas, detail) ->
    new QueryResult(arcanas, detail)

  constructor: (arcanas, detail) ->
    @arcanas = (arcanas || [])
    @detail = (detail || "")
