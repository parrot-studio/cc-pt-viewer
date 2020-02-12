// 値オブジェクト：必殺技効果
export default class SkillEffect {
  private _order: number
  private _mainCategory: string
  private _subCategory: string
  private _subEffects: string[]

  constructor(order: number, main: string, sub: string, subEffects: string[]) {
    this._order = order
    this._mainCategory = main
    this._subCategory = sub
    this._subEffects = subEffects
  }

  get order(): number {
    return this._order
  }
  get mainCategory(): string {
    return this._mainCategory
  }
  get subCategory(): string {
    return this._subCategory
  }
  get subEffects(): string[] {
    return this._subEffects
  }
}
