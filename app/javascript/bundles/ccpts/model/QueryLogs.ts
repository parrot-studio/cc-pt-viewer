import * as _ from "lodash"
import Query from "./Query"

import MessageStream from "../lib/MessageStream"
import QueryLogCookie from "../lib/QueryLogCookie"

export interface QueryLog {
  query: string,
  detail: string
}

export default class QueryLogs {
  public static querys: Query[]
  public static lastQuery: Query | null

  public static add(q: Query): void {
    if (!q || q.isEmpty()) {
      return
    }
    QueryLogs.lastQuery = q
    if (q.isQueryForRecently() || q.isQueryForName()) {
      return
    }

    QueryLogs.querys = _.chain(_.flatten([q, QueryLogs.querys]))
      .uniqBy((oq) => oq.encode())
      .take(QueryLogs.LOG_SIZE)
      .value()
    const cs: QueryLog[] = _.map(QueryLogs.querys, (oq) => ({
      query: oq.encode(),
      detail: oq.detail.substr(0, 30)
    }))

    const co: { [key: string]: QueryLog[] } = {}
    co[QueryLogs.COOKIE_NAME] = cs
    QueryLogCookie.set(co)
    MessageStream.queryLogsStream.push(QueryLogs.querys)
  }

  public static clear(): void {
    QueryLogs.lastQuery = null
    QueryLogs.querys = []
    QueryLogCookie.delete(QueryLogs.COOKIE_NAME)
    MessageStream.queryLogsStream.push([])
  }

  public static init(cs: QueryLog[]): void {
    QueryLogs.querys = []
    if (!cs) {
      return
    }
    const qs: Query[] = _.chain(
      _.map(cs, (c) => {
        const q = Query.parse(c.query)
        q.detail = c.detail
        return q
      })
    ).reject((q) => q.isEmpty() || q.isQueryForRecently()).value()
    QueryLogs.querys = qs
  }

  private static readonly LOG_SIZE = 10
  private static readonly COOKIE_NAME = "query-log"
}
