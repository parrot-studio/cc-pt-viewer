import * as _ from "lodash"

import Arcana from "./Arcana"
import Member from "./Member"

interface PartyMember {
  [key: string]: Member | null
}

export default class Party {
  public static readonly FRIEND_KEY: string = "friend"
  public static readonly HERO_KEY: string = "hero"

  public static ptver: string

  public static create(): Party {
    const pt = new Party()
    pt.build({})
    return pt
  }

  public static build(data: { [key: string]: any }): Party {
    const as = _.mapValues(data, (d) => Arcana.build(d))
    const pt = new Party()
    pt.build(as)
    return pt
  }

  private static readonly MEMBER_KEY: string[] = [
    "mem1", "mem2", "mem3", "mem4", "sub1", "sub2", Party.FRIEND_KEY, Party.HERO_KEY
  ]

  public members: PartyMember = {}
  public cost: number

  constructor() {
    this.members = {}
    this.cost = 0
  }

  public createCode(): string {
    const header = `V${Party.ptver}`
    const mems = this.members
    let code = ""
    _.forEach(Party.MEMBER_KEY, (k) => {
      const m = mems[k]
      if (k === Party.HERO_KEY) {
        if (m) {
          code = `${code}${m.arcana.jobCode}`
        } else {
          code = `${code}N`
        }
      } else {
        if (m) {
          code = `${code}${m.arcana.jobCode}`
          if (m.chainArcana) {
            code = `${code}${m.chainArcana.jobCode}`
          } else {
            code = `${code}N`
          }
        } else {
          code = `${code}NN`
        }
      }
    })

    if ((/^N+$/).test(code)) {
      return ""
    }
    return (header + code)
  }

  public build(as: { [key: string]: Arcana | null }): void {
    _.forEach(Party.MEMBER_KEY, (k) => {
      const mb = as[k]
      const mc = as[`${k}c`]
      if (mb) {
        const mem = new Member(mb)
        if (mc) {
          mem.chainArcana = mc
        }
        this.addMember(k, mem)
      } else {
        this.addMember(k, null)
      }
    })
  }

  public memberFor(key: string): Member | null {
    return this.members[key]
  }

  public addMember(key: string, m: Member | null): void {
    if (m && key === Party.HERO_KEY) {
      m.chainArcana = null
    }
    if (m && key !== Party.FRIEND_KEY) {
      this.removeDuplicateMember(m)
    }
    if (m) {
      m.memberKey = key
    }
    this.members[key] = m
    this.cost = this.costForMembers()
  }

  public removeMember(key: string): void {
    this.addMember(key, null)
  }

  public removeChain(key: string): void {
    const m = this.memberFor(key)
    if (!m) {
      return
    }
    this.addMember(key, new Member(m.arcana))
  }

  public reset(): void {
    this.members = {}
    this.cost = 0
  }

  public swap(ak: string, bk: string): void {
    const am = this.memberFor(ak)
    const bm = this.memberFor(bk)
    this.addMember(ak, bm)
    this.addMember(bk, am)
  }

  public copyFromFriend(k: string): void {
    const fm = this.memberFor(Party.FRIEND_KEY)
    if (!fm) {
      return
    }
    const m = new Member(fm.arcana)
    m.chainArcana = fm.chainArcana
    this.addMember(k, m)
  }

  public addHero(code: string): void {
    if (_.isEmpty(code)) {
      this.addMember(Party.HERO_KEY, null)
      return
    }

    const a = Arcana.forCode(code)
    if (!a) {
      this.addMember(Party.HERO_KEY, null)
      return
    }

    this.addMember(Party.HERO_KEY, new Member(a))
  }

  private removeDuplicateMember(target: Member): void {
    const ta = target.arcana
    const tc = target.chainArcana

    const mems = this.members
    _.forEach(Party.MEMBER_KEY, (k) => {
      if (k === Party.FRIEND_KEY) {
        return
      }
      const m = mems[k]
      if (!m) {
        return
      }
      if (Arcana.sameArcana(m.arcana, ta) || Arcana.sameArcana(m.arcana, tc)) {
        mems[k] = null
        return
      }

      if (!m.chainArcana) {
        return
      }
      if (Arcana.sameArcana(m.chainArcana, ta) || Arcana.sameArcana(m.chainArcana, tc)) {
        mems[k] = new Member(m.arcana)
      }
    })
    this.members = mems
  }

  private costForMembers(): number {
    let cost = 0
    _.forEach(this.members, (m, k) => {
      if (k === Party.FRIEND_KEY || k === Party.HERO_KEY || !m) {
        return
      }
      cost = cost + m.chainedCost()
    })
    return cost
  }
}