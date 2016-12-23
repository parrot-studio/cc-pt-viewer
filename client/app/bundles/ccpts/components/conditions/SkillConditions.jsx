import _ from 'lodash'
import React from 'react'

export default class SkillConditions extends React.Component {

  constructor(props) {
    super(props)
    this.conditions = this.props.conditions
    this.notifier = this.props.notifier
  }

  handleCategoryChange(e) {
    this.notifier.push({skill: e.target.value})
  }

  handleCostChange(e) {
    this.notifier.push({skillcost: e.target.value})
  }

  handleSubChange(e) {
    this.notifier.push({skillsub: e.target.value})
  }

  handleEffectChange(e) {
    this.notifier.push({skilleffect: e.target.value})
  }

  renderConditionList(list) {
    let cs = _.map(list, (c) => {
      return <option value={c[0]} key={c[0]}>{c[1]}</option>
    })
    return _.concat([<option value={""} key={""}>{"-"}</option>], cs)
  }

  renderCategoryList() {
    return this.renderConditionList(this.conditions.skillCategorys())
  }

  renderCostList() {
    let list = [
      ["3", "3"],
      ["3D", "3以下"],
      ["2", "2"],
      ["2D", "2以下"],
      ["1", "1"],
    ]
    return this.renderConditionList(list)
  }

  renderSubList() {
    let category = this.props.skill
    if (category) {
      let cs = _.map(this.conditions.skillSubtypesFor(category), (c) => {
        return <option value={c[0]} key={c[0]}>{c[1]}</option>
      })
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  renderEffectList() {
    let category = this.props.skill
    if (category) {
      let cs = _.map(this.conditions.skillEffectTypesFor(category), (c) => {
        return <option value={c[0]} key={c[0]}>{c[1]}</option>
      })
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  renderAddArea() {
    if (this.props.skill) {
      return (
        <div>
          <div className="col-sm-4 col-md-4">
            <label htmlFor="skill-sub">対象範囲</label>
            <select id="skill-sub" className="form-control"
              value={this.props.skillsub}
              onChange={this.handleSubChange.bind(this)}>
              {this.renderSubList()}
            </select>
          </div>
          <div className="col-sm-3 col-md-3">
            <label htmlFor="skill-effect">追加効果</label>
            <select id="skill-effect" className="form-control"
              value={this.props.skilleffect}
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

  render() {
    return (
      <div className="form-group">
        <div className="col-sm-3 col-md-3">
          <label htmlFor="skill">スキル・効果</label>
          <select id="skill" className="form-control"
            value={this.props.skill}
            onChange={this.handleCategoryChange.bind(this)}>
            {this.renderCategoryList()}
          </select>
        </div>
        <div className="col-sm-2 col-md-2">
          <label htmlFor="skill-cost">マナ</label>
          <select id="skill-cost" className="form-control"
            value={this.props.skillcost}
            onChange={this.handleCostChange.bind(this)}>
            {this.renderCostList()}
          </select>
        </div>
        {this.renderAddArea()}
      </div>
    )
  }
}
