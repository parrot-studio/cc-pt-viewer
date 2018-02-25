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
        abilityeffect: "",
        abilitytarget: ""
      })
    }
  }

  handleConditionChange(e) {
    this.notifier.push({abilitycondition: e.target.value})
  }

  handleEffectChange(e) {
    this.notifier.push({abilityeffect: e.target.value})
  }

  handleTargetChange(e) {
    this.notifier.push({abilitytarget: e.target.value})
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

  renderEffectList() {
    const category = this.props.abilitycategory
    if (category) {
      const cs = _.map(this.conditions.abilityEffectsFor(category), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
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

  renderAddArea() {
    if (this.props.abilitycategory) {
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
            <label htmlFor="ability-effect">効果</label>
            <select id="ability-effect" className="form-control"
              value={this.props.abilityeffect}
              onChange={this.handleEffectChange.bind(this)}>
              {this.renderEffectList()}
            </select>
          </div>
          {this.renderTargetList()}
        </div>
      )
    } else {
      return <div />
    }
  }

  render () {
    return (
      <div className="form-group">
        <div className="col-sm-4 col-md-4">
          <label htmlFor="ability-category">アビリティ・分類</label>
          <select id="ability-category" className="form-control"
            value={this.props.abilitycategory}
            onChange={this.handleCategoryChange.bind(this)}>
            {this.renderCategoryList()}
          </select>
        </div>
        {this.renderAddArea()}
      </div>
    )
  }
}
