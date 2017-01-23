import _ from 'lodash'

export default class Ability {

  constructor(data) {
    this.name = (data.name || '')
    this.explanation = (data.explanation  || '')
    this.weaponName = (data.weaponName  || '')
    this.effects = []
    if (!_.isEmpty(data.effects)){
      this.effects = _.map(data.effects, (e) => ({
        category: e.category,
        condition: e.condition,
        effect: e.effect,
        target: e.target,
        note: (e.note || '')
      }))
    }
  }
}
