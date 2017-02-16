import _ from 'lodash'

import Arcana from './Arcana'
import Member from './Member'

const __party_MEMBER_KEY = ['mem1', 'mem2', 'mem3', 'mem4', 'sub1', 'sub2', 'friend']

export default class Party {

  static create() {
    return Party.build([])
  }

  static build(as) {
    const pt = new Party()
    pt.build(as)
    return pt
  }

  constructor() {
    this.members = {}
    this.cost = 0
  }

  createCode() {
    const header = `V${Party.ptver}`
    const mems = this.members
    let code = ''
    _.forEach(__party_MEMBER_KEY, (k) => {
      const m = mems[k]
      if (m) {
        code = code + m.arcana.jobCode
        if (m.chainArcana) {
          code = code + m.chainArcana.jobCode
        } else {
          code = `${code}N`
        }
      } else {
        code = `${code}NN`
      }
    })

    if ((/^N+$/).test(code)) {
      return ''
    }
    return (header + code)
  }

  build(as) {
    _.forEach(__party_MEMBER_KEY, (k) => {
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

  memberFor(key) {
    return this.members[key]
  }

  addMember(key, m) {
    if (m && key != "friend") {
      this.members = this._removeDuplicateMember(this.members, m)
    }
    if (m) {
      m.memberKey = key
    }
    this.members[key] = m
    this.cost = this._costForMembers(this.members)
  }

  removeMember(key) {
    this.addMember(key, null)
  }

  removeChain(key) {
    const m = this.memberFor(key)
    if (!m) {
      return
    }
    this.addMember(key, new Member(m.arcana))
  }

  reset() {
    this.members = {}
    this.cost = 0
  }

  swap(ak, bk) {
    const am = this.memberFor(ak)
    const bm = this.memberFor(bk)
    this.addMember(ak, bm)
    this.addMember(bk, am)
  }

  copyFromFriend(k) {
    const fm = this.memberFor('friend')
    if (!fm) {
      return
    }
    const m = new Member(fm.arcana)
    m.chainArcana = fm.chainArcana
    this.addMember(k, m)
  }

  _removeDuplicateMember(mems, target) {
    const ta = target.arcana
    const tc = target.chainArcana

    _.forEach(__party_MEMBER_KEY, (k) => {
      if (_.eq(k, 'friend')) {
        return
      }
      const m = mems[k]
      if (!m) {
        return
      }
      if (Arcana.sameCharacter(m.arcana, ta) || Arcana.sameArcana(m.arcana, tc)) {
        mems[k] = null
        return
      }

      if (!m.chainArcana) {
        return
      }
      if (Arcana.sameArcana(m.chainArcana, ta) || Arcana.sameCharacter(m.chainArcana, tc)) {
        mems[k] = new Member(m.arcana)
      }
    })
    return mems
  }

  _costForMembers(mems) {
    let cost = 0
    _.forEach(mems, (m, k) => {
      if (_.eq(k, 'friend') || !m) {
        return
      }
      cost = cost + m.chainedCost()
    })
    return cost
  }
}
