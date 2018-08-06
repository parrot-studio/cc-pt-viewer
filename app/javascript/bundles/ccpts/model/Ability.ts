import * as _ from "lodash"

export interface AbilityEffect {
  category: string
  condition: string
  subCondition: string
  conditionNote: string
  effect: string
  subEffect: string
  effectNote: string
  target: string
  subTarget: string
  targetNote: string
}

export default class Ability {
  public name: string
  public weaponName: string
  public effects: AbilityEffect[]

  constructor(data: any) {
    this.name = (data.name || "")
    this.weaponName = (data.weapon_name || "")
    this.effects = []
    if (!_.isEmpty(data.effects)) {
      this.effects = _.map(data.effects, (e) => ({
        category: e.category,
        condition: e.condition,
        subCondition: e.sub_condition,
        conditionNote: e.condition_note,
        effect: e.effect,
        subEffect: e.sub_effect,
        effectNote: e.effect_note,
        target: e.target,
        subTarget: e.sub_target,
        targetNote: e.target_note
      }))
    }
  }
}
