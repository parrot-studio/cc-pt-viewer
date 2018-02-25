import _ from "lodash"
import React from "react"

export default class ChainAbilityConditions extends React.Component {

  constructor(props) {
    super(props)
    this.conditions = this.props.conditions
    this.notifier = this.props.notifier
  }

  handleCategoryChange(e) {
    const val = e.target.value
    if (!_.isEqual(this.props.chainabilitycategory, val)) {
      this.notifier.push({
        chainabilitycategory: val,
        chainabilitycondition: "",
        chainabilityeffect: "",
        chainabilitytarget: ""
      })
    }
  }

  handleConditionChange(e) {
    this.notifier.push({chainabilitycondition: e.target.value})
  }

  handleEffectChange(e) {
    this.notifier.push({chainabilityeffect: e.target.value})
  }

  handleTargetChange(e) {
    this.notifier.push({chainabilitytarget: e.target.value})
  }

  renderCategoryList() {
    const cs = _.map(this.conditions.chainAbirityCategorys(), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    return _.concat([<option value={""} key={""}>{"-"}</option>], cs)
  }

  renderConditionList() {
    const category = this.props.chainabilitycategory
    if (category) {
      const cs = _.map(this.conditions.chainAbirityConditionsFor(category), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  renderEffectList() {
    const category = this.props.chainabilitycategory
    if (category) {
      const cs = _.map(this.conditions.chainAbirityEffectsFor(category), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  renderTargetList() {
    const category = this.props.chainabilitycategory
    if (_.isEmpty(category)) {
      return null
    }

    const targets = this.conditions.chainAbilityTargetsFor(category)
    if (_.isEmpty(targets) || targets.length <= 1) {
      return null
    }

    const cs = _.map(targets, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    const ts = _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)

    return (
      <div className="col-sm-4 col-md-4">
        <label htmlFor="chain-ability-target">対象</label>
        <select id="chain-ability-target" className="form-control"
          value={this.props.chainabilitytarget}
          onChange={this.handleTargetChange.bind(this)}>
          {ts}
        </select>
      </div>
    )
  }

  renderAddArea() {
    if (!this.props.chainabilitycategory) {
      return null
    }

    return (
      <div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="chain-ability-condition">条件</label>
          <select id="chain-ability-condition" className="form-control"
            value={this.props.chainabilitycondition}
            onChange={this.handleConditionChange.bind(this)}>
            {this.renderConditionList()}
          </select>
        </div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="chain-ability-effect">効果</label>
          <select id="chain-ability-effect" className="form-control"
            value={this.props.chainabilityeffect}
            onChange={this.handleEffectChange.bind(this)}>
            {this.renderEffectList()}
          </select>
        </div>
        {this.renderTargetList()}
      </div>
    )
  }

  render () {
    return (
      <div className="form-group">
        <div className="col-sm-4 col-md-4">
          <label htmlFor="chain-ability-category">絆アビリティ・分類</label>
          <select id="chain-ability-category" className="form-control"
            value={this.props.chainabilitycategory}
            onChange={this.handleCategoryChange.bind(this)}>
            {this.renderCategoryList()}
          </select>
        </div>
        {this.renderAddArea()}
      </div>
    )
  }
}
