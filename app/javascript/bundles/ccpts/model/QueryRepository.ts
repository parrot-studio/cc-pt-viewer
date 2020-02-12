import * as _ from "lodash"
import Query, { QueryLog } from "./Query"

import MessageStream from "../lib/MessageStream"
import QueryLogCookie from "../lib/QueryLogCookie"

export default class QueryRepository {
  public static init(cs: QueryLog[]): void {
    if (!cs) {
      return
    }
    const qs: Query[] = _.chain(
      _.map(cs, (c) => {
        const q = Query.parse(c.query)
        q.setDetail(c.detail)
        return q
      })
    ).reject((q) => q.isEmpty() || q.isQueryForRecently()).value()

    this._instance = new QueryRepository(qs)
  }

  static get querys(): Query[] {
    return this._instance._querys
  }

  static get lastQuery(): Query | null {
    return this._instance._lastQuery
  }

  public static add(q: Query): void {
    this._instance.add(q)
  }

  public static clear(): void {
    this._instance.clear()
  }

  private static readonly LOG_SIZE = 10
  private static readonly COOKIE_NAME = "query-log"

  private static _instance: QueryRepository = new QueryRepository([])

  private _querys: Query[]
  private _lastQuery: Query | null

  private constructor(qs: Query[]) {
    this._querys = qs
    this._lastQuery = null
  }

  private add(q: Query): void {
    if (!q || q.isEmpty()) {
      return
    }
    this._lastQuery = q
    if (q.isQueryForRecently() || q.isQueryForName()) {
      return
    }

    this._querys = _.chain(_.flatten([q, this._querys]))
      .uniqBy((oq) => oq.encode())
      .take(QueryRepository.LOG_SIZE)
      .value()
    const cs: QueryLog[] = _.map(this._querys, (oq) => ({
      query: oq.encode(),
      detail: oq.detail.substr(0, 30)
    }))

    const co: { [key: string]: QueryLog[] } = {}
    co[QueryRepository.COOKIE_NAME] = cs
    QueryLogCookie.set(co)
    MessageStream.queryLogsStream.push(this._querys)
  }

  private clear(): void {
    this._lastQuery = null
    this._querys = []
    QueryLogCookie.delete(QueryRepository.COOKIE_NAME)
    MessageStream.queryLogsStream.push([])
  }
}
