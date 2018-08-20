import * as _ from "lodash"
import * as React from "react"

import Conditions, { ConditionsNotifier } from "../../model/Conditions"

interface AbilityConditionsProps extends ConditionsNotifier {
  abilitycategory: string
  abilitycondition: string
  abilitysubcondition: string
  abilityeffect: string
  abilitysubeffect: string
  abilitytarget: string
  abilitysubtarget: string
}

export default class AbilityConditions extends React.Component<AbilityConditionsProps> {

  public render(): JSX.Element {
    return (
      <div>
        <div className="form-group">
          <div className="col-sm-4 col-md-4">
            <label htmlFor="ability-category">アビリティ・分類</label>
            <select
              id="ability-category"
              className="form-control"
              value={this.props.abilitycategory}
              onChange={this.handleCategoryChange.bind(this)}
            >
              {this.renderCategoryList()}
            </select>
          </div>
          {this.renderConditionArea()}
        </div>
        <div className="form-group">
          <div className="col-sm-4 col-md-4" />
          {this.renderEffectArea()}
        </div>
        {this.renderTargetArea()}
      </div>
    )
  }

  private handleCategoryChange(e: React.FormEvent<HTMLSelectElement>): void {
    const val = e.currentTarget.value
    if (!_.isEqual(this.props.abilitycategory, val)) {
      this.props.notifier.push({
        abilitycategory: val,
        abilitycondition: "",
        abilitysubcondition: "",
        abilityeffect: "",
        abilitysubeffect: "",
        abilitytarget: "",
        abilitysubtarget: ""
      })
    }
  }

  private handleConditionChange(e: React.FormEvent<HTMLSelectElement>): void {
    const val = e.currentTarget.value
    if (!_.isEqual(this.props.abilitycondition, val)) {
      this.props.notifier.push({
        abilitycondition: val,
        abilitysubcondition: ""
      })
    }
  }

  private handleSubConditionChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ abilitysubcondition: e.currentTarget.value })
  }

  private handleEffectChange(e: React.FormEvent<HTMLSelectElement>): void {
    const val = e.currentTarget.value
    if (!_.isEqual(this.props.abilityeffect, val)) {
      this.props.notifier.push({
        abilityeffect: val,
        abilitysubeffect: ""
      })
    }
  }

  private handleSubEffectChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ abilitysubeffect: e.currentTarget.value })
  }

  private handleTargetChange(e: React.FormEvent<HTMLSelectElement>): void {
    const val = e.currentTarget.value
    if (!_.isEqual(this.props.abilitytarget, val)) {
      this.props.notifier.push({
        abilitytarget: val,
        abilitysubtarget: ""
      })
    }
  }

  private handleSubTargetChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ abilitysubtarget: e.currentTarget.value })
  }

  private renderCategoryList(): JSX.Element[] {
    const cs = _.map(Conditions.abilityCategorys(), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    return _.concat([<option value={""} key={""}>{"-"}</option>], cs)
  }

  private renderConditionList(): JSX.Element[] | JSX.Element {
    const category = this.props.abilitycategory
    if (category) {
      const cs = _.map(Conditions.abilityConditionsFor(category),
        (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  private renderSubConditionList(): JSX.Element[] | JSX.Element {
    const category = this.props.abilitycategory
    const cond = this.props.abilitycondition
    if (category && cond) {
      const cs = _.map(Conditions.abilitySubConditionsFor(category, cond),
        (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  private renderEffectList(): JSX.Element[] | JSX.Element {
    const category = this.props.abilitycategory
    if (category) {
      const cs = _.map(Conditions.abilityEffectsFor(category), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  private renderSubEffectList(): JSX.Element[] | null {
    const category = this.props.abilitycategory
    const effect = this.props.abilityeffect
    let sefs: Array<[string, string]> = []
    if (category && effect) {
      sefs = Conditions.abilitySubEffectsFor(category, effect)
    }
    if (!_.isEmpty(sefs)) {
      const cs = _.map(sefs, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return null
    }
  }

  private renderTargetList(): JSX.Element | null {
    const category = this.props.abilitycategory
    if (_.isEmpty(category)) {
      return null
    }

    const targets = Conditions.abilityTargetsFor(category)
    if (_.isEmpty(targets) || targets.length <= 1) {
      return null
    }

    const cs = _.map(targets, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    const ts = _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)

    return (
      <div className="col-sm-4 col-md-4">
        <label htmlFor="ability-target">対象</label>
        <select
          id="ability-target"
          className="form-control"
          value={this.props.abilitytarget}
          onChange={this.handleTargetChange.bind(this)}
        >
          {ts}
        </select>
      </div>
    )
  }

  private renderConditionArea(): JSX.Element | null {
    if (_.isEmpty(this.props.abilitycategory)) {
      return null
    }

    return (
      <div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="ability-condition">条件</label>
          <select
            id="ability-condition"
            className="form-control"
            value={this.props.abilitycondition}
            onChange={this.handleConditionChange.bind(this)}
          >
            {this.renderConditionList()}
          </select>
        </div>
        <div className="col-sm-4 col-md-4">
          {this.renderConditionAddArea()}
        </div>
      </div>
    )
  }

  private renderConditionAddArea(): JSX.Element | null {
    const category = this.props.abilitycategory
    const cond = this.props.abilitycondition
    let scfs: Array<[string, string]> = []
    if (category && cond) {
      scfs = Conditions.abilitySubConditionsFor(category, cond)
    }
    if (_.isEmpty(scfs)) {
      return null
    }

    const cs = _.map(scfs, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    const es = _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)

    return (
      <div>
        <label htmlFor="ability-subcondition">条件（追加）</label>
        <select
          id="ability-subcondition"
          className="form-control"
          value={this.props.abilitysubcondition}
          onChange={this.handleSubConditionChange.bind(this)}
        >
          {es}
        </select>
      </div>
    )
  }

  private renderEffectArea(): JSX.Element | null {
    if (_.isEmpty(this.props.abilitycategory)) {
      return null
    }

    return (
      <div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="ability-effect">効果</label>
          <select
            id="ability-effect"
            className="form-control"
            value={this.props.abilityeffect}
            onChange={this.handleEffectChange.bind(this)}
          >
            {this.renderEffectList()}
          </select>
        </div>
        <div className="col-sm-4 col-md-4">
          {this.renderEffectAddArea()}
        </div>
      </div>
    )
  }

  private renderEffectAddArea(): JSX.Element | null {
    const category = this.props.abilitycategory
    const effect = this.props.abilityeffect
    let sefs: Array<[string, string]> = []
    if (category && effect) {
      sefs = Conditions.abilitySubEffectsFor(category, effect)
    }
    if (_.isEmpty(sefs)) {
      return null
    }

    const cs = _.map(sefs, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    const es = _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)

    return (
      <div>
        <label htmlFor="ability-subeffect">効果（追加）</label>
        <select
          id="ability-subeffect"
          className="form-control"
          value={this.props.abilitysubeffect}
          onChange={this.handleSubEffectChange.bind(this)}
        >
          {es}
        </select>
      </div>
    )
  }

  private renderTargetArea(): JSX.Element | null {
    const category = this.props.abilitycategory
    if (_.isEmpty(category)) {
      return null
    }

    const targets = Conditions.abilityTargetsFor(category)
    if (_.isEmpty(targets) || targets.length <= 1) {
      return null
    }

    const cs = _.map(targets, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    const ts = _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)

    return (
      <div>
        <div className="form-group">
          <div className="col-sm-4 col-md-4" />
          <div className="col-sm-4 col-md-4">
            <label htmlFor="ability-target">対象</label>
            <select
              id="ability-target"
              className="form-control"
              value={this.props.abilitytarget}
              onChange={this.handleTargetChange.bind(this)}
            >
              {ts}
            </select>
          </div>
          <div className="col-sm-4 col-md-4">
            {this.renderTargetAddArea()}
          </div>
        </div>
      </div>
    )
  }

  private renderTargetAddArea(): JSX.Element | null {
    const category = this.props.abilitycategory
    const target = this.props.abilitytarget
    let stfs: Array<[string, string]> = []
    if (category && target) {
      stfs = Conditions.abilitySubTargetsFor(category, target)
    }
    if (_.isEmpty(stfs)) {
      return null
    }

    const cs = _.map(stfs, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    const es = _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)

    return (
      <div>
        <label htmlFor="ability-subtarget">対象（追加）</label>
        <select
          id="ability-subtarget"
          className="form-control"
          value={this.props.abilitysubtarget}
          onChange={this.handleSubTargetChange.bind(this)}
        >
          {es}
        </select>
      </div>
    )
  }
}
