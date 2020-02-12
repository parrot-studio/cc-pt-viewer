import * as _ from "lodash"
import * as ObjectHash from "object-hash"
import Conditions from "./Conditions"

export interface QueryParam {
  [key: string]: any
}

export interface QueryLog {
  query: string,
  detail: string
}

export default class Query {
  public static create(param: QueryParam): Query {
    return new Query(param)
  }

  public static parse(q: string): Query {
    if (_.isEmpty(q)) {
      return new Query({})
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
      return new Query({})
    }
    if (!_.isEmpty(name)) {
      ret = { name }
    }

    return new Query(ret)
  }

  private _q: QueryParam = {}
  private _detail: string
  private _encode: string

  private constructor(q: QueryParam) {
    this._q = (q || {})
    this._detail = ""
    this._encode = this.encodeQuery(q)
  }

  public params(): QueryParam {
    return this._q
  }

  get detail(): string {
    return this._detail
  }

  public encode(): string {
    return this._encode
  }

  public setDetail(detail: string): void {
    this._detail = detail
  }

  public isEmpty(): boolean {
    return (Object.keys(this._q).length <= 0)
  }

  public createKey(): string {
    const query = _.omit((this._q || {}), "ver")
    return ObjectHash.sha1(query)
  }

  public isQueryForRecently(): boolean {
    if (!this._q) {
      return false
    }
    if (this._q.recently) {
      return true
    }
    return false
  }

  public isQueryForName(): boolean {
    if (!this._q) {
      return false
    }
    if (this._q.recently) {
      return false
    }
    if (!_.isEmpty(this._q.name)) {
      return true
    }
    return false
  }

  private encodeQuery(q: QueryParam): string {
    if (!q || q.recently) {
      return ""
    }
    let query: QueryParam = _.transform(this._q, (ret: QueryParam, v, n) => {
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
}
