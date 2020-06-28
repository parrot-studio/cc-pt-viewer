/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import * as _ from "lodash"

export interface SkillEffect {
  category: string
  subcategory: string
  multiType: string
  multiCondition: string
  subEffect1: string
  subEffect2: string
  subEffect3: string
  subEffect4: string
  subEffect5: string
  note: string
}

export default class Skill {
  public static subEffectForEffect(ef: SkillEffect): string[] {
    if (!ef) {
      return []
    }
    const arr = [ef.subEffect1, ef.subEffect2, ef.subEffect3, ef.subEffect4, ef.subEffect5]
    return _.compact(arr)
  }

  private _name: string
  private _cost: number
  private _effects: SkillEffect[]

  constructor(data: any) {
    this._name = (!_.isEmpty(data.name) ? data.name : "？")
    this._cost = (_.isInteger(data.cost) ? data.cost : -1)
    this._effects = []
    if (!_.isEmpty(data.effects)) {
      this._effects = _.map(data.effects, (e) => ({
        category: e.category,
        subcategory: e.subcategory,
        multiType: (e.multi_type || ""),
        multiCondition: (e.multi_condition || ""),
        subEffect1: (e.subeffect1 || ""),
        subEffect2: (e.subeffect2 || ""),
        subEffect3: (e.subeffect3 || ""),
        subEffect4: (e.subeffect4 || ""),
        subEffect5: (e.subeffect5 || ""),
        note: (e.note || "")
      }))
    }
  }

  get name(): string {
    return this._name
  }

  get cost(): number {
    return this._cost
  }

  get effects(): SkillEffect[] {
    return this._effects
  }

  public costForView(): string {
    if (this.cost < 1) {
      return "-"
    }
    return this.cost.toString()
  }
}
