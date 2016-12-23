import _ from 'lodash'
import Bacon from 'baconjs'
import Agent from 'superagent'

import Arcana from '../model/Arcana'
import Member from '../model/Member'
import QueryLogs from '../model/QueryLogs'
import QueryResult from '../model/QueryResult'

let __searcher_config = {}
let __sercher_resultCache = {}
let __sercher_detailCache = {}
let __sercher_memberCache = {}

export default class Searcher {

  static init(dataVer, appPath) {
    __searcher_config.ver = (dataVer || '')
    __searcher_config.appPath = (appPath || '')
  }

  static search(params, url) {
    $("#error-area").hide()

    params = (params || {})
    params.ver = __searcher_config.ver
    let result = Bacon.fromPromise(Agent.get(url).query(params))
    result.onError(() => $("#error-area").show())
    result.onEnd(() => $("#loading-modal").modal('hide'))
    return result.flatMap(res => Bacon.once(res.body))
  }

  static searchArcanas(query) {
    if (!query) {
      return
    }
    if (query.isQueryForName()) {
      return Searcher.searchFromName(query)
    }

    let key = query.createKey()
    let cached = __sercher_resultCache[key]

    if (cached) {
      let as = _.map(cached, c => Arcana.forCode(c))
      query.detail = __sercher_detailCache[key]
      QueryLogs.add(query)
      return Bacon.once(QueryResult.create(as, __sercher_detailCache[key]))
    }

    $("#loading-modal").modal('show')
    let searchUrl = __searcher_config.appPath + 'arcanas'
    return Searcher.search(query.params(), searchUrl).flatMap(data => {
      let as = _.map(data.result, d => Arcana.build(d))
      let cs = _.map(as, a => a.jobCode)
      __sercher_resultCache[key] = cs
      __sercher_detailCache[key] = data.detail
      query.detail = data.detail
      QueryLogs.add(query)
      return Bacon.once(QueryResult.create(as, data.detail))
    })
  }

  static searchMembers(code) {
    let cache = __sercher_memberCache[code]
    if (cache) {
      return Bacon.once(cache)
    }

    let params = {ptm: code}
    let ptmUrl = __searcher_config.appPath + 'ptm'
    return Searcher.search(params, ptmUrl).flatMap(data => {
      let as = _.mapValues(data, d => Arcana.build(d))
      __sercher_memberCache[code] = as
      return Bacon.once(as)
    })
  }

  static searchCodes(targets) {
    if (_.isEmpty(targets)) {
      return Bacon.once([])
    }
    let unknowns = _.reject(targets, c => Arcana.forCode(c))
    if (_.isEmpty(unknowns)) {
      let as = _.map(targets, c => Arcana.forCode(c))
      return Bacon.once(QueryResult.create(as))
    }

    $("#loading-modal").modal('show')
    let params = {codes: unknowns.join('/')}
    let codesUrl = __searcher_config.appPath + 'codes'
    return Searcher.search(params, codesUrl).flatMap(data => {
      _.forEach(data, d => Arcana.build(d))
      let as = _.map(targets, c => Arcana.forCode(c))
      return Bacon.once(QueryResult.create(as))
    })
  }

  static loadConditions() {
    let condsUrl = __searcher_config.appPath + 'conditions'
    return Searcher.search({}, condsUrl)
  }

  static request(text) {
    $("#error-area").hide()
    $("#loading-modal").modal('show')
    let params = {}
    params.text = text

    // NOTE: add CSRF header automatically if use jQuery's Ajax with jquery-rails
    // TODO: react_on_railsの機能で取得する
    let token = $('meta[name="csrf-token"]').attr('content')
    let requestUrl = __searcher_config.appPath + 'request'
    let post = Agent.post(requestUrl).set('X-CSRF-Token', token).send(params)

    let result = Bacon.fromPromise(post)
    result.onError(() => $("#error-area").show())
    result.onEnd(() => $("#loading-modal").modal('hide'))
    return result.flatMap(res => Bacon.once(res.body))
  }

  static searchFromName(query) {
    let nameUrl = __searcher_config.appPath + 'name'
    return Searcher.search(query.params(), nameUrl).flatMap(data => {
      let as = _.map(data, d => Arcana.build(d))
      query.detail = `名前から検索 : ${query.params().name}`
      QueryLogs.add(query)
      return Bacon.once(QueryResult.create(as, query.detail))
    })
  }
}
