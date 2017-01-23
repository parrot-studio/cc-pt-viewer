import _ from 'lodash'

export default class Member {

  constructor(a) {
    this.arcana = a
    this.chainArcana = null
    this.memberKey = null
  }

  chainedCost() {
    const c = this.arcana.cost
    if (!this.chainArcana) {
      return c
    }
    return (c + this.chainArcana.chainCost)
  }

  canUseChainAbility() {
    if (!this.chainArcana) {
      return false
    }
    if (!_.eq(this.arcana.jobType, this.chainArcana.jobType)) {
      return false
    }
    return true
  }

  isSameUnion() {
    if (!this.chainArcana) {
      return false
    }
    if (!_.eq(this.arcana.union, this.chainArcana.union)) {
      return false
    }
    return true
  }
}
