/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
/* eslint-disable @typescript-eslint/no-explicit-any */
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
  private _name: string
  private _weaponName: string
  private _effects: AbilityEffect[]

  constructor(data: any) {
    this._name = (data.name || "")
    this._weaponName = (data.weapon_name || "")
    this._effects = []
    if (!_.isEmpty(data.effects)) {
      this._effects = _.map(data.effects, (e) => ({
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

  get name(): string {
    return this._name
  }

  get weaponName(): string {
    return this._weaponName
  }

  get effects(): AbilityEffect[] {
    return this._effects
  }
}
