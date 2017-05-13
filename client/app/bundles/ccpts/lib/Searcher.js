import _ from "lodash"
import Bacon from "baconjs"
import Agent from "superagent"

import Arcana from "../model/Arcana"
import QueryLogs from "../model/QueryLogs"
import QueryResult from "../model/QueryResult"

const __searcher_config = {}
const __sercher_resultCache = {}
const __sercher_detailCache = {}
const __sercher_memberCache = {}

export default class Searcher {

  static init(dataVer, appPath) {
    __searcher_config.ver = (dataVer || "")
    __searcher_config.appPath = (appPath || "")
    __searcher_config.apiPath = `${__searcher_config.appPath}api/`
  }

  static search(params, url) {
    $("#error-area").hide()

    params = (params || {})
    params.ver = __searcher_config.ver
    const result = Bacon.fromPromise(Agent.get(url).query(params))
    result.onError(() => $("#error-area").show())
    result.onEnd(() => $("#loading-modal").modal("hide"))
    return result.flatMap((res) => Bacon.once(res.body))
  }

  static searchArcanas(query) {
    if (!query) {
      return
    }
    if (query.isQueryForName()) {
      return Searcher.searchFromName(query)
    }

    const key = query.createKey()
    const cached = __sercher_resultCache[key]

    if (cached) {
      const as = _.map(cached, (c) => Arcana.forCode(c))
      query.detail = __sercher_detailCache[key]
      QueryLogs.add(query)
      return Bacon.once(QueryResult.create(as, __sercher_detailCache[key]))
    }

    $("#loading-modal").modal("show")
    const searchUrl = `${__searcher_config.apiPath}search`
    return Searcher.search(query.params(), searchUrl).flatMap((data) => {
      const as = _.map(data.result, (d) => Arcana.build(d))
      const cs = _.map(as, (a) => a.jobCode)
      __sercher_resultCache[key] = cs
      __sercher_detailCache[key] = data.detail
      query.detail = data.detail
      QueryLogs.add(query)
      return Bacon.once(QueryResult.create(as, data.detail))
    })
  }

  static searchMembers(code) {
    const cache = __sercher_memberCache[code]
    if (cache) {
      return Bacon.once(cache)
    }

    const params = {ptm: code}
    const ptmUrl = `${__searcher_config.apiPath}ptm`
    return Searcher.search(params, ptmUrl).flatMap((data) => {
      const as = _.mapValues(data, (d) => Arcana.build(d))
      __sercher_memberCache[code] = as
      return Bacon.once(as)
    })
  }

  static searchCodes(targets) {
    if (_.isEmpty(targets)) {
      return Bacon.once([])
    }
    const unknowns = _.reject(targets, (c) => Arcana.forCode(c))
    if (_.isEmpty(unknowns)) {
      const as = _.map(targets, (c) => Arcana.forCode(c))
      return Bacon.once(QueryResult.create(as))
    }

    $("#loading-modal").modal("show")
    const params = {codes: unknowns.join("/")}
    const codesUrl = `${__searcher_config.apiPath}codes`
    return Searcher.search(params, codesUrl).flatMap((data) => {
      _.forEach(data, (d) => Arcana.build(d))
      const as = _.map(targets, (c) => Arcana.forCode(c))
      return Bacon.once(QueryResult.create(as))
    })
  }

  static request(text) {
    $("#error-area").hide()
    $("#loading-modal").modal("show")
    const params = {}
    params.text = text

    // NOTE: add CSRF header automatically if use jQuery's Ajax with jquery-rails
    // TODO: react_on_railsの機能で取得する
    const token = $("meta[name=\"csrf-token\"]").attr("content")
    const requestUrl = `${__searcher_config.apiPath}request`
    const post = Agent.post(requestUrl).set("X-CSRF-Token", token).send(params)

    const result = Bacon.fromPromise(post)
    result.onError(() => $("#error-area").show())
    result.onEnd(() => $("#loading-modal").modal("hide"))
    return result.flatMap((res) => Bacon.once(res.body))
  }

  static searchFromName(query) {
    const nameUrl = `${__searcher_config.apiPath}name`
    return Searcher.search(query.params(), nameUrl).flatMap((data) => {
      const as = _.map(data, (d) => Arcana.build(d))
      query.detail = `名前から検索 : ${query.params().name}`
      QueryLogs.add(query)
      return Bacon.once(QueryResult.create(as, query.detail))
    })
  }

  static loadConditions() {
    const condsUrl = `${__searcher_config.apiPath}conditions`
    return Searcher.search({}, condsUrl)
  }

  static loadLatestInfo() {
    const infoUrl = `${__searcher_config.apiPath}latestinfo`
    return Searcher.search({}, infoUrl)
  }
}
