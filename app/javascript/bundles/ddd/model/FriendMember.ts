import Arcana from "./Arcana"
import Member from "./Member"

// 値オブジェクト：フレンドメンバー
export default class FriendMember {
  private _member: Member | null

  constructor(mem: Member | null) {
    this._member = mem
  }

  get member(): Member | null {
    return this._member
  }

  // フレンドのコストは常に0
  get cost(): number {
    return 0
  }

  get code(): string {
    if (!this._member) {
      return "NN"
    }
    return this._member.code
  }

  get mainArcana(): Arcana | null {
    return this._member?.mainArcana || null
  }

  get chainArcana(): Arcana | null {
    return this._member?.chainArcana || null
  }

  public hasArcana(target: Arcana | null): boolean {
    if (!this._member) {
      return false
    }
    return this._member.hasArcana(target)
  }
}
