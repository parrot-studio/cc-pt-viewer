import Arcana from "./Arcana"

export default class Member {
  public arcana: Arcana
  public chainArcana: Arcana | null
  public memberKey: string | null

  constructor(a: Arcana) {
    this.arcana = a
    this.chainArcana = null
    this.memberKey = null
  }

  public chainedCost(): number {
    const c = this.arcana.cost
    if (!this.chainArcana) {
      return c
    }
    return (c + this.chainArcana.chainCost)
  }

  public canUseChainAbility(): boolean {
    if (!this.chainArcana) {
      return false
    }
    return (this.arcana.jobType === this.chainArcana.jobType)
  }

  public isSameUnion(): boolean {
    if (!this.chainArcana) {
      return false
    }
    return (this.arcana.union === this.chainArcana.union)
  }
}
