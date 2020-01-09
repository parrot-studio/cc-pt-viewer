import Arcana from "./Arcana"

// 値オブジェクト：メンバー
export default class Member {
  private _mainArcana: Arcana
  private _chainArcana: Arcana | null

  // NOTE: 絆アルカナの追加は新しいメンバーの生成
  constructor(main: Arcana, chain: Arcana | null) {
    this._mainArcana = main
    this._chainArcana = chain
  }

  get cost(): number {
    let cost = this._mainArcana.cost
    if (this._chainArcana) {
      cost += this._chainArcana.cost
    }
    return cost
  }

  get mainArcana(): Arcana {
    return this._mainArcana
  }

  get chainArcana(): Arcana | null {
    return this._chainArcana
  }

  get code(): string {
    let c = this._mainArcana.arcanaCode
    if (this._chainArcana) {
      c += this._chainArcana.arcanaCode
    } else {
      c += "N"
    }
    return c
  }

  // メンバーが指定されたアルカナを保持しているか？
  public hasArcana(target: Arcana | null): boolean {
    if (this._mainArcana.isEqual(target)) {
      return true
    }
    if (!this._chainArcana) {
      return false
    }
    if (this._chainArcana.isEqual(target)) {
      return true
    }
    return false
  }
}
