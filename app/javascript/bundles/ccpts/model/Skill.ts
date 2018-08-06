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

  public name: string
  public cost: number
  public effects: SkillEffect[]

  constructor(data: any) {
    this.name = (!_.isEmpty(data.name) ? data.name : "？")
    this.cost = (_.isInteger(data.cost) ? data.cost : -1)
    this.effects = []
    if (!_.isEmpty(data.effects)) {
      this.effects = _.map(data.effects, (e) => ({
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

  public costForView(): string {
    if (this.cost < 1) {
      return "-"
    }
    return this.cost.toString()
  }
}
