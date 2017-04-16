import _ from 'lodash'
import Bacon from 'baconjs'

import React from 'react'
import { Button, ButtonToolbar } from 'react-bootstrap'

import MessageStream from '../../model/MessageStream'

import SkillConditions from '../conditions/SkillConditions'
import AbilityConditions from '../conditions/AbilityConditions'
import ChainAbilityConditions from '../conditions/ChainAbilityConditions'
import SourceConditions from '../conditions/SourceConditions'
import NameConditions from '../conditions/NameConditions'

import ClearMenuButton from './ClearMenuButton'

export default class ConditionView extends React.Component {

  constructor(props) {
    super(props)
    this.state = {}

    // from children
    this.notifier = new Bacon.Bus()
    this.notifier.onValue((s) => {
      this.setState(s)
    })

    // subscribe query
    MessageStream.conditionStream.onValue((query = {}) => {
      const qs = {}
      qs.job = (query.job || "")
      qs.rarity = (query.rarity || "")
      qs.weapon = (query.weapon || "")
      qs.union = (query.union || "")
      qs.arcanacost = (query.arcanacost || "")
      qs.chaincost = (query.chaincost || "")
      qs.sourcecategory = (query.sourcecategory || "")
      qs.source = (query.source || "")
      qs.actor = (query.actor || "")
      qs.illustrator = (query.illustrator || "")
      qs.skill = (query.skill || "")
      qs.skillcost = (query.skillcost || "")
      qs.skillsub = (query.skillsub || "")
      qs.skilleffect = (query.skilleffect || "")
      qs.abilitycategory = (query.abilitycategory || "")
      qs.abilityeffect = (query.abilityeffect || "")
      qs.abilitycondition = (query.abilitycondition || "")
      qs.chainabilitycategory = (query.chainabilitycategory || "")
      qs.chainabilityeffect = (query.chainabilityeffect || "")
      qs.chainabilitycondition = (query.chainabilitycondition || "")

      const addTargets = [
        "actor", "illustrator", "skill", "skillcost", "skillsub", "skilleffect",
        "abilitycategory", "abilityeffect", "abilitycondition",
        "chainabilitycategory", "chainabilityeffect", "chainabilitycondition"
      ]
      qs.addCondition = _.chain(addTargets)
        .map((t) => (query[t] ? true : false))
        .some()
        .value()

      this.setState(qs)
    })
  }

  handleJob(e) {
    this.setState({job: e.target.value})
  }

  handleRarity(e) {
    this.setState({rarity: e.target.value})
  }

  handleWeapon(e) {
    this.setState({weapon: e.target.value})
  }

  handleUnion(e) {
    this.setState({union: e.target.value})
  }

  handleArcanaCost(e) {
    this.setState({arcanacost: e.target.value})
  }

  handleChainCost(e) {
    this.setState({chaincost: e.target.value})
  }

  handleAddCondition() {
    this.setState({addCondition: true})
  }

  handleReset() {
    MessageStream.conditionStream.push({})
  }

  hundleSearch() {
    const query = {}
    _.forEach(this.state, (val, key) => {
      if (key === "addCondition") {
        return
      }
      if (val) {
        query[key] = val
      }
    })
    MessageStream.queryStream.push(query)
  }

  renderConditionList(list) {
    const cs = _.map(list, (c) => <option value={c[0]} key={c[0]}>{c[1]}</option>)
    return _.concat([<option value={""} key={""}>{"-"}</option>], cs)
  }

  renderJobList() {
    const jobs = [
      ["F", "戦"],
      ["K", "騎"],
      ["P", "僧"],
      ["A", "弓"],
      ["M", "魔"]
    ]
    return this.renderConditionList(jobs)
  }

  renderRarityList() {
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

  renderWeaponList() {
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

  renderUnionList() {
    return this.renderConditionList(this.props.conditions.unions())
  }

  renderArcanaCostList() {
    const costs = _.map(_.range(4, 25).reverse(), (c) => ([`${c}D`, `${c}以下`]))
    return this.renderConditionList(_.concat([["40", "40"]], costs, [["0", "0"]]))
  }

  renderChainCostList() {
    const costs = []
    _.forEach(_.range(1, 6).reverse(), (c) => {
      costs.push([c, c])
      costs.push([`${c}D`, `${c}以下`])
    })
    return this.renderConditionList(_.concat([["8", "8"]], costs, [["0", "0"]]))
  }

  renderAddArea() {
    if (this.state.addCondition) {
      return (
        <div>
          <SkillConditions conditions={this.props.conditions}
            skill={this.state.skill}
            skillcost={this.state.skillcost}
            skillsub={this.state.skillsub}
            skilleffect={this.state.skilleffect}
            notifier={this.notifier}/>
          <AbilityConditions conditions={this.props.conditions}
            abilitycategory={this.state.abilitycategory}
            abilityeffect={this.state.abilityeffect}
            abilitycondition={this.state.abilitycondition}
            notifier={this.notifier}/>
          <ChainAbilityConditions conditions={this.props.conditions}
            chainabilitycategory={this.state.chainabilitycategory}
            chainabilityeffect={this.state.chainabilityeffect}
            chainabilitycondition={this.state.chainabilitycondition}
            notifier={this.notifier}/>
          <NameConditions conditions={this.props.conditions}
            actor={this.state.actor}
            illustrator={this.state.illustrator}
            notifier={this.notifier}/>
        </div>
      )
    } else {
      return (
        <Button
          bsStyle="link"
          onClick={this.handleAddCondition.bind(this)}>
          もっと細かい条件を指定する
        </Button>
      )
    }
  }

  render() {
    if (!this.props.conditions) {
      return null
    }

    return (
      <div className="row">
        <div className="col-sm-12 col-md-12 ">
          <div>
            <Button
              bsStyle="danger"
              className="pull-right"
              onClick={this.props.switchMainMode}>
              <i className="fa fa-remove"/> 閉じる
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
                    onClick={this.hundleSearch.bind(this)}>
                    <i className="fa fa-search"/> 検索
                  </Button>
                  <Button
                    bsStyle="default"
                    className="pull-right"
                    onClick={this.handleReset.bind(this)}>
                    <i className="fa fa-refresh"/> 条件をクリア
                  </Button>
                </ButtonToolbar>
                <span className="help-block small">条件をクリアして検索すると、最近登録されたアルカナが検索されます。</span>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-4 col-md-4">
                <label htmlFor="job" className="control-label">職業</label>
                <select id="job" className="form-control"
                  value={this.state.job} onChange={this.handleJob.bind(this)}>
                  {this.renderJobList()}
                </select>
              </div>
              <div className="col-sm-4 col-md-4">
                <label htmlFor="rarity" className="control-label">レア度</label>
                <select id="rarity" className="form-control col-sm-6 col-md-6"
                  value={this.state.rarity} onChange={this.handleRarity.bind(this)}>
                  {this.renderRarityList()}
                </select>
              </div>
              <div className="col-sm-4 col-md-4">
                <label htmlFor="weapon">武器タイプ</label>
                <select id="weapon" className="form-control"
                  value={this.state.weapon} onChange={this.handleWeapon.bind(this)}>
                  {this.renderWeaponList()}
                </select>
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-4 col-md-4">
                <label htmlFor="union">所属</label>
                <select id="union" className="form-control"
                  value={this.state.union} onChange={this.handleUnion.bind(this)}>
                  {this.renderUnionList()}
                </select>
              </div>
              <div className="col-sm-4 col-md-4">
                <label htmlFor="arcana-cost">コスト</label>
                <select id="arcana-cost" className="form-control"
                  value={this.state.arcanacost} onChange={this.handleArcanaCost.bind(this)}>
                  {this.renderArcanaCostList()}
                </select>
              </div>
              <div className="col-sm-4 col-md-4">
                <label htmlFor="chain-cost">絆コスト</label>
                <select id="chain-cost" className="form-control"
                  value={this.state.chaincost} onChange={this.handleChainCost.bind(this)}>
                  {this.renderChainCostList()}
                </select>
              </div>
            </div>
            <SourceConditions
              conditions={this.props.conditions}
              sourcecategory={this.state.sourcecategory}
              source={this.state.source}
              notifier={this.notifier}/>
            {this.renderAddArea()}
          </form>

          <div>
            <ButtonToolbar>
              <ClearMenuButton/>
              <Button
                bsStyle="danger"
                className="pull-right"
                onClick={this.props.switchMainMode}>
                <i className="fa fa-remove"/> 閉じる
              </Button>
            </ButtonToolbar>
          </div>
        </div>
      </div>
    );
  }
}
