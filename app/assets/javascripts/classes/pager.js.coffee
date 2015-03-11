class window.Pager

  defaultPageSize = 8

  constructor: (list, psize) ->
    @all = list || []
    @size = @all.length
    @pageSize = (psize || defaultPageSize)
    @maxPage = if @size > 0
      Math.ceil(list.length / @pageSize)
    else
      1
    @page = 1

  head: ->
    (@page - 1) * @pageSize

  tail: ->
    t = (@page * @pageSize) - 1
    if t >= @all.length
      t = @all.length - 1
    t

  get: ->
    h = @head()
    t = @tail()
    @all[h .. t]

  nextPage: ->
    @page += 1
    if @page > @maxPage
      @page = @maxPage
    @page

  prevPage: ->
    @page -= 1
    if @page < 0
      @page = 1
    @page

  hasNextPage: ->
    if @page < @maxPage then true else false

  hasPrevPage: ->
    if @page > 1 then true else false

  jumpPage: (p) ->
    @page = parseInt(p)
    if @page > @maxPage
      @page = @maxPage
    if @page < 0
      @page = 1
    @page

  sort: (col, order) ->
    order ||= 'desc'
    @all.sort (am, bm) ->
      a = am.arcana
      b = bm.arcana
      return 0 if a.jobCode is b.jobCode

      av = a[col]
      av = 0 if av is '-'
      bv = b[col]
      bv = 0 if bv is '-'

      if av is bv
        0
      else if av < bv
        if order is 'desc' then 1 else -1
      else
        if order is 'desc' then -1 else 1
    @all
