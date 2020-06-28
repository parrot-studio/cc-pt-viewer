import * as _ from "lodash"

import Party from "./Party"
import MessageStream from "../lib/MessageStream"
import Cookie from "../lib/Cookie"

export interface PartyLog {
  code: string,
  comment: string
}

export default class PartyRepositroy {
  public static init(ps: PartyLog[], code: string): void {
    PartyRepositroy._instance = new PartyRepositroy(code, ps)
  }

  public static clear(): void {
    this._instance.clear()
  }

  public static setLastParty(party: Party): void {
    this._instance.setLastParty(party)
  }

  public static partyFor(order: number): PartyLog {
    return this._instance.partyFor(order)
  }

  public static addParty(party: Party, comment: string): void {
    this._instance.addParty(party, comment)
  }

  static get lastParty(): string {
    return this._instance._lastParty
  }

  static get parties(): PartyLog[] {
    return this._instance._parties
  }

  private static readonly PT_SIZE = 10
  private static readonly COOKIE_NAME_LIST = "parties"
  private static readonly COOKIE_NAME_LAST = "last-members"

  private static _instance: PartyRepositroy = new PartyRepositroy("", [])

  private _lastParty = ""
  private _parties: PartyLog[] = []

  private constructor(lastPatry: string, pts: PartyLog[]) {
    this._lastParty = lastPatry
    this._parties = pts
  }

  private clear(): void {
    this._parties = []
    this.setListCookie("")
    this.setLastCookie("")
    MessageStream.partiesStream.push([])
  }

  private setLastParty(party: Party): void {
    this._lastParty = party.code
    this.setLastCookie(this._lastParty)
  }

  private partyFor(order: number): PartyLog {
    return this._parties[order - 1] || {}
  }

  private addParty(party: Party, comment: string): void {
    const code = party.code
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

    this._parties = _.chain(_.flatten([data, this._parties]))
      .uniqBy((pt) => pt.code)
      .take(PartyRepositroy.PT_SIZE)
      .value()

    const val = JSON.stringify(this._parties)
    this.setListCookie(val)
    MessageStream.partiesStream.push(this._parties)
  }

  private setListCookie(code: string): void {
    const cs = {}
    cs[PartyRepositroy.COOKIE_NAME_LIST] = code
    Cookie.set(cs)
  }

  private setLastCookie(code: string): void {
    const cs = {}
    cs[PartyRepositroy.COOKIE_NAME_LAST] = code
    Cookie.set(cs)
  }
}
