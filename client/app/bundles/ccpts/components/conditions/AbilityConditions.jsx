import _ from 'lodash'
import React from 'react'

export default class AbilityConditions extends React.Component {

  constructor(props) {
    super(props)
    this.conditions = this.props.conditions
    this.notifier = this.props.notifier
  }

  handleCategoryChange(e) {
    this.notifier.push({abilitycategory: e.target.value})
  }

  handleConditionChange(e) {
    this.notifier.push({abilitycondition: e.target.value})
  }

  handleEffectChange(e) {
    this.notifier.push({abilityeffect: e.target.value})
  }

  renderCategoryList() {
    let cs = _.map(this.conditions.abilityCategorys(), (c) => {
      return <option value={c[0]} key={c[0]}>{c[1]}</option>
    })
    return _.concat([<option value={""} key={""}>{"-"}</option>], cs)
  }

  renderConditionList() {
    let category = this.props.abilitycategory
    if (category) {
      let cs = _.map(this.conditions.abilityConditionsFor(category), (c) => {
        return <option value={c[0]} key={c[0]}>{c[1]}</option>
      })
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  renderEffectList() {
    let category = this.props.abilitycategory
    if (category) {
      let cs = _.map(this.conditions.abilityEffectsFor(category), (c) => {
        return <option value={c[0]} key={c[0]}>{c[1]}</option>
      })
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
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
