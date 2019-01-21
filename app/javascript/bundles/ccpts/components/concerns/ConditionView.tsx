import * as _ from "lodash"
import * as Bacon from "baconjs"
import * as React from "react"
import { Button, ButtonToolbar } from "react-bootstrap"

import Conditions from "../../model/Conditions"
import Query, { QueryParam } from "../../model/Query"
import MessageStream from "../../lib/MessageStream"
import Browser from "../../lib/BrowserProxy"

import SkillConditions from "../conditions/SkillConditions"
import AbilityConditions from "../conditions/AbilityConditions"
import ChainAbilityConditions from "../conditions/ChainAbilityConditions"
import SourceConditions from "../conditions/SourceConditions"
import NameConditions from "../conditions/NameConditions"

import ClearMenuButton from "./ClearMenuButton"

interface ConditionViewProps {
  originTitle: string
  query: Query | null
  switchMainMode(): void
}

interface ConditionViewState {
  job?: string
  rarity?: string
  weapon?: string
  union?: string
  arcanacost?: string
  chaincost?: string
  sourcecategory?: string
  source?: string
  arcanatype?: string
  actor?: string
  illustrator?: string
  skill?: string
  skillcost?: string
  skillsub?: string
  skilleffect?: string
  skillinheritable?: string
  abilitycategory?: string
  abilityeffect?: string
  abilitysubeffect?: string
  abilitycondition?: string
  abilitysubcondition?: string
  abilitytarget?: string
  abilitysubtarget?: string
  chainabilitycategory?: string
  chainabilityeffect?: string
  chainabilitycondition?: string
  chainabilitytarget?: string
}

export default class ConditionView extends React.Component<ConditionViewProps, ConditionViewState> {

  private notifier: Bacon.Bus<Bacon.EventStream<{}, QueryParam>, QueryParam>

  constructor(props) {
    super(props)
    let q = {}
    if (this.props.query) {
      q = this.props.query.params()
    }
    this.state = this.buildStateParam(q)

    // from children
    this.notifier = new Bacon.Bus()
    this.notifier.onValue((s) => {
      this.setState(s, () => {
        MessageStream.conditionStream.push(this.state)
      })
    })
  }

  public render(): JSX.Element {
    return (
      <div className="row">
        <div className="col-sm-12 col-md-12 ">
          <div>
            <Button
              bsStyle="danger"
              className="pull-right"
              onClick={this.props.switchMainMode}
            >
              <i className="fa fa-remove" /> 閉じる
            </Button>
            <h2>アルカナ検索</h2>
          </div>

          <form className="form-horizontal well well-lg" role="form">
            <div className="form-group">
              <div className="col-sm-12 col-md-12">
                <ButtonToolbar>
                  <Button
                    bsStyle="primary"
                    data-loading-text="検索中..."
                    onClick={this.hundleSearch.bind(this)}
                  >
                    <i className="fa fa-search" /> 検索
                  </Button>
                  <Button
                    bsStyle="default"
                    className="pull-right"
                    onClick={this.handleReset.bind(this)}
                  >
                    <i className="fa fa-refresh" /> 条件をクリア
                  </Button>
                </ButtonToolbar>
                <span className="help-block small">条件をクリアして検索すると、最近登録されたアルカナが検索されます。</span>
              </div>
            </div>
            <hr className="condition" />
            <div className="form-group">
              <div className="col-sm-4 col-md-4">
                <label htmlFor="job" className="control-label">職業</label>
                <select
                  id="job"
                  className="form-control"
                  value={this.state.job}
                  onChange={this.handleJob.bind(this)}
                >
                  {this.renderJobList()}
                </select>
              </div>
              <div className="col-sm-4 col-md-4">
                <label htmlFor="rarity" className="control-label">レア度</label>
                <select
                  id="rarity"
                  className="form-control col-sm-6 col-md-6"
                  value={this.state.rarity}
                  onChange={this.handleRarity.bind(this)}
                >
                  {this.renderRarityList()}
                </select>
              </div>
              <div className="col-sm-4 col-md-4">
                <label htmlFor="weapon">武器タイプ</label>
                <select
                  id="weapon"
                  className="form-control"
                  value={this.state.weapon}
                  onChange={this.handleWeapon.bind(this)}
                >
                  {this.renderWeaponList()}
                </select>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-4 col-md-4">
                <label htmlFor="union">所属</label>
                <select
                  id="union"
                  className="form-control"
                  value={this.state.union}
                  onChange={this.handleUnion.bind(this)}
                >
                  {this.renderUnionList()}
                </select>
              </div>
              <div className="col-sm-4 col-md-4">
                <label htmlFor="arcana-cost">コスト</label>
                <select
                  id="arcana-cost"
                  className="form-control"
                  value={this.state.arcanacost}
                  onChange={this.handleArcanaCost.bind(this)}
                >
                  {this.renderArcanaCostList()}
                </select>
              </div>
              <div className="col-sm-4 col-md-4">
                <label htmlFor="chain-cost">絆コスト</label>
                <select
                  id="chain-cost"
                  className="form-control"
                  value={this.state.chaincost}
                  onChange={this.handleChainCost.bind(this)}
                >
                  {this.renderChainCostList()}
                </select>
              </div>
            </div>
            <div className="form-group">
              <SourceConditions
                sourcecategory={this.state.sourcecategory || ""}
                source={this.state.source || ""}
                notifier={this.notifier}
              />
              <div className="col-sm-4 col-md-4">
                <label htmlFor="arcana-type">タイプ（世代/バディ等）</label>
                <select
                  id="arcana-type"
                  className="form-control"
                  value={this.state.arcanatype}
                  onChange={this.handleArcanaType.bind(this)}
                >
                  {this.renderArcanaTypeList()}
                </select>
              </div>
            </div>
            <hr className="condition" />
            <SkillConditions
              skill={this.state.skill || ""}
              skillcost={this.state.skillcost || ""}
              skillsub={this.state.skillsub || ""}
              skilleffect={this.state.skilleffect || ""}
              skillinheritable={this.state.skillinheritable || ""}
              notifier={this.notifier}
            />
            <hr className="condition" />
            <AbilityConditions
              abilitycategory={this.state.abilitycategory || ""}
              abilityeffect={this.state.abilityeffect || ""}
              abilitysubeffect={this.state.abilitysubeffect || ""}
              abilitycondition={this.state.abilitycondition || ""}
              abilitysubcondition={this.state.abilitysubcondition || ""}
              abilitytarget={this.state.abilitytarget || ""}
              abilitysubtarget={this.state.abilitysubtarget || ""}
              notifier={this.notifier}
            />
            <hr className="condition" />
            <ChainAbilityConditions
              chainabilitycategory={this.state.chainabilitycategory || ""}
              chainabilityeffect={this.state.chainabilityeffect || ""}
              chainabilitycondition={this.state.chainabilitycondition || ""}
              chainabilitytarget={this.state.chainabilitytarget || ""}
              notifier={this.notifier}
            />
            <hr className="condition" />
            <NameConditions
              actor={this.state.actor || ""}
              illustrator={this.state.illustrator || ""}
              notifier={this.notifier}
            />
            <hr className="condition" />
            <div className="form-group">
              <div className="col-sm-12 col-md-12">
                <ButtonToolbar>
                  <Button
                    bsStyle="primary"
                    data-loading-text="検索中..."
                    onClick={this.hundleSearch.bind(this)}
                  >
                    <i className="fa fa-search" /> 検索
                  </Button>
                  <Button
                    bsStyle="default"
                    className="pull-right"
                    onClick={this.handleReset.bind(this)}
                  >
                    <i className="fa fa-refresh" /> 条件をクリア
                  </Button>
                </ButtonToolbar>
              </div>
            </div>
          </form>

          <div>
            <ButtonToolbar>
              <ClearMenuButton />
              <Button
                bsStyle="danger"
                className="pull-right"
                onClick={this.props.switchMainMode}
              >
                <i className="fa fa-remove" /> 閉じる
              </Button>
            </ButtonToolbar>
          </div>
        </div>
      </div>
    )
  }

  private handleJob(e: React.FormEvent<HTMLSelectElement>): void {
    this.notifier.push({ job: e.currentTarget.value })
  }

  private handleRarity(e: React.FormEvent<HTMLSelectElement>): void {
    this.notifier.push({ rarity: e.currentTarget.value })
  }

  private handleWeapon(e: React.FormEvent<HTMLSelectElement>): void {
    this.notifier.push({ weapon: e.currentTarget.value })
  }

  private handleUnion(e: React.FormEvent<HTMLSelectElement>): void {
    this.notifier.push({ union: e.currentTarget.value })
  }

  private handleArcanaCost(e: React.FormEvent<HTMLSelectElement>): void {
    this.notifier.push({ arcanacost: e.currentTarget.value })
  }

  private handleChainCost(e: React.FormEvent<HTMLSelectElement>): void {
    this.notifier.push({ chaincost: e.currentTarget.value })
  }

  private handleArcanaType(e: React.FormEvent<HTMLSelectElement>): void {
    this.notifier.push({ arcanatype: e.currentTarget.value })
  }

  private handleReset(): void {
    const q = this.buildStateParam({})
    this.notifier.push(q)
  }

  private hundleSearch(): void {
    const query: QueryParam = {}
    _.forEach(this.state, (val, key) => {
      if (!_.isEmpty(val)) {
        query[key] = val
      }
    })
    MessageStream.queryStream.push(query)
    Browser.changeTitle(this.props.originTitle)
  }

  private renderConditionList(list: Array<[string, string]> | string[][]): JSX.Element[] {
    const cs = _.map(list, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    return _.concat([<option value={""} key={""}>{"-"}</option>], cs)
  }

  private renderJobList(): JSX.Element[] {
    const jobs = [
      ["F", "戦"],
      ["K", "騎"],
      ["P", "僧"],
      ["A", "弓"],
      ["M", "魔"]
    ]
    return this.renderConditionList(jobs)
  }

  private renderRarityList(): JSX.Element[] {
    const rarities = [
      ["5", "☆☆☆☆☆"],
      ["4U", "☆☆☆☆+"],
      ["4", "☆☆☆☆"],
      ["3U", "☆☆☆+"],
      ["3", "☆☆☆"],
      ["2U", "☆☆+"],
      ["2", "☆☆"],
      ["1U", "☆+"],
      ["1", "☆"]
    ]
    return this.renderConditionList(rarities)
  }

  private renderWeaponList(): JSX.Element[] {
    const weapons = [
      ["Sl", "斬"],
      ["Bl", "打"],
      ["Pi", "突"],
      ["Pu", "拳"],
      ["Ar", "弓"],
      ["Gu", "銃"],
      ["Sh", "狙"],
      ["Ma", "魔"],
      ["He", "聖"]
    ]
    return this.renderConditionList(weapons)
  }

  private renderUnionList(): JSX.Element[] {
    return this.renderConditionList(Conditions.unions())
  }

  private renderArcanaCostList(): JSX.Element[] {
    const costs = _.map(_.range(4, 25).reverse(), (c) => ([`${c}D`, `${c}以下`]))
    return this.renderConditionList(_.concat([["40", "40"]], costs, [["0", "0"]]))
  }

  private renderChainCostList(): JSX.Element[] {
    const costs: string[][] = []
    _.forEach(_.range(1, 6).reverse(), (c) => {
      costs.push([String(c), String(c)])
      costs.push([`${c}D`, `${c}以下`])
    })
    return this.renderConditionList(_.concat([["8", "8"]], costs, [["0", "0"]]))
  }

  private renderArcanaTypeList(): JSX.Element[] {
    const atypes = [
      ["first", "旧世代（1部・2部）"],
      ["third", "新世代（3部）"],
      ["demon", "魔神"],
      ["buddy", "バディ"],
      ["collaboration", "コラボ"]
    ]
    return this.renderConditionList(atypes)
  }

  private buildStateParam(query: QueryParam): QueryParam {
    const qs: QueryParam = {}
    qs.job = (query.job || "")
    qs.rarity = (query.rarity || "")
    qs.weapon = (query.weapon || "")
    qs.union = (query.union || "")
    qs.arcanacost = (query.arcanacost || "")
    qs.chaincost = (query.chaincost || "")
    qs.sourcecategory = (query.sourcecategory || "")
    qs.source = (query.source || "")
    qs.arcanatype = (query.arcanatype || "")
    qs.actor = (query.actor || "")
    qs.illustrator = (query.illustrator || "")
    qs.skill = (query.skill || "")
    qs.skillcost = (query.skillcost || "")
    qs.skillsub = (query.skillsub || "")
    qs.skilleffect = (query.skilleffect || "")
    qs.skillinheritable = (query.skillinheritable || "")
    qs.abilitycategory = (query.abilitycategory || "")
    qs.abilityeffect = (query.abilityeffect || "")
    qs.abilitysubeffect = (query.abilitysubeffect || "")
    qs.abilitycondition = (query.abilitycondition || "")
    qs.abilitysubcondition = (query.abilitysubcondition || "")
    qs.abilitytarget = (query.abilitytarget || "")
    qs.abilitysubtarget = (query.abilitysubtarget || "")
    qs.chainabilitycategory = (query.chainabilitycategory || "")
    qs.chainabilityeffect = (query.chainabilityeffect || "")
    qs.chainabilitycondition = (query.chainabilitycondition || "")
    qs.chainabilitytarget = (query.chainabilitytarget || "")
    return qs
  }
}
