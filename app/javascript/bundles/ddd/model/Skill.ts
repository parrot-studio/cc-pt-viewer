import SkillEffect from "./SkillEffect"

// 値オブジェクト：必殺技
export default class Skill {
  private _name: string
  private _cost: number
  private _condition: string
  private _effects: SkillEffect[]

  constructor(name: string, cost: number, condition: string, effects: SkillEffect[]) {
    this._name = name
    this._condition = condition

    if (cost >= 0) {
      this._cost = cost
    } else {
      this._cost = 0
    }

    // effectsは1個以上必要
    if (effects.length < 1) {
      throw new Error("effectsは最低1個必要です")
    }
    this._effects = effects
  }

  get name(): string {
    return this._name
  }
  get cost(): number {
    return this._cost
  }
  get condition(): string {
    return this._condition
  }
  get effects(): SkillEffect[] {
    return this._effects
  }
}
