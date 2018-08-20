import * as _ from "lodash"
import * as React from "react"

import Conditions, { ConditionsNotifier } from "../../model/Conditions"

interface ChainAbilityConditionsProps extends ConditionsNotifier {
  chainabilitycategory: string
  chainabilitycondition: string
  chainabilityeffect: string
  chainabilitytarget: string
}

export default class ChainAbilityConditions extends React.Component<ChainAbilityConditionsProps> {

  public render(): JSX.Element {
    return (
      <div className="form-group">
        <div className="col-sm-4 col-md-4">
          <label htmlFor="chain-ability-category">絆アビリティ・分類</label>
          <select
            id="chain-ability-category"
            className="form-control"
            value={this.props.chainabilitycategory}
            onChange={this.handleCategoryChange.bind(this)}
          >
            {this.renderCategoryList()}
          </select>
        </div>
        {this.renderAddArea()}
      </div>
    )
  }

  private handleCategoryChange(e: React.FormEvent<HTMLSelectElement>): void {
    const val = e.currentTarget.value
    if (!_.isEqual(this.props.chainabilitycategory, val)) {
      this.props.notifier.push({
        chainabilitycategory: val,
        chainabilitycondition: "",
        chainabilityeffect: "",
        chainabilitytarget: ""
      })
    }
  }

  private handleConditionChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ chainabilitycondition: e.currentTarget.value })
  }

  private handleEffectChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ chainabilityeffect: e.currentTarget.value })
  }

  private handleTargetChange(e: React.FormEvent<HTMLSelectElement>): void {
    this.props.notifier.push({ chainabilitytarget: e.currentTarget.value })
  }

  private renderCategoryList() {
    const cs = _.map(Conditions.chainAbirityCategorys(), (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    return _.concat([<option value={""} key={""}>{"-"}</option>], cs)
  }

  private renderConditionList(): JSX.Element[] | JSX.Element {
    const category = this.props.chainabilitycategory
    if (category) {
      const cs = _.map(Conditions.chainAbirityConditionsFor(category),
        (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  private renderEffectList(): JSX.Element[] | JSX.Element {
    const category = this.props.chainabilitycategory
    if (category) {
      const cs = _.map(Conditions.chainAbirityEffectsFor(category),
        (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  private renderTargetList(): JSX.Element | null {
    const category = this.props.chainabilitycategory
    if (_.isEmpty(category)) {
      return null
    }

    const targets = Conditions.chainAbilityTargetsFor(category)
    if (_.isEmpty(targets) || targets.length <= 1) {
      return null
    }

    const cs = _.map(targets, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    const ts = _.concat([<option value={""} key={""}>{"（全て）"}</option>], cs)

    return (
      <div className="col-sm-4 col-md-4">
        <label htmlFor="chain-ability-target">対象</label>
        <select
          id="chain-ability-target"
          className="form-control"
          value={this.props.chainabilitytarget}
          onChange={this.handleTargetChange.bind(this)}
        >
          {ts}
        </select>
      </div>
    )
  }

  private renderAddArea(): JSX.Element | null {
    if (!this.props.chainabilitycategory) {
      return null
    }

    return (
      <div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="chain-ability-condition">条件</label>
          <select
            id="chain-ability-condition"
            className="form-control"
            value={this.props.chainabilitycondition}
            onChange={this.handleConditionChange.bind(this)}
          >
            {this.renderConditionList()}
          </select>
        </div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="chain-ability-effect">効果</label>
          <select
            id="chain-ability-effect"
            className="form-control"
            value={this.props.chainabilityeffect}
            onChange={this.handleEffectChange.bind(this)}
          >
            {this.renderEffectList()}
          </select>
        </div>
        {this.renderTargetList()}
      </div>
    )
  }
}
