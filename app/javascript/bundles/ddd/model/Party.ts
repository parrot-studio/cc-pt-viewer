import * as _ from "lodash"

import Arcana from "./Arcana"
import Member from "./Member"
import PlayerParty from "./PlayerParty"
import FriendMember from "./FriendMember"

// エンティティ：パーティー
export default class Party {
  public static FRIEND_POSITION = "friend"
  public static POSITIONS: string[] = _.flatten([PlayerParty.POSITIONS, Party.FRIEND_POSITION])

  private _playerParty: PlayerParty
  private _friendMember: FriendMember

  constructor() {
    this._playerParty = new PlayerParty()
    this._friendMember = new FriendMember(null)
  }

  get cost(): number {
    return this._playerParty.cost
  }

  get code() {
    return `${this._playerParty.code}${this._friendMember.code}`
  }

  get playerParty(): PlayerParty {
    return this._playerParty
  }

  get friendMember(): FriendMember {
    return this._friendMember
  }

  // 位置に対応するメンバー取得
  public memberFor(pos: string): Member | null {
    if (this.isFriendPosition(pos)) {
      return this._friendMember.member
    }
    return this._playerParty.memberFor(pos)
  }

  // メンバーをフレンドとして登録する
  public addFriend(mem: Member): void {
    this._friendMember = new FriendMember(mem)
  }

  // フレンドを削除する
  public removeFriend(): void {
    this._friendMember = new FriendMember(null)
  }

  // メインアルカナと絆アルカナを指定してフレンドを登録する
  public createFriend(main: Arcana, chain: Arcana | null): void {
    this.addFriend(new Member(main, chain))
  }

  // フレンドの絆アルカナを削除
  public removeFriendChainArcana(): void {
    const mem = this._friendMember.member
    if (mem) {
      this.addFriend(new Member(mem.mainArcana, null))
    }
  }

  // 位置を指定してメンバーを登録
  public addMember(pos: string, mem: Member): void {
    if (this.isFriendPosition(pos)) {
      this.addFriend(mem)
    }
    this._playerParty.addMember(pos, mem)
  }

  // 位置とメインアルカナと絆アルカナを指定してメンバーを登録
  public createMember(pos: string, main: Arcana, chain: Arcana | null): void {
    this.addMember(pos, new Member(main, chain))
  }

  // 位置を指定してメンバーを削除する
  public removeMember(pos): void {
    if (this.isFriendPosition(pos)) {
      this.removeFriend()
    }
    this._playerParty.removeMember(pos)
  }

  // 位置を指定してメンバーの絆アルカナを削除する
  public removeMemberChainArcana(pos: string): void {
    const mem = this.memberFor(pos)
    if (!mem) {
      return
    }
    this.addMember(pos, new Member(mem.mainArcana, null))
  }

  private isFriendPosition(pos: string): boolean {
    return (pos === Party.FRIEND_POSITION)
  }
}
