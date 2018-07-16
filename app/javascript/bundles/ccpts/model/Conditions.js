import _ from "lodash"

let __conditions = {}

export default class Conditions {

  static init(cs) {
    __conditions = (cs || {})
  }

  static unions() {
    return (__conditions.unions || [])
  }

  static sourceCategorys() {
    return (__conditions.sourcecategorys || [])
  }

  static sourceTypesFor(category) {
    return ((__conditions.sources || {})[category] || [])
  }

  static skillCategorys() {
    return (__conditions.skillcategorys || [])
  }

  static skillSubtypesFor(skill) {
    return ((__conditions.skillsubs || {})[skill] || [])
  }

  static skillEffectTypesFor(skill) {
    return ((__conditions.skilleffects || {})[skill] || [])
  }

  static abilityCategorys() {
    return (__conditions.abilitycategorys || [])
  }

  static abilityEffectsFor(category) {
    return ((__conditions.abilityeffects || {})[category] || [])
  }

  static abilitySubEffectsFor(category, effect) {
    const base = (__conditions.abilitysubeffects || {})[category]
    if (_.isEmpty(base)) {
      return []
    }
    return (base[effect] || [])
  }

  static abilityConditionsFor(category) {
    return ((__conditions.abilityconditions || {})[category] || [])
  }

  static abilitySubConditionsFor(category, cond) {
    const base = (__conditions.abilitysubconditions || {})[category]
    if (_.isEmpty(base)) {
      return []
    }
    return (base[cond] || [])
  }

  static abilityTargetsFor(category) {
    return ((__conditions.abilitytargets || {})[category] || [])
  }

  static abilitySubTargetsFor(category, target) {
    const base = (__conditions.abilitysubtargets || {})[category]
    if (_.isEmpty(base)) {
      return []
    }
    return (base[target] || [])
  }

  static chainAbirityCategorys() {
    return (__conditions.chainabilitycategorys || [])
  }

  static chainAbirityEffectsFor(category) {
    return ((__conditions.chainabilityeffects || {})[category] || [])
  }

  static chainAbirityConditionsFor(category) {
    return ((__conditions.chainabilityconditions || {})[category] || [])
  }

  static chainAbilityTargetsFor(category) {
    return ((__conditions.chainabilitytargets || {})[category] || [])
  }

  static voiceactors() {
    return (__conditions.voiceactors || [])
  }

  static voiceactorIdFor(name) {
    if (!name) {
      return null
    }
    const rsl = _.find(__conditions.voiceactors, (v) => _.eq(v[1], name))
    if (!rsl) {
      return null
    }
    return rsl[0]
  }

  static voiceactorNameFor(id) {
    if (!id) {
      return ""
    }
    const num = parseInt(id)
    const rsl = _.find(__conditions.voiceactors, (v) => _.eq(v[0], num))
    if (!rsl) {
      return ""
    }
    return rsl[1]
  }

  static illustrators() {
    return (__conditions.illustrators || [])
  }

  static illustratorIdFor(name) {
    if (!name) {
      return null
    }
    const rsl = _.find(__conditions.illustrators, (v) => _.eq(v[1], name))
    if (!rsl) {
      return null
    }
    return rsl[0]
  }

  static illustratorNameFor(id) {
    if (!id) {
      return ""
    }
    const num = parseInt(id)
    const rsl = _.find(__conditions.illustrators, (v) => _.eq(v[0], num))
    if (!rsl) {
      return ""
    }
    return rsl[1]
  }
}
