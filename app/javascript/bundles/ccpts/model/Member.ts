import Arcana from "./Arcana"

export default class Member {
  public static readonly FRIEND_KEY: string = "friend"
  public static readonly HERO_KEY: string = "hero"

  public static readonly POSITIONS: string[] = [
    "mem1", "mem2", "mem3", "mem4", "sub1", "sub2", Member.FRIEND_KEY, Member.HERO_KEY
  ]

  private _position: string
  private _arcana: Arcana
  private _chainArcana: Arcana | null = null

  constructor(pos: string, arcana: Arcana, chain: Arcana | null) {
    this._position = pos
    this._arcana = arcana

    if (pos !== Member.HERO_KEY) {
      this._chainArcana = chain
    }
  }

  get position(): string {
    return this._position
  }

  get arcana(): Arcana {
    return this._arcana
  }

  get chainArcana(): Arcana | null {
    return this._chainArcana
  }

  get cost(): number {
    if (this.position === Member.FRIEND_KEY || this.position === Member.HERO_KEY) {
      return 0
    }
    return this.chainedCost()
  }

  get code(): string {
    let code = this._arcana.jobCode
    if (this.position === Member.HERO_KEY) {
      return code
    }

    if (this._chainArcana) {
      code += this._chainArcana.jobCode
    } else {
      code += "N"
    }
    return code
  }

  public isFriend(): boolean {
    return this._position === Member.FRIEND_KEY
  }

  public isHero(): boolean {
    return this._position === Member.HERO_KEY
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

  private chainedCost(): number {
    const c = this.arcana.cost
    if (!this.chainArcana) {
      return c
    }
    return (c + this.chainArcana.chainCost)
  }
}
