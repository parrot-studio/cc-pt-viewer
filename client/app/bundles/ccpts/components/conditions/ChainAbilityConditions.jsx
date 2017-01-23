import _ from 'lodash'
import React from 'react'

export default class ChainAbilityConditions extends React.Component {

  constructor(props) {
    super(props)
    this.conditions = this.props.conditions
    this.notifier = this.props.notifier
  }

  handleCategoryChange(e) {
    this.notifier.push({chainabilitycategory: e.target.value})
  }

  handleConditionChange(e) {
    this.notifier.push({chainabilitycondition: e.target.value})
  }

  handleEffectChange(e) {
    this.notifier.push({chainabilityeffect: e.target.value})
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

  renderAddArea() {
    if (this.props.chainabilitycategory) {
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
