import * as _ from "lodash"

import Party from "./Party"
import MessageStream from "../lib/MessageStream"
import Cookie from "../lib/Cookie"

export interface PartyLog {
  code: string,
  comment: string
}

export default class Parties {
  public static lastParty: string = ""
  public static parties: PartyLog[] = []

  public static setListCookie(code: string): void {
    const cs: any = {}
    cs[Parties.COOKIE_NAME_LIST] = code
    Cookie.set(cs)
  }

  public static setLastCookie(code: string): void {
    const cs: any = {}
    cs[Parties.COOKIE_NAME_LAST] = code
    Cookie.set(cs)
  }

  public static clear(): void {
    Parties.parties = []
    Parties.setListCookie("")
    Parties.setLastCookie("")
    MessageStream.partiesStream.push([])
  }

  public static setLastParty(party: Party): void {
    Parties.lastParty = party.createCode()
    Parties.setLastCookie(Parties.lastParty)
  }

  public static partyFor(order: number): PartyLog {
    return Parties.parties[order - 1] || {}
  }

  public static addParty(party: Party, comment: string): void {
    const code = party.createCode()
    if (_.isEmpty(code)) {
      return
    }
    comment = (comment || "名無しパーティー")
    if (comment.length > 10) {
      comment = comment.substr(0, 10)
    }

    const data: PartyLog = {
      code,
      comment
    }

    Parties.parties = _.chain(_.flatten([data, Parties.parties]))
      .uniqBy((pt) => pt.code)
      .take(Parties.PT_SIZE)
      .value()

    const val = JSON.stringify(Parties.parties)
    Parties.setListCookie(val)
    MessageStream.partiesStream.push(Parties.parties)
  }

  public static init(): void {
    Parties.parties = []
    try {
      const val = Cookie.valueFor(Parties.COOKIE_NAME_LIST) || ""
      if (!_.isEmpty(val)) {
        Parties.parties = JSON.parse(val)
      }
    } catch (e) {
      Parties.parties = []
    }

    try {
      Parties.lastParty = Cookie.valueFor(Parties.COOKIE_NAME_LAST) || Parties.DEFAULT_MEMBER_CODE
    } catch (e) {
      Parties.lastParty = Parties.DEFAULT_MEMBER_CODE
    }
  }

  private static readonly PT_SIZE = 10
  private static readonly DEFAULT_MEMBER_CODE = "V3F362NK160K151A157NP95NF305F273M194NF272F274M261"
  private static readonly COOKIE_NAME_LIST = "parties"
  private static readonly COOKIE_NAME_LAST = "last-members"
}