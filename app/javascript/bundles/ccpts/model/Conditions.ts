import * as _ from "lodash"

export default class Conditions {
  public static init(cs: any) {
    Conditions.conditions = (cs || {})
  }

  public static unions(): any[] {
    return (Conditions.conditions.unions || [])
  }

  public static sourceCategorys(): any[] {
    return (Conditions.conditions.sourcecategorys || [])
  }

  public static sourceTypesFor(category: string): any[] {
    return ((Conditions.conditions.sources || {})[category] || [])
  }

  public static skillCategorys(): any[] {
    return (Conditions.conditions.skillcategorys || [])
  }

  public static skillSubtypesFor(skill: string): any[] {
    return ((Conditions.conditions.skillsubs || {})[skill] || [])
  }

  public static skillEffectTypesFor(skill: string): any[] {
    return ((Conditions.conditions.skilleffects || {})[skill] || [])
  }

  public static abilityCategorys(): any[] {
    return (Conditions.conditions.abilitycategorys || [])
  }

  public static abilityEffectsFor(category: string): any[] {
    return ((Conditions.conditions.abilityeffects || {})[category] || [])
  }

  public static abilitySubEffectsFor(category: string, effect: string): any[] {
    const base = (Conditions.conditions.abilitysubeffects || {})[category]
    if (_.isEmpty(base)) {
      return []
    }
    return (base[effect] || [])
  }

  public static abilityConditionsFor(category: string): any[] {
    return ((Conditions.conditions.abilityconditions || {})[category] || [])
  }

  public static abilitySubConditionsFor(category: string, cond: string): any[] {
    const base = (Conditions.conditions.abilitysubconditions || {})[category]
    if (_.isEmpty(base)) {
      return []
    }
    return (base[cond] || [])
  }

  public static abilityTargetsFor(category: string): any[] {
    return ((Conditions.conditions.abilitytargets || {})[category] || [])
  }

  public static abilitySubTargetsFor(category: string, target: string): any[] {
    const base = (Conditions.conditions.abilitysubtargets || {})[category]
    if (_.isEmpty(base)) {
      return []
    }
    return (base[target] || [])
  }

  public static chainAbirityCategorys(): any[] {
    return (Conditions.conditions.chainabilitycategorys || [])
  }

  public static chainAbirityEffectsFor(category: string): any[] {
    return ((Conditions.conditions.chainabilityeffects || {})[category] || [])
  }

  public static chainAbirityConditionsFor(category: string): any[] {
    return ((Conditions.conditions.chainabilityconditions || {})[category] || [])
  }

  public static chainAbilityTargetsFor(category: string): any[] {
    return ((Conditions.conditions.chainabilitytargets || {})[category] || [])
  }

  public static voiceactors(): any[] {
    return (Conditions.conditions.voiceactors || [])
  }

  public static voiceactorIdFor(name: string): number | null {
    if (!name) {
      return null
    }
    const rsl = _.find(Conditions.conditions.voiceactors, (v) => _.eq(v[1], name))
    if (!rsl) {
      return null
    }
    return rsl[0]
  }

  public static voiceactorNameFor(id: number | string): string {
    if (!id) {
      return ""
    }
    let num: number = 0
    if (typeof id === "number") {
      num = id
    } else {
      num = parseInt(id, 10)
    }
    const rsl = _.find(Conditions.conditions.voiceactors, (v) => _.eq(v[0], num))
    if (!rsl) {
      return ""
    }
    return rsl[1]
  }

  public static illustrators(): any[] {
    return (Conditions.conditions.illustrators || [])
  }

  public static illustratorIdFor(name: string): number | null {
    if (!name) {
      return null
    }
    const rsl = _.find(Conditions.conditions.illustrators, (v) => _.eq(v[1], name))
    if (!rsl) {
      return null
    }
    return rsl[0]
  }

  public static illustratorNameFor(id: number | string): string {
    if (!id) {
      return ""
    }
    let num: number = 0
    if (typeof id === "number") {
      num = id
    } else {
      num = parseInt(id, 10)
    }
    const rsl = _.find(Conditions.conditions.illustrators, (v) => _.eq(v[0], num))
    if (!rsl) {
      return ""
    }
    return rsl[1]
  }

  private static conditions: { [key: string]: any } = {}
}
