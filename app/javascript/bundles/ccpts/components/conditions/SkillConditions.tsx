import * as _ from "lodash"
import * as React from "react"

import Conditions, { ConditionsNotifier } from "../../model/Conditions"
import Browser from "../../lib/BrowserProxy"

interface SkillConditionsProps extends ConditionsNotifier {
  skill: string
  skillcost: string
  skillsub: string
  skilleffect: string
  skillinheritable: string
}

export default class SkillConditions extends React.Component<SkillConditionsProps> {

  public render(): JSX.Element {
    return (
      <div className="form-group">
        <div className="col-sm-3 col-md-3">
          <label htmlFor="skill">スキル・効果</label>
          <select
            id="skill"
            className="form-control"
            value={this.props.skill}
            onChange={this.handleCategoryChange.bind(this)}
          >
            {this.renderCategoryList()}
          </select>
        </div>
        <div className="col-sm-2 col-md-2">
          <label htmlFor="skill-inheritable">伝授のみ</label>
          <input
            type="checkbox"
            ref={(inp) => { this.addInheritableHandler(inp) }}
          />
        </div>
        {this.renderAddArea()}
      </div>
    )
  }

  private addInheritableHandler(inp: HTMLInputElement | null): void {
    if (!inp) {
      return
    }

    Browser.addSwitchHandler(
      inp,
      !_.isEmpty(this.props.skillinheritable),
      this.handleInheritableSwitch.bind(this),
      {}
    )
  }

  private handleCategoryChange(e: React.FormEvent<HTMLSelectElement>): void {
    const val = e.currentTarget.value
    if (!_.isEqual(this.props.skill, val)) {
      this.props.notifier.push({
        skill: val,
        skillcost: "",
        skillsub: "",
        skilleffect: ""
      })
    }
  }

  private handleCostChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ skillcost: e.currentTarget.value })
  }

  private handleSubChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ skillsub: e.currentTarget.value })
  }

  private handleEffectChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ skilleffect: e.currentTarget.value })
  }

  private renderConditionList(list: Array<[string, string]>): JSX.Element[] {
    const cs = _.map(list, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    return _.concat([<option value={""} key={""}>{"-"}</option>], cs)
  }

  private renderCategoryList(): JSX.Element[] {
    return this.renderConditionList(Conditions.skillCategorys())
  }

  private handleInheritableSwitch(state: boolean): void {
    let val = ""
    if (state) {
      val = "1"
    }
    this.props.notifier.push({ skillinheritable: val })
  }

  private renderCostList(): JSX.Element[] {
    const list: Array<[string, string]> = [
      ["3", "3"],
      ["3D", "3以下"],
      ["2", "2"],
      ["2D", "2以下"],
      ["1", "1"],
      ["0", "0（バディ）"]
    ]
    return this.renderConditionList(list)
  }

  private renderSubList(): JSX.Element[] | JSX.Element {
    const category = this.props.skill
    if (category) {
      const cs = _.map(Conditions.skillSubtypesFor(category), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  private renderEffectList(): JSX.Element[] | JSX.Element {
    const category = this.props.skill
    if (category) {
      const cs = _.map(Conditions.skillEffectTypesFor(category), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  private renderAddArea(): JSX.Element {
    if (this.props.skill) {
      return (
        <div>
          <div className="col-sm-2 col-md-2">
            <label htmlFor="skill-cost">マナ</label>
            <select
              id="skill-cost"
              className="form-control"
              value={this.props.skillcost}
              onChange={this.handleCostChange.bind(this)}
            >
              {this.renderCostList()}
            </select>
          </div>
          <div className="col-sm-4 col-md-4">
            <label htmlFor="skill-sub">対象範囲</label>
            <select
              id="skill-sub"
              className="form-control"
              value={this.props.skillsub}
              onChange={this.handleSubChange.bind(this)}
            >
              {this.renderSubList()}
            </select>
          </div>
          <div className="col-sm-4 col-md-4">
            <label htmlFor="skill-effect">追加効果</label>
            <select
              id="skill-effect"
              className="form-control"
              value={this.props.skilleffect}
              onChange={this.handleEffectChange.bind(this)}
            >
              {this.renderEffectList()}
            </select>
          </div>
        </div>
      )
    } else {
      return <div />
    }
  }
}
