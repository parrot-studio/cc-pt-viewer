import * as _ from "lodash"

import Member from "./Member"
import Arcana from "./Arcana"

// エンティティ：プレイヤーパーティー
export default class PlayerParty {
  // パーティーの位置リスト
  public static POSITIONS: string[] = ["mem1", "mem2", "mem3", "mem4", "sub1", "sub2"]

  private _members: { [key: string]: Member | null }

  constructor() {
    this._members = {}
  }

  get cost(): number {
    return _.chain(this._members)
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      .flatMap((mem, pos) => {
        if (!mem) {
          return 0
        }
        return mem.cost
      })
      .sum()
      .value()
  }

  // プレイヤーパーティーのコード
  get code(): string {
    let c = ""
    PlayerParty.POSITIONS.forEach((pos) => {
      const m = this._members[pos]
      if (m) {
        c += m.code
      } else {
        c += "NN"
      }
    })
    return c
  }

  // 位置に対応するメンバー取得
  public memberFor(pos: string): Member | null {
    if (!this.isValidPosition(pos)) {
      return null
    }
    return this._members[pos] || null
  }

  // 位置にメンバーを追加する
  public addMember(pos: string, mem: Member): void {
    if (!this.isValidPosition(pos)) {
      return
    }

    // 重複するアルカナを削除する
    this.removeDuplicateMember(mem)

    // メンバーをセット
    this._members[pos] = mem
  }

  // 位置にメインアルカナと絆アルカナを指定してメンバーを追加する
  public createMember(pos: string, main: Arcana, chain: Arcana | null): void {
    this.addMember(pos, new Member(main, chain))
  }

  // 位置を指定してメンバーを削除する
  public removeMember(pos: string): void {
    this._members[pos] = null
  }

  // 位置を指定してメンバーの絆アルカナを削除する
  public removeMemberChainArcana(pos: string): void {
    const mem = this.memberFor(pos)
    if (!mem) {
      return
    }
    this.addMember(pos, new Member(mem.mainArcana, null))
  }

  private isValidPosition(pos: string): boolean {
    return PlayerParty.POSITIONS.includes(pos)
  }

  // メンバーに含まれるアルカナが重複していたら削除
  private removeDuplicateMember(mem: Member): void {
    PlayerParty.POSITIONS.forEach((pos) => {
      const m = this._members[pos]
      if (!m) {
        return
      }

      if (m.hasArcana(mem.mainArcana)) {
        this.removeDuplicateArcana(pos, mem.mainArcana)
      }
      if (mem.chainArcana && m.hasArcana(mem.chainArcana)) {
        this.removeDuplicateArcana(pos, mem.chainArcana)
      }
    })
  }

  // 対象のメンバーから指定されたアルカナを削除
  private removeDuplicateArcana(pos: string, target: Arcana): void {
    const org = this._members[pos]
    if (!org) {
      return
    }
    if (!org.hasArcana(target)) {
      return
    }

    // メインアルカナが同じの場合、メンバーごと削除
    if (org.mainArcana.isEqual(target)) {
      this._members[pos] = null
    }

    // 絆アルカナが同じの場合、絆アルカナだけ削除
    if (org.chainArcana && org.chainArcana.isEqual(target)) {
      this._members[pos] = new Member(org.mainArcana, null)
    }
  }
}
