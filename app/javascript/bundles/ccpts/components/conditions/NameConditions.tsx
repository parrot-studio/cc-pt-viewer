import * as _ from "lodash"
import * as React from "react"

import Conditions, { ConditionsNotifier } from "../../model/Conditions"

interface NameConditionsProps extends ConditionsNotifier {
  actor: string
  illustrator: string
}

export default class NameConditions extends React.Component<NameConditionsProps> {

  public render(): JSX.Element {
    return (
      <div className="form-group">
        <div className="col-sm-6 col-md-6">
          <label htmlFor="actor">声優</label>
          <select
            id="actor"
            className="form-control"
            value={this.props.actor}
            onChange={this.handleActorChange.bind(this)}
          >
            {this.renderActors()}
          </select>
        </div>
        <div className="col-sm-6 col-md-6">
          <label htmlFor="illustrator">イラストレーター</label>
          <select
            id="illustrator"
            className="form-control"
            value={this.props.illustrator}
            onChange={this.handleIllustratorChange.bind(this)}
          >
            {this.renderIllustrators()}
          </select>
        </div>
      </div>
    )
  }

  private handleActorChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ actor: e.currentTarget.value })
  }

  private handleIllustratorChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ illustrator: e.currentTarget.value })
  }

  private renderConditionList(list: Array<[number, string]>): JSX.Element[] {
    const cs = _.map(list, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    return _.concat([<option value={""} key={""}>{"-"}</option>], cs)
  }

  private renderActors(): JSX.Element[] {
    return this.renderConditionList(Conditions.voiceactors())
  }

  private renderIllustrators(): JSX.Element[] {
    return this.renderConditionList(Conditions.illustrators())
  }
}
