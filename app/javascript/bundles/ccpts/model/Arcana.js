import _ from "lodash"

import Skill from "./Skill"
import Ability from "./Ability"

const __arcana_JOB_NAME_SHORT = {
  "F": "戦",
  "K": "騎",
  "A": "弓",
  "M": "魔",
  "P": "僧"
}

const __arcana_WIKI_URL = "http://xn--eckfza0gxcvmna6c.gamerch.com/"

const __arcanas = {}

export default class Arcana {

  static forCode(code) {
    return __arcanas[code]
  }

  static build(d) {
    if (!d){
      return null
    }
    const a = new Arcana(d)
    if (!a) {
      return null
    }
    if (!__arcanas[a.jobCode]) {
      __arcanas[a.jobCode] = a
    }
    if (!_.isEmpty(d.linked_arcana)) {
      Arcana.build(d.linked_arcana) // cache
    }
    return a
  }

  constructor(data) {
    this.name = data.name
    this.title = data.title
    this.rarity = data.rarity
    this.cost = data.cost
    this.chainCost = data.chain_cost
    this.jobType = data.job_type
    this.jobIndex = data.job_index
    this.jobCode = data.job_code
    this.jobName = data.job_name
    this.jobNameShort = __arcana_JOB_NAME_SHORT[this.jobType]
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
    this.personCode = data.person_code
    this.linkCode = data.link_code
    this.arcanaType = data.arcana_type

    this.maxAtk = (data.max_atk || "-")
    this.maxHp = (data.max_hp || "-")
    this.limitAtk = (data.limit_atk || "-")
    this.limitHp = (data.limit_hp || "-")
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
    this.firstAbility = new Ability(data.first_ability)
    this.secondAbility = new Ability(data.second_ability)
    this.weaponAbility = new Ability(data.weapon_ability)
    this.chainAbility = new Ability(data.chain_ability)
    this.partyAbility = new Ability(data.party_ability)

    if (_.isEmpty(this.wikiLinkName)) {
      this.wikiUrl = __arcana_WIKI_URL
    } else {
      this.wikiUrl = __arcana_WIKI_URL + encodeURIComponent(this.wikiLinkName)
    }
  }

  static sameCharacter(a, b) {
    if (!a || !b) {
      return false
    }
    return _.eq(a.personCode, b.personCode)
  }

  static sameArcana(a, b) {
    if (!a || !b) {
      return false
    }
    return _.eq(a.jobCode, b.jobCode)
  }

  static canUseChainAbility(a, b) {
    if (!a || !b) {
      return false
    }
    if (!_.eq(a.jobType, b.jobType)) {
      return false
    }
    return true
  }

  hasLink() {
    if (_.isEmpty(this.linkCode)) {
      return false
    }
    if (_.eq(this.linkCode, this.jobCode)) {
      return false
    }
    return true
  }

  isBuddy() {
    if (this.hasLink() && _.eq(this.arcanaType, "buddy")) {
      return true
    }
    return false
  }

  hasBuddy() {
    if (!this.hasLink()) {
      return false
    }
    return (!this.isBuddy() ? true : false)
  }

  hasOwner() {
    if (!this.hasLink()) {
      return false
    }
    return (this.isBuddy() ? true : false)
  }

  buddy() {
    if (!this.hasBuddy()) {
      return
    }
    return Arcana.forCode(this.linkCode)
  }

  owner() {
    if (!this.hasOwner()) {
      return
    }
    return Arcana.forCode(this.linkCode)
  }

  nameWithBuddy() {
    if (!this.hasBuddy()){
      return this.name
    }
    if (!_.isEmpty(this.buddy().personCode)) {
      return `${this.name}with${this.buddy().name}`
    }
    return `${this.name}＆${this.buddy().name}`
  }
}
