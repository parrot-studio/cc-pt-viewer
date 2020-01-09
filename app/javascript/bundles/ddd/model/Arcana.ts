// 値オブジェクト：アルカナ
export default class Arcana {
  private _arcanaCode: string
  private _cost: number

  constructor(code: string, cost: number) {
    this._arcanaCode = code

    if (cost >= 0) {
      this._cost = cost
    } else {
      this._cost = 0
    }
  }

  get arcanaCode(): string {
    return this._arcanaCode
  }

  get cost(): number {
    return this._cost
  }

  // 等価性判定
  public isEqual(other: Arcana | null) {
    if (!other) {
      return false
    }
    if (this._arcanaCode !== other.arcanaCode) {
      return false
    }
    return true
  }
}
