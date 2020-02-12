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
    return a.isEqual(b)
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

  private static readonly JOB_NAME: { [key: string]: string } = {
    F: "戦士",
    K: "騎士",
    A: "弓使い",
    M: "魔法使い",
    P: "僧侶"
  }

  private static readonly WIKI_URL: string = "http://xn--eckfza0gxcvmna6c.gamerch.com/"

  private _name: string
  private _title: string
  private _rarity: number
  private _cost: number
  private _chainCost: number
  private _jobType: string
  private _jobIndex: number
  private _jobCode: string
  private _jobName: string
  private _jobNameShort: string
  private _rarityStars: string
  private _jobClass: string
  private _weaponType: string
  private _weaponName: string
  private _voiceActor: string
  private _illustrator: string
  private _union: string
  private _sourceCategory: string
  private _source: string
  private _jobDetail: string
  private _linkCode: string
  private _arcanaType: string
  private _maxAtk: number
  private _maxHp: number
  private _limitAtk: number
  private _limitHp: number
  private _wikiLinkName: string
  private _wikiUrl: string

  private _firstSkill: Skill
  private _secondSkill: Skill | null = null
  private _thirdSkill: Skill | null = null
  private _inheritSkill: Skill | null = null
  private _heroicSkill: Skill | null = null
  private _decisiveOrder: Skill | null = null
  private _decisiveSkill: Skill | null = null

  private _firstAbility: Ability | null = null
  private _secondAbility: Ability | null = null
  private _weaponAbility: Ability | null = null
  private _chainAbility: Ability | null = null
  private _partyAbility: Ability | null = null
  private _passiveAbility: Ability | null = null
  private _gunkiAbilities: Ability[] = []

  get name(): string {
    return this._name
  }
  get title(): string {
    return this._title
  }
  get rarity(): number {
    return this._rarity
  }
  get cost(): number {
    return this._cost
  }
  get chainCost(): number {
    return this._chainCost
  }
  get jobType(): string {
    return this._jobType
  }
  get jobIndex(): number {
    return this._jobIndex
  }
  get jobCode(): string {
    return this._jobCode
  }
  get jobName(): string {
    return this._jobName
  }
  get jobNameShort(): string {
    return this._jobNameShort
  }
  get rarityStars(): string {
    return this._rarityStars
  }
  get jobClass(): string {
    return this._jobClass
  }
  get weaponType(): string {
    return this._weaponType
  }
  get weaponName(): string {
    return this._weaponName
  }
  get voiceActor(): string {
    return this._voiceActor
  }
  get illustrator(): string {
    return this._illustrator
  }
  get union(): string {
    return this._union
  }
  get sourceCategory(): string {
    return this._sourceCategory
  }
  get source(): string {
    return this._source
  }
  get jobDetail(): string {
    return this._jobDetail
  }
  get linkCode(): string {
    return this._linkCode
  }
  get arcanaType(): string {
    return this._arcanaType
  }
  get maxAtk(): number {
    return this._maxAtk
  }
  get maxHp(): number {
    return this._maxHp
  }
  get limitAtk(): number {
    return this._limitAtk
  }
  get limitHp(): number {
    return this._limitHp
  }
  get wikiLinkName(): string {
    return this._wikiLinkName
  }
  get wikiUrl(): string {
    return this._wikiUrl
  }

  get firstSkill(): Skill {
    return this._firstSkill
  }
  get secondSkill(): Skill | null {
    return this._secondSkill
  }
  get thirdSkill(): Skill | null {
    return this._thirdSkill
  }
  get inheritSkill(): Skill | null {
    return this._inheritSkill
  }
  get heroicSkill(): Skill | null {
    return this._heroicSkill
  }
  get decisiveOrder(): Skill | null {
    return this._decisiveOrder
  }
  get decisiveSkill(): Skill | null {
    return this._decisiveSkill
  }

  get firstAbility(): Ability | null {
    return this._firstAbility
  }
  get secondAbility(): Ability | null {
    return this._secondAbility
  }
  get weaponAbility(): Ability | null {
    return this._weaponAbility
  }
  get chainAbility(): Ability | null {
    return this._chainAbility
  }
  get partyAbility(): Ability | null {
    return this._partyAbility
  }
  get passiveAbility(): Ability | null {
    return this._passiveAbility
  }
  get gunkiAbilities(): Ability[] {
    return this._gunkiAbilities
  }

  constructor(data: any) {
    this._name = data.name
    this._title = data.title
    this._rarity = data.rarity
    this._cost = data.cost
    this._chainCost = data.chain_cost
    this._jobType = data.job_type
    this._jobIndex = data.job_index
    this._jobCode = data.job_code
    this._jobName = Arcana.JOB_NAME[this._jobType]
    this._jobNameShort = Arcana.JOB_NAME_SHORT[this.jobType]
    this._rarityStars = "★★★★★★".slice(0, this._rarity)
    this._jobClass = data.job_class
    this._weaponType = data.weapon_type
    this._weaponName = data.weapon_name

    this._voiceActor = data.voice_actor
    if (_.isEmpty(this._voiceActor)) {
      this._voiceActor = "？"
    }
    this._illustrator = data.illustrator
    if (_.isEmpty(this._illustrator)) {
      this._illustrator = "？"
    }

    this._union = data.union
    this._sourceCategory = data.source_category
    this._source = data.source
    this._jobDetail = data.job_detail
    this._linkCode = data.link_code
    this._arcanaType = data.arcana_type

    this._maxAtk = (data.max_atk || -1)
    this._maxHp = (data.max_hp || -1)
    this._limitAtk = (data.limit_atk || -1)
    this._limitHp = (data.limit_hp || -1)
    this._wikiLinkName = data.wiki_link_name

    if (_.isEmpty(this._wikiLinkName)) {
      this._wikiUrl = Arcana.WIKI_URL
    } else {
      this._wikiUrl = Arcana.WIKI_URL + encodeURIComponent(this._wikiLinkName)
    }

    this._firstSkill = new Skill(data.first_skill)
    if (!_.isEmpty(data.second_skill)) {
      this._secondSkill = new Skill(data.second_skill)
    }
    if (!_.isEmpty(data.third_skill)) {
      this._thirdSkill = new Skill(data.third_skill)
    }
    if (!_.isEmpty(data.inherit_skill)) {
      this._inheritSkill = new Skill(data.inherit_skill)
    }
    if (!_.isEmpty(data.heroic_skill)) {
      this._heroicSkill = new Skill(data.heroic_skill)
    }
    if (!_.isEmpty(data.decisive_order)) {
      this._decisiveOrder = new Skill(data.decisive_order)
    }
    if (!_.isEmpty(data.decisive_skill)) {
      this._decisiveSkill = new Skill(data.decisive_skill)
    }

    if (!_.isEmpty(data.first_ability)) {
      this._firstAbility = new Ability(data.first_ability)
    }
    if (!_.isEmpty(data.second_ability)) {
      this._secondAbility = new Ability(data.second_ability)
    }
    if (!_.isEmpty(data.weapon_ability)) {
      this._weaponAbility = new Ability(data.weapon_ability)
    }
    if (!_.isEmpty(data.chain_ability)) {
      this._chainAbility = new Ability(data.chain_ability)
    }
    if (!_.isEmpty(data.party_ability)) {
      this._partyAbility = new Ability(data.party_ability)
    }
    if (!_.isEmpty(data.passive_ability)) {
      this._passiveAbility = new Ability(data.passive_ability)
    }
    this._gunkiAbilities = _.map(data.gunki_abilites || [], (ga) => new Ability(ga))
  }

  public maxAtkForView(): string {
    return this.valueForView(this._maxAtk)
  }

  public maxHpForView(): string {
    return this.valueForView(this._maxHp)
  }

  public limitAtkForView(): string {
    return this.valueForView(this._limitAtk)
  }

  public limitHpForView(): string {
    return this.valueForView(this._limitHp)
  }

  public hasLink(): boolean {
    if (_.isEmpty(this._linkCode)) {
      return false
    }
    if (this._linkCode === this._jobCode) {
      return false
    }
    return true
  }

  public hasGunkiAbility(): boolean {
    return (this._gunkiAbilities.length > 0)
  }

  public hasKessen(): boolean {
    if (this._decisiveOrder || this._decisiveSkill || this._passiveAbility) {
      return true
    }

    return false
  }

  public isBuddy(): boolean {
    if (this.hasLink() && this._arcanaType === "buddy") {
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
    return Arcana.forCode(this._linkCode)
  }

  public owner(): Arcana | null {
    if (!this.hasOwner()) {
      return null
    }
    return Arcana.forCode(this._linkCode)
  }

  public nameWithBuddy(): string {
    const buddy = this.buddy()
    if (!buddy) {
      return this._name
    }

    if (this._jobDetail === "Combination") {
      return `${this._name}with${buddy.name}`
    }
    return `${this._name}＆${buddy.name}`
  }

  public valueForSort(col: string): any {
    switch (col) {
      case "name":
        return this._name
      case "cost":
        return this._cost
      case "maxAtk":
        return this._maxAtk
      case "maxHp":
        return this._maxHp
      case "limitAtk":
        return this._limitAtk
      case "limitHp":
        return this._limitHp
      default:
        return null
    }
  }

  public isEqual(other: Arcana | null) {
    if (!other) {
      return false
    }
    if (this._jobCode !== other.jobCode) {
      return false
    }
    return true
  }

  private valueForView(v: number): string {
    if (v < 1) {
      return "-"
    }
    return v.toString()
  }
}
