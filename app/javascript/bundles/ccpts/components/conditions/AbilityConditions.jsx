import _ from "lodash"
import React from "react"

export default class AbilityConditions extends React.Component {

  constructor(props) {
    super(props)
    this.conditions = this.props.conditions
    this.notifier = this.props.notifier
  }

  handleCategoryChange(e) {
    const val = e.target.value
    if (!_.isEqual(this.props.abilitycategory, val)) {
      this.notifier.push({
        abilitycategory: val,
        abilitycondition: "",
        abilitysubcondition: "",
        abilityeffect: "",
        abilitysubeffect: "",
        abilitytarget: "",
        abilitysubtarget: ""
      })
    }
  }

  handleConditionChange(e) {
    const val = e.target.value
    if (!_.isEqual(this.props.abilitycondition, val)) {
      this.notifier.push({
        abilitycondition: val,
        abilitysubcondition: ""
      })
    }
  }

  handleSubConditionChange(e) {
    this.notifier.push({ abilitysubcondition: e.target.value })
  }

  handleEffectChange(e) {
    const val = e.target.value
    if (!_.isEqual(this.props.abilityeffect, val)) {
      this.notifier.push({
        abilityeffect: val,
        abilitysubeffect: ""
      })
    }
  }

  handleSubEffectChange(e) {
    this.notifier.push({ abilitysubeffect: e.target.value })
  }

  handleTargetChange(e) {
    const val = e.target.value
    if (!_.isEqual(this.props.abilitytarget, val)) {
      this.notifier.push({
        abilitytarget: val,
        abilitysubtarget: ""
      })
    }
  }

  handleSubTargetChange(e) {
    this.notifier.push({ abilitysubtarget: e.target.value })
  }

  renderCategoryList() {
    const cs = _.map(this.conditions.abilityCategorys(), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    return _.concat([<option value={""} key={""}>{"-"}</option>], cs)
  }

  renderConditionList() {
    const category = this.props.abilitycategory
    if (category) {
      const cs = _.map(this.conditions.abilityConditionsFor(category), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  renderSubConditionList() {
    const category = this.props.abilitycategory
    const cond = this.props.abilitycondition
    if (category && cond) {
      const cs = _.map(this.conditions.abilitySubConditionsFor(category, cond), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  renderEffectList() {
    const category = this.props.abilitycategory
    if (category) {
      const cs = _.map(this.conditions.abilityEffectsFor(category), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  renderSubEffectList() {
    const category = this.props.abilitycategory
    const effect = this.props.abilityeffect
    let sefs = []
    if (category && effect) {
      sefs = this.conditions.abilitySubEffectsFor(category, effect)
    }
    if (!_.isEmpty(sefs)) {
      const cs = _.map(sefs, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return null
    }
  }

  renderTargetList() {
    const category = this.props.abilitycategory
    if (_.isEmpty(category)) {
      return null
    }

    const targets = this.conditions.abilityTargetsFor(category)
    if (_.isEmpty(targets) || targets.length <= 1) {
      return null
    }

    const cs = _.map(targets, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    const ts = _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)

    return (
      <div className="col-sm-4 col-md-4">
        <label htmlFor="ability-target">対象</label>
        <select id="ability-target" className="form-control"
          value={this.props.abilitytarget}
          onChange={this.handleTargetChange.bind(this)}>
          {ts}
        </select>
      </div>
    )
  }

  renderConditionArea() {
    if (_.isEmpty(this.props.abilitycategory)) {
      return null
    }

    return (
      <div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="ability-condition">条件</label>
          <select id="ability-condition" className="form-control"
            value={this.props.abilitycondition}
            onChange={this.handleConditionChange.bind(this)}>
            {this.renderConditionList()}
          </select>
        </div>
        <div className="col-sm-4 col-md-4">
          {this.renderConditionAddArea()}
        </div>
      </div>
    )
  }

  renderConditionAddArea() {
    const category = this.props.abilitycategory
    const cond = this.props.abilitycondition
    let scfs = []
    if (category && cond) {
      scfs = this.conditions.abilitySubConditionsFor(category, cond)
    }
    if (_.isEmpty(scfs)) {
      return null
    }

    const cs = _.map(scfs, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    const es = _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)

    return (
      <div>
        <label htmlFor="ability-subcondition">条件（追加）</label>
        <select id="ability-subcondition" className="form-control"
          value={this.props.abilitysubcondition}
          onChange={this.handleSubConditionChange.bind(this)}>
          {es}
        </select>
      </div>
    )
  }

  renderEffectArea() {
    if (_.isEmpty(this.props.abilitycategory)) {
      return null
    }

    return (
      <div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="ability-effect">効果</label>
          <select id="ability-effect" className="form-control"
            value={this.props.abilityeffect}
            onChange={this.handleEffectChange.bind(this)}>
            {this.renderEffectList()}
          </select>
        </div>
        <div className="col-sm-4 col-md-4">
          {this.renderEffectAddArea()}
        </div>
      </div>
    )
  }

  renderEffectAddArea() {
    const category = this.props.abilitycategory
    const effect = this.props.abilityeffect
    let sefs = []
    if (category && effect) {
      sefs = this.conditions.abilitySubEffectsFor(category, effect)
    }
    if (_.isEmpty(sefs)) {
      return null
    }

    const cs = _.map(sefs, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    const es = _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)

    return (
      <div>
        <label htmlFor="ability-subeffect">効果（追加）</label>
        <select id="ability-subeffect" className="form-control"
          value={this.props.abilitysubeffect}
          onChange={this.handleSubEffectChange.bind(this)}>
          {es}
        </select>
      </div>
    )
  }

  renderTargetArea() {
    const category = this.props.abilitycategory
    if (_.isEmpty(category)) {
      return null
    }

    const targets = this.conditions.abilityTargetsFor(category)
    if (_.isEmpty(targets) || targets.length <= 1) {
      return null
    }

    const cs = _.map(targets, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    const ts = _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)

    return (
      <div>
        <div className="form-group">
          <div className="col-sm-4 col-md-4">
          </div>
          <div className="col-sm-4 col-md-4">
            <label htmlFor="ability-target">対象</label>
            <select id="ability-target" className="form-control"
              value={this.props.abilitytarget}
              onChange={this.handleTargetChange.bind(this)}>
              {ts}
            </select>
          </div>
          <div className="col-sm-4 col-md-4">
            {this.renderTargetAddArea()}
          </div>
        </div>
      </div>
    )
  }

  renderTargetAddArea() {
    const category = this.props.abilitycategory
    const target = this.props.abilitytarget
    let stfs = []
    if (category && target) {
      stfs = this.conditions.abilitySubTargetsFor(category, target)
    }
    if (_.isEmpty(stfs)) {
      return null
    }

    const cs = _.map(stfs, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    const es = _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)

    return (
      <div>
        <label htmlFor="ability-subtarget">対象（追加）</label>
        <select id="ability-subtarget" className="form-control"
          value={this.props.abilitysubtarget}
          onChange={this.handleSubTargetChange.bind(this)}>
          {es}
        </select>
      </div>
    )
  }

  render() {
    return (
      <div>
        <div className="form-group">
          <div className="col-sm-4 col-md-4">
            <label htmlFor="ability-category">アビリティ・分類</label>
            <select id="ability-category" className="form-control"
              value={this.props.abilitycategory}
              onChange={this.handleCategoryChange.bind(this)}>
              {this.renderCategoryList()}
            </select>
          </div>
          {this.renderConditionArea()}
        </div>
        <div className="form-group">
          <div className="col-sm-4 col-md-4">
          </div>
          {this.renderEffectArea()}
        </div>
        {this.renderTargetArea()}
      </div>
    )
  }
}
