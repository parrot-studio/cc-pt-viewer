import * as _ from "lodash"
import * as React from "react"

import Conditions, { ConditionsNotifier } from "../../model/Conditions"

interface SourceConditionsProps extends ConditionsNotifier {
  sourcecategory: string
  source: string
}

export default class SourceConditions extends React.Component<SourceConditionsProps> {

  public render(): JSX.Element {
    return (
      <div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="source-category">入手先</label>
          <select
            id="source-category"
            className="form-control"
            value={this.props.sourcecategory}
            onChange={this.handleCategoryChange.bind(this)}
          >
            {this.renderSourceCategorys()}
          </select>
        </div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="source">入手先・詳細</label>
          <select
            id="source"
            className="form-control"
            value={this.props.source}
            onChange={this.handleSourceChange.bind(this)}
          >
            {this.renderSourceOptions()}
          </select>
        </div>
      </div>
    )
  }

  private handleCategoryChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ sourcecategory: e.currentTarget.value })
  }

  private handleSourceChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ source: e.currentTarget.value })
  }

  private renderSourceCategorys(): JSX.Element[] {
    const cs = _.map(Conditions.sourceCategorys(), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    return _.concat([<option key="none" value={""}>{"-"}</option>], cs)
  }

  private renderSourceOptions(): JSX.Element[] | JSX.Element {
    const source = this.props.sourcecategory
    if (source) {
      const ss = _.map(Conditions.sourceTypesFor(source), (s) => <option value={s[0]} key={s[0]}>{s[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], ss)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }
}
