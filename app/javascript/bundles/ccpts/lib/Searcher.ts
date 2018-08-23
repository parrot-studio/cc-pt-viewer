import * as _ from "lodash"
import * as Bacon from "baconjs"
import * as Agent from "superagent"
declare var $

import Arcana from "../model/Arcana"
import Party from "../model/Party"
import Query, { QueryParam } from "../model/Query"
import QueryLogs from "../model/QueryLogs"
import QueryResult from "../model/QueryResult"

interface SearchConfig {
  [key: string]: string
}

interface SearchDetailCache {
  [key: string]: string
}

interface SearchResultCache {
  [key: string]: string[]
}

interface SearchMemberCache {
  [key: string]: any
}

export default class Searcher {
  public static init(dataVer: string, appPath: string): void {
    Searcher.config.ver = (dataVer || "")
    Searcher.config.appPath = (appPath || "")
    Searcher.config.apiPath = `${Searcher.config.appPath}api/`
  }

  public static searchArcanas(query: Query): Bacon.EventStream<{}, QueryResult> {
    if (!query) {
      return Bacon.never()
    }
    if (query.isQueryForName()) {
      return Searcher.searchFromName(query)
    }

    const key = query.createKey()
    const cached = Searcher.resultCache[key]

    if (cached) {
      const as = _.chain(_.map(cached, (c) => Arcana.forCode(c))).compact().value()
      const detail = Searcher.detailCache[key]
      query.detail = detail
      QueryLogs.add(query)
      return Bacon.once(QueryResult.create(as, detail))
    }

    $("#loading-modal").modal("show")
    const searchUrl = `${Searcher.config.apiPath}search`
    return Searcher.search(query.params(), searchUrl).flatMap((data) => {
      const as = _.chain(_.map(data.result, (d) => Arcana.build(d))).compact().value()
      const cs = _.map(as, (a) => a.jobCode)
      const detail = data.detail || ""
      Searcher.resultCache[key] = cs
      Searcher.detailCache[key] = detail
      query.detail = detail
      QueryLogs.add(query)
      return Bacon.once(QueryResult.create(as, detail))
    })
  }

  public static searchMembers(code: string): Bacon.EventStream<{}, Party> {
    const cache = Searcher.memberCache[code]
    if (cache) {
      return Bacon.once(Party.build(cache))
    }

    const params = { ptm: code }
    const ptmUrl = `${Searcher.config.apiPath}ptm`
    return Searcher.search(params, ptmUrl).flatMap((data) => {
      Searcher.memberCache[code] = data
      return Bacon.once(Party.build(data))
    })
  }

  public static searchCodes(targets: string[]): Bacon.EventStream<{}, QueryResult> {
    if (_.isEmpty(targets)) {
      return Bacon.once(QueryResult.create([], ""))
    }
    const unknowns = _.reject(targets, (c) => Arcana.forCode(c))
    if (_.isEmpty(unknowns)) {
      const as = _.chain(_.map(targets, (c) => Arcana.forCode(c))).compact().value()
      return Bacon.once(QueryResult.create(as, ""))
    }

    $("#loading-modal").modal("show")
    const params = { codes: unknowns.join("/") }
    const codesUrl = `${Searcher.config.apiPath}codes`
    return Searcher.search(params, codesUrl).flatMap((data) => {
      _.forEach(data, (d) => Arcana.build(d))
      const as = _.chain(_.map(targets, (c) => Arcana.forCode(c))).compact().value()
      return Bacon.once(QueryResult.create(as, ""))
    })
  }

  public static request(text: string): Bacon.EventStream<{}, any> {
    $("#error-area").hide()
    $("#loading-modal").modal("show")
    const params: QueryParam = {}
    params.text = text

    // NOTE: add CSRF header automatically if use jQuery's Ajax with jquery-rails
    const token = $("meta[name=\"csrf-token\"]").attr("content") || ""
    const requestUrl = `${Searcher.config.apiPath}request`
    const post = Agent.post(requestUrl).set("X-CSRF-Token", token).send(params)

    const result = Bacon.fromPromise(post)
    result.onError(() => $("#error-area").show())
    result.onEnd(() => $("#loading-modal").modal("hide"))
    return result.flatMap((res) => Bacon.once(res.body))
  }

  public static searchFromName(query: Query): Bacon.EventStream<{}, QueryResult> {
    const nameUrl = `${Searcher.config.apiPath}name`
    return Searcher.search(query.params(), nameUrl).flatMap((data) => {
      const as = _.chain(_.map(data, (d) => Arcana.build(d))).compact().value()
      query.detail = `名前から検索 : ${query.params().name}`
      QueryLogs.add(query)
      return Bacon.once(QueryResult.create(as, query.detail))
    })
  }

  private static config: SearchConfig = {}
  private static resultCache: SearchResultCache = {}
  private static detailCache: SearchDetailCache = {}
  private static memberCache: SearchMemberCache = {}

  private static search(params: any, url: string): Bacon.EventStream<{}, any> {
    $("#error-area").hide()

    params = (params || {})
    params.ver = Searcher.config.ver
    const result = Bacon.fromPromise(Agent.get(url).query(params))
    result.onError(() => $("#error-area").show())
    result.onEnd(() => $("#loading-modal").modal("hide"))
    return result.flatMap((res) => Bacon.once(res.body))
  }
}
