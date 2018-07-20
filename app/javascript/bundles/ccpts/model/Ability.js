import _ from "lodash"

export default class Ability {

  constructor(data) {
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
