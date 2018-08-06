import * as _ from "lodash"

import Skill from "./Skill"
import Ability from "./Ability"

export default class Arcana {
  public static forCode(code: string): Arcana | null {
    return Arcana.cache[code]
  }

  public static build(d: any): Arcana | null {
    if (!d) {
      return null
    }
    const a = new Arcana(d)
    if (!a) {
      return null
    }
    if (!Arcana.cache[a.jobCode]) {
      Arcana.cache[a.jobCode] = a
    }
    if (!_.isEmpty(d.linked_arcana)) {
      Arcana.build(d.linked_arcana) // cache
    }
    return a
  }

  public static sameArcana(a: Arcana | null, b: Arcana | null): boolean {
    if (!a || !b) {
      return false
    }
    return (a.jobCode === b.jobCode)
  }

  public static canUseChainAbility(a: Arcana | null, b: Arcana | null): boolean {
    if (!a || !b) {
      return false
    }
    return (a.jobType === b.jobType)
  }

  private static readonly cache: { [key: string]: Arcana } = {}

  private static readonly JOB_NAME_SHORT: { [key: string]: string } = {
    F: "戦",
    K: "騎",
    A: "弓",
    M: "魔",
    P: "僧"
  }

  private static readonly WIKI_URL: string = "http://xn--eckfza0gxcvmna6c.gamerch.com/"

  public name: string
  public title: string
  public rarity: number
  public cost: number
  public chainCost: number
  public jobType: string
  public jobIndex: number
  public jobCode: string
  public jobName: string
  public jobNameShort: string
  public rarityStars: string
  public jobClass: string
  public weaponType: string
  public weaponName: string
  public voiceActor: string
  public illustrator: string
  public union: string
  public sourceCategory: string
  public source: string
  public jobDetail: string
  public linkCode: string
  public arcanaType: string
  public maxAtk: number
  public maxHp: number
  public limitAtk: number
  public limitHp: number
  public wikiLinkName: string
  public wikiUrl: string

  public firstSkill: Skill
  public secondSkill: Skill | null = null
  public thirdSkill: Skill | null = null
  public inheritSkill: Skill | null = null

  public firstAbility: Ability | null = null
  public secondAbility: Ability | null = null
  public weaponAbility: Ability | null = null
  public chainAbility: Ability | null = null
  public partyAbility: Ability | null = null

  constructor(data: any) {
    this.name = data.name
    this.title = data.title
    this.rarity = data.rarity
    this.cost = data.cost
    this.chainCost = data.chain_cost
    this.jobType = data.job_type
    this.jobIndex = data.job_index
    this.jobCode = data.job_code
    this.jobName = data.job_name
    this.jobNameShort = Arcana.JOB_NAME_SHORT[this.jobType]
    this.rarityStars = "★★★★★★".slice(0, this.rarity)
    this.jobClass = data.job_class
    this.weaponType = data.weapon_type
    this.weaponName = data.weapon_name
    this.voiceActor = data.voice_actor
    if (_.isEmpty(this.voiceActor)) {
      this.voiceActor = "？"
    }
    this.illustrator = data.illustrator
    if (_.isEmpty(this.illustrator)) {
      this.illustrator = "？"
    }
    this.union = data.union
    this.sourceCategory = data.source_category
    this.source = data.source
    this.jobDetail = data.job_detail
    this.linkCode = data.link_code
    this.arcanaType = data.arcana_type

    this.maxAtk = (data.max_atk || -1)
    this.maxHp = (data.max_hp || -1)
    this.limitAtk = (data.limit_atk || -1)
    this.limitHp = (data.limit_hp || -1)
    this.wikiLinkName = data.wiki_link_name

    this.firstSkill = new Skill(data.first_skill)
    if (!_.isEmpty(data.second_skill)) {
      this.secondSkill = new Skill(data.second_skill)
    }
    if (!_.isEmpty(data.third_skill)) {
      this.thirdSkill = new Skill(data.third_skill)
    }
    if (!_.isEmpty(data.inherit_skill)) {
      this.inheritSkill = new Skill(data.inherit_skill)
    }

    if (!_.isEmpty(data.first_ability)) {
      this.firstAbility = new Ability(data.first_ability)
    }
    if (!_.isEmpty(data.second_ability)) {
      this.secondAbility = new Ability(data.second_ability)
    }
    if (!_.isEmpty(data.weapon_ability)) {
      this.weaponAbility = new Ability(data.weapon_ability)
    }
    if (!_.isEmpty(data.chain_ability)) {
      this.chainAbility = new Ability(data.chain_ability)
    }
    if (!_.isEmpty(data.party_ability)) {
      this.partyAbility = new Ability(data.party_ability)
    }

    if (_.isEmpty(this.wikiLinkName)) {
      this.wikiUrl = Arcana.WIKI_URL
    } else {
      this.wikiUrl = Arcana.WIKI_URL + encodeURIComponent(this.wikiLinkName)
    }
  }

  public maxAtkForView(): string {
    return this.valueForView(this.maxAtk)
  }

  public maxHpForView(): string {
    return this.valueForView(this.maxHp)
  }

  public limitAtkForView(): string {
    return this.valueForView(this.limitAtk)
  }

  public limitHpForView(): string {
    return this.valueForView(this.limitHp)
  }

  public hasLink(): boolean {
    if (_.isEmpty(this.linkCode)) {
      return false
    }
    if (this.linkCode === this.jobCode) {
      return false
    }
    return true
  }

  public isBuddy(): boolean {
    if (this.hasLink() && this.arcanaType === "buddy") {
      return true
    }
    return false
  }

  public hasBuddy(): boolean {
    if (!this.hasLink()) {
      return false
    }
    return (!this.isBuddy() ? true : false)
  }

  public hasOwner(): boolean {
    if (!this.hasLink()) {
      return false
    }
    return (this.isBuddy() ? true : false)
  }

  public buddy(): Arcana | null {
    if (!this.hasBuddy()) {
      return null
    }
    return Arcana.forCode(this.linkCode)
  }

  public owner(): Arcana | null {
    if (!this.hasOwner()) {
      return null
    }
    return Arcana.forCode(this.linkCode)
  }

  public nameWithBuddy(): string {
    const buddy = this.buddy()
    if (!buddy) {
      return this.name
    }
    if (this.jobCode === "K199" || this.jobCode === "A207") { // NOTE: 暫定対応
      return `${this.name}with${buddy.name}`
    }
    return `${this.name}＆${buddy.name}`
  }

  public valueForSort(col: string): any {
    switch (col) {
      case "name":
        return this.name
      case "cost":
        return this.cost
      case "maxAtk":
        return this.maxAtk
      case "maxHp":
        return this.maxHp
      case "limitAtk":
        return this.limitAtk
      case "limitHp":
        return this.limitHp
      default:
        return null
    }
  }

  private valueForView(v: number): string {
    if (v < 1) {
      return "-"
    }
    return v.toString()
  }
}
