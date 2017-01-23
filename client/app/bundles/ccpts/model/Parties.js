import _ from 'lodash'
import Bacon from 'baconjs'

import { Cookie } from '../lib/Cookie'

const __parties_PT_SIZE = 10
const __parties_DEFAULT_MEMBER_CODE = 'V2F82F85K51NA38NP28NP24NNNNN'
const __parties_COOKIE_NAME_LIST = 'parties'
const __parties_COOKIE_NAME_LAST = 'last-members'

const __parties_notifyStream = new Bacon.Bus()

export default class Parties {

  static setListCookie(code) {
    const cs = {}
    cs[__parties_COOKIE_NAME_LIST] = code
    Cookie.set(cs)
  }

  static setLastCookie(code) {
    const cs = {}
    cs[__parties_COOKIE_NAME_LAST] = code
    Cookie.set(cs)
  }

  static clear() {
    Parties.parties = []
    Parties.setListCookie('')
    Parties.setLastCookie('')
    __parties_notifyStream.push([])
    return Parties.parties
  }

  static setLastParty(party) {
    Parties.lastParty = party.createCode()
    Parties.setLastCookie(Parties.lastParty)
    return Parties.lastParty
  }

  static partyFor(order) {
    return Parties.parties[order-1] || {}
  }

  static addParty(party, comment) {
    const code = party.createCode()
    if (_.isEmpty(code)) {
      return
    }
    comment = (comment || '名無しパーティー')
    if (comment.length > 10) {
      comment = comment.substr(0, 10)
    }

    const data = {
      code,
      comment
    }
    Parties.parties = _.chain(_.flatten([data, Parties.parties]))
      .uniqBy((pt) => pt.code)
      .take(__parties_PT_SIZE)
      .value()

    const val = JSON.stringify(Parties.parties)
    Parties.setListCookie(val)
    __parties_notifyStream.push(Parties.parties)
    return Parties.parties
  }

  static init() {
    Parties.parties = []
    try {
      const val = Cookie.valueFor(__parties_COOKIE_NAME_LIST) || ''
      if (!_.isEmpty(val)) {
        Parties.parties = JSON.parse(val)
      }
    } catch(e) {
      Parties.parties = []
    }

    Parties.lastParty = __parties_DEFAULT_MEMBER_CODE
    try {
      Parties.lastParty = Cookie.valueFor(__parties_COOKIE_NAME_LAST) || __parties_DEFAULT_MEMBER_CODE
    } catch(e) {
      Parties.lastParty = __parties_DEFAULT_MEMBER_CODE
    }
  }
}

Parties.notifyStream = __parties_notifyStream
