import _ from "lodash"
import ObjectHash from "object-hash"
import Conditions from "./Conditions"

export default class Query {

  static create(param) {
    return new Query(param)
  }

  static parse(q) {
    const query = new Query()
    query.parse(q)
    return query
  }

  constructor(q) {
    this.q = (q || {})
    this.detail = ""
  }

  reset() {
    this.q = {}
  }

  params() {
    return (this.q || {})
  }

  isEmpty() {
    return (Object.keys(this.q || {}).length <= 0)
  }

  parse(q) {
    if(!q) {
      q = (location.search.replace(/(^\?)/,"") || "")
    }
    this.reset()
    if (_.isEmpty(q)) {
      return {}
    }

    let ret = {}
    let recently = false
    let name = null
    const r = /\+/g
    _.forEach(q.split("&"), (qs) => {
      const ss = qs.split("=")
      const n = ss[0]
      const v = ss[1]

      const val = decodeURIComponent(v).replace(r, " ")
      if (_.eq(n, "ver")) {
        return
      }
      switch(n) {
        case "recently":
          recently = true
          break
        case "name":
          name = val
          break
        case "illustratorname":
          ret["illustrator"] = Conditions.illustratorIdFor(val)
          break
        case "actorname":
          ret["actor"] = Conditions.voiceactorIdFor(val)
          break
        default:
          ret[n] = val
      }
    })
    if (recently) {
      return
    }
    if (!_.isEmpty(name)) {
      ret = {name}
    }
    this.q = ret
    return this.q
  }

  encode() {
    if (!this.q || this.q.recently) {
      return ""
    }
    let query = _.transform(this.q, (ret, v, n) => {
      if (_.eq(n, "ver")) {
        return
      }
      switch(n) {
        case "illustrator":
          ret["illustratorname"] = Conditions.illustratorNameFor(v)
          break
        case "actor":
          ret["actorname"] = Conditions.voiceactorNameFor(v)
          break
        default:
          if (!_.isEmpty(v)){
            ret[n] = v
          }
      }
    })
    if (!_.isEmpty(query.name)) {
      query = {name: query.name}
    }

    const rs = []
    _.forEach(query, (v, k) => {
      rs.push(`${encodeURIComponent(k)}=${encodeURIComponent(v)}`)
    })
    return rs.join("&").replace(" ", "+")
  }

  isQueryForRecently() {
    if (!this.q) {
      return false
    }
    if (this.q.recently) {
      return true
    }
    return false
  }

  isQueryForName() {
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

  createKey() {
    const query = _.omit((this.q || {}), "ver")
    return ObjectHash(query)
  }
}
