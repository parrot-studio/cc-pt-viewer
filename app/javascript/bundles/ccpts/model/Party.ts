import * as _ from "lodash"

import Arcana from "./Arcana"
import Member from "./Member"

interface PartyMember {
  [key: string]: Member | null
}

export default class Party {
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

  private _members: PartyMember = {}

  constructor() {
    this._members = {}
  }

  get code(): string {
    const mems = this._members

    let code = ""
    Member.POSITIONS.forEach((pos) => {
      const m = mems[pos]
      if (m) {
        code += m.code
      } else if (pos === Member.HERO_KEY) {
        code += "N"
      } else {
        code += "NN"
      }
    })

    if ((/^N+$/).test(code)) {
      return ""
    }
    return `V${Party.ptver}${code}`
  }

  get cost(): number {
    const mems = this._members

    let c = 0
    Member.POSITIONS.forEach((pos) => {
      const m = mems[pos]
      if (m) {
        c += m.cost
      }
    })
    return c
  }

  public build(as: { [key: string]: Arcana | null }): void {
    this.reset()

    Member.POSITIONS.forEach((pos) => {
      const mb = as[pos]
      const mc = as[`${pos}c`]

      if (mb) {
        this.addMember(new Member(pos, mb, mc))
      } else {
        this.removeMember(pos)
      }
    })
  }

  public memberFor(pos: string): Member | null {
    return this._members[pos]
  }

  public addMember(m: Member): void {
    if (!m.isFriend()) {
      this.removeDuplicateMember(m)
    }

    this._members[m.position] = m
  }

  public removeMember(pos: string): void {
    this._members[pos] = null
  }

  public removeChain(pos: string): void {
    const m = this.memberFor(pos)
    if (!m) {
      return
    }
    this.addMember(new Member(pos, m.arcana, null))
  }

  public reset(): void {
    this._members = {}
  }

  public addHero(arcana: Arcana | null): void {
    if (arcana) {
      this.addMember(new Member(Member.HERO_KEY, arcana, null))
    } else {
      this.removeMember(Member.HERO_KEY)
    }
  }

  public swap(ak: string, bk: string): void {
    const am = this.memberFor(ak)
    const bm = this.memberFor(bk)

    if (am) {
      this.addMember(new Member(bk, am.arcana, am.chainArcana))
    } else {
      this.removeMember(bk)
    }

    if (bm) {
      this.addMember(new Member(ak, bm.arcana, bm.chainArcana))
    } else {
      this.removeMember(ak)
    }
  }

  private removeDuplicateMember(target: Member): void {
    const ta = target.arcana
    const tc = target.chainArcana

    const mems = this._members
    Member.POSITIONS.forEach((k) => {
      const m = mems[k]
      if (!m) {
        return
      }
      if (m.isFriend()) {
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
        mems[k] = new Member(k, m.arcana, null)
      }
    })

    this._members = mems
  }
}
