import * as _ from "lodash"
import * as ObjectHash from "object-hash"
import Conditions from "./Conditions"

import Browser from "../lib/BrowserProxy"

export interface QueryParam {
  [key: string]: any
}

export default class Query {
  public static create(param: QueryParam): Query {
    return new Query(param)
  }

  public static parse(q: string): Query {
    const query = new Query({})
    query.parse(q)
    return query
  }

  public q: QueryParam = {}
  public detail: string

  constructor(q: QueryParam) {
    this.q = (q || {})
    this.detail = ""
  }

  public reset(): void {
    this.q = {}
    this.detail = ""
  }

  public params(): QueryParam {
    return (this.q || {})
  }

  public isEmpty(): boolean {
    return (Object.keys(this.q || {}).length <= 0)
  }

  public parse(q: string): QueryParam {
    this.reset()
    if (_.isEmpty(q)) {
      return {}
    }

    let ret: QueryParam = {}
    let recently = false
    let name: string = ""
    const r = /\+/g
    _.forEach(q.split("&"), (qs) => {
      const ss = qs.split("=")
      const n = ss[0]
      const v = ss[1]

      const val = decodeURIComponent(v).replace(r, " ")
      if (n === "ver") {
        return
      }
      switch (n) {
        case "recently":
          recently = true
          break
        case "name":
          name = val
          break
        case "illustratorname":
          ret.illustrator = Conditions.illustratorIdFor(val)
          break
        case "actorname":
          ret.actor = Conditions.voiceactorIdFor(val)
          break
        default:
          ret[n] = val
      }
    })
    if (recently) {
      return {}
    }
    if (!_.isEmpty(name)) {
      ret = { name }
    }
    this.q = ret
    return this.q
  }

  public encode(): string {
    if (!this.q || this.q.recently) {
      return ""
    }
    let query: QueryParam = _.transform(this.q, (ret: QueryParam, v, n) => {
      if (n === "ver") {
        return
      }
      switch (n) {
        case "illustrator":
          ret.illustratorname = Conditions.illustratorNameFor(v)
          break
        case "actor":
          ret.actorname = Conditions.voiceactorNameFor(v)
          break
        default:
          if (!_.isEmpty(v)) {
            ret[n] = v
          }
      }
    })
    if (!_.isEmpty(query.name)) {
      query = { name: query.name }
    }

    const rs: string[] = []
    _.forEach(query, (v, k) => {
      rs.push(`${encodeURIComponent(k)}=${encodeURIComponent(v)}`)
    })
    return rs.join("&").replace(" ", "+")
  }

  public isQueryForRecently(): boolean {
    if (!this.q) {
      return false
    }
    if (this.q.recently) {
      return true
    }
    return false
  }

  public isQueryForName(): boolean {
    if (!this.q) {
      return false
    }
    if (this.q.recently) {
      return false
    }
    if (!_.isEmpty(this.q.name)) {
      return true
    }
    return false
  }

  public createKey(): string {
    const query = _.omit((this.q || {}), "ver")
    return ObjectHash.sha1(query)
  }
}
