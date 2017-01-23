import _ from 'lodash'

export default class Skill {

  constructor(data) {
    this.name = (data.name || '？')
    this.explanation = (data.explanation  || '')
    this.cost = (data.cost || '？')
    this.effects = []
    if (!_.isEmpty(data.effects)){
      this.effects = _.map(data.effects, (e) => ({
        category: e.category,
        subcategory: e.subcategory,
        multi_type: (e.multi_type || ''),
        multi_condition: (e.multi_condition || ''),
        subeffect1: (e.subeffect1 || ''),
        subeffect2: (e.subeffect2 || ''),
        subeffect3: (e.subeffect3 || ''),
        subeffect4: (e.subeffect4 || ''),
        subeffect5: (e.subeffect5 || ''),
        note: (e.note || '')
      }))
    }
  }

  static subEffectForEffect(ef) {
    if (!ef) {
      return []
    }
    const arr = [ef.subeffect1, ef.subeffect2, ef.subeffect3, ef.subeffect4, ef.subeffect5]
    return _.compact(arr)
  }
}
