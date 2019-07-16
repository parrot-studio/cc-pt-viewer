import * as _ from "lodash"
import * as Bacon from "baconjs"

import { QueryParam } from "./Query"

export interface ConditionsNotifier {
  notifier: Bacon.Bus<QueryParam>
}

export interface ConditionParams {
  abilitycategorys: Array<[string, string]>
  abilityconditions: { [key: string]: Array<[string, string]> }
  abilityeffects: { [key: string]: Array<[string, string]> }
  abilitytargets: { [key: string]: Array<[string, string]> }
  abilitysubconditions: { [key: string]: { [key: string]: Array<[string, string]> } }
  abilitysubeffects: { [key: string]: { [key: string]: Array<[string, string]> } }
  abilitysubtargets: { [key: string]: { [key: string]: Array<[string, string]> } }
  chainabilitycategorys: Array<[string, string]>
  chainabilityconditions: { [key: string]: Array<[string, string]> }
  chainabilityeffects: { [key: string]: Array<[string, string]> }
  chainabilitytargets: { [key: string]: Array<[string, string]> }
  chainabilitysubconditions: { [key: string]: { [key: string]: Array<[string, string]> } }
  chainabilitysubeffects: { [key: string]: { [key: string]: Array<[string, string]> } }
  chainabilitysubtargets: { [key: string]: { [key: string]: Array<[string, string]> } }
  skillcategorys: Array<[string, string]>
  skilleffects: { [key: string]: Array<[string, string]> }
  skillsubs: { [key: string]: Array<[string, string]> }
  sourcecategorys: Array<[string, string]>
  sources: { [key: string]: Array<[string, string]> }
  unions: Array<[string, string]>
  illustrators: Array<[number, string]>
  voiceactors: Array<[number, string]>
}

export default class Conditions {
  public static init(cs: ConditionParams) {
    Conditions.conditions = cs
  }

  public static unions(): Array<[string, string]> {
    return (Conditions.conditions.unions || [])
  }

  public static sourceCategorys(): Array<[string, string]> {
    return (Conditions.conditions.sourcecategorys || [])
  }

  public static sourceTypesFor(category: string): Array<[string, string]> {
    return ((Conditions.conditions.sources || {})[category] || [])
  }

  public static skillCategorys(): Array<[string, string]> {
    return (Conditions.conditions.skillcategorys || [])
  }

  public static skillSubtypesFor(skill: string): Array<[string, string]> {
    return ((Conditions.conditions.skillsubs || {})[skill] || [])
  }

  public static skillEffectTypesFor(skill: string): Array<[string, string]> {
    return ((Conditions.conditions.skilleffects || {})[skill] || [])
  }

  public static abilityCategorys(): Array<[string, string]> {
    return (Conditions.conditions.abilitycategorys || [])
  }

  public static abilityEffectsFor(category: string): Array<[string, string]> {
    return ((Conditions.conditions.abilityeffects || {})[category] || [])
  }

  public static abilitySubEffectsFor(category: string, effect: string): Array<[string, string]> {
    const base = (Conditions.conditions.abilitysubeffects || {})[category]
    if (_.isEmpty(base)) {
      return []
    }
    return (base[effect] || [])
  }

  public static abilityConditionsFor(category: string): Array<[string, string]> {
    return ((Conditions.conditions.abilityconditions || {})[category] || [])
  }

  public static abilitySubConditionsFor(category: string, cond: string): Array<[string, string]> {
    const base = (Conditions.conditions.abilitysubconditions || {})[category]
    if (_.isEmpty(base)) {
      return []
    }
    return (base[cond] || [])
  }

  public static abilityTargetsFor(category: string): Array<[string, string]> {
    return ((Conditions.conditions.abilitytargets || {})[category] || [])
  }

  public static abilitySubTargetsFor(category: string, target: string): Array<[string, string]> {
    const base = (Conditions.conditions.abilitysubtargets || {})[category]
    if (_.isEmpty(base)) {
      return []
    }
    return (base[target] || [])
  }

  public static chainAbirityCategorys(): Array<[string, string]> {
    return (Conditions.conditions.chainabilitycategorys || [])
  }

  public static chainAbirityEffectsFor(category: string): Array<[string, string]> {
    return ((Conditions.conditions.chainabilityeffects || {})[category] || [])
  }

  public static chainAbirityConditionsFor(category: string): Array<[string, string]> {
    return ((Conditions.conditions.chainabilityconditions || {})[category] || [])
  }

  public static chainAbilityTargetsFor(category: string): Array<[string, string]> {
    return ((Conditions.conditions.chainabilitytargets || {})[category] || [])
  }

  public static voiceactors(): Array<[number, string]> {
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

  public static illustrators(): Array<[number, string]> {
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

  private static conditions: ConditionParams
}
