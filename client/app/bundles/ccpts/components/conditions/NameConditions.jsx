import _ from 'lodash'
import React from 'react'

export default class NameConditions extends React.Component {

  constructor(props) {
    super(props)
    this.conditions = this.props.conditions
    this.notifier = this.props.notifier
  }

  handleActorChange(e) {
    this.notifier.push({actor: e.target.value})
  }

  handleIllustratorChange(e) {
    this.notifier.push({illustrator: e.target.value})
  }

  renderConditionList(list) {
    const cs = _.map(list, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    return _.concat([<option value={""} key={""}>{"-"}</option>], cs)
  }

  renderActors() {
    return this.renderConditionList(this.conditions.voiceactors())
  }

  renderIllustrators() {
    return this.renderConditionList(this.conditions.illustrators())
  }

  render() {
    return (
      <div className="form-group">
        <div className="col-sm-6 col-md-6">
          <label htmlFor="actor">声優</label>
          <select id="actor" className="form-control"
            value={this.props.actor}
            onChange={this.handleActorChange.bind(this)}>
            {this.renderActors()}
          </select>
        </div>
        <div className="col-sm-6 col-md-6">
          <label htmlFor="illustrator">イラストレーター</label>
          <select id="illustrator" className="form-control"
            value={this.props.illustrator}
            onChange={this.handleIllustratorChange.bind(this)}>
            {this.renderIllustrators()}
          </select>
        </div>
      </div>
    )
  }
}
