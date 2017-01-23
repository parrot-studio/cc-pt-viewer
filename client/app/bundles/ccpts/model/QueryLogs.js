import _ from 'lodash'
import Bacon from 'baconjs'
import Query from './Query'
import { QueryLogCookie } from '../lib/Cookie'

const __queryLog_LOG_SIZE = 10
const __queryLog_COOKIE_NAME = 'query-log'

const __queryLog_notifyStream = new Bacon.Bus()

export default class QueryLogs {

  static add(q) {
    if (!q || q.isEmpty()) {
      return
    }
    QueryLogs.lastQuery = q
    if (q.isQueryForRecently() || q.isQueryForName()) {
      return
    }

    QueryLogs.querys = _.chain(_.flatten([q, QueryLogs.querys]))
      .uniqBy((oq) => oq.encode())
      .take(__queryLog_LOG_SIZE)
      .value()
    const cs = _.map(QueryLogs.querys, (oq) => ({
      query: oq.encode(),
      detail: oq.detail.substr(0, 30)
    }))

    const co = {}
    co[__queryLog_COOKIE_NAME] = cs
    QueryLogCookie.set(co)
    __queryLog_notifyStream.push(QueryLogs.querys)
    return q
  }

  static clear() {
    QueryLogs.lastQuery = null
    QueryLogs.querys = []
    QueryLogCookie.delete(__queryLog_COOKIE_NAME)
    __queryLog_notifyStream.push([])
  }

  static init() {
    QueryLogs.querys = []
    try {
      const cs = QueryLogCookie.valueFor(__queryLog_COOKIE_NAME)
      if (!cs) {
        return
      }
      QueryLogs.querys = _.map(cs, (c) => {
        const q = Query.parse(c.query)
        if (!q) {
          return
        }
        q.detail = c.detail
        return q
      })
    } catch (e) {
      QueryLogs.querys = []
    }
  }
}

QueryLogs.notifyStream = __queryLog_notifyStream
