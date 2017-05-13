import _ from "lodash"
import React from "react"

export default class SourceConditions extends React.Component {

  constructor(props) {
    super(props)

    this.conditions = this.props.conditions
    this.notifier = this.props.notifier
  }

  handleCategoryChange(e) {
    this.notifier.push({sourcecategory: e.target.value})
  }

  handleSourceChange(e) {
    this.notifier.push({source: e.target.value})
  }

  renderSourceCategorys() {
    const cs = _.map(this.conditions.sourceCategorys(), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    return _.concat([<option key="none" value={""}>{"-"}</option>], cs)
  }

  renderSourceOptions() {
    const source = this.props.sourcecategory
    if (source) {
      const ss = _.map(this.conditions.sourceTypesFor(source), (s) => <option value={s[0]} key={s[0]}>{s[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], ss)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  render() {
    return (
      <div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="source-category">入手先</label>
          <select id="source-category" className="form-control"
            value={this.props.sourcecategory} onChange={this.handleCategoryChange.bind(this)}>
            {this.renderSourceCategorys()}
          </select>
        </div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="source">入手先・詳細</label>
          <select id="source" className="form-control"
            value={this.props.source} onChange={this.handleSourceChange.bind(this)}>
            {this.renderSourceOptions()}
          </select>
        </div>
      </div>
    )
  }
}
