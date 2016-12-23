import _ from 'lodash'

import React from 'react'
import ReactBootstrap, { Button, ButtonGroup } from 'react-bootstrap'

import Favorites from '../../model/Favorites'

import ResultView from '../concerns/ResultView'
import PagerArea from '../concerns/PagerArea'
import NameSearchForm from '../concerns/NameSearchForm'
import SearchMenuButton from '../concerns/SearchMenuButton'

import TargetArcana from './TargetArcana'

export default class TargetsEditArea extends ResultView {

  constructor(props) {
    super(props)

    Favorites.notifyStream.onValue((favs) => {
      _.forEach(this.state.pager.get(), (a) => {
        let code = a.jobCode
        $(`#fav-${code}`).bootstrapSwitch("state", Favorites.stateFor(code))
      })
    })
  }

  componentDidMount() {
    $(this.refs.helpArea).hide()
  }

  handleSort(col, e) {
    e.stopPropagation()

    let order = (this.sortOrderDefault[col] || 'desc')
    let pager = this.state.pager
    pager.sort(col, order)
    pager.jumpPage(1)

    this.setState({
      pager: pager,
      sortOrder: {[col]: order}
    })
  }

  renderArcanas() {
    let as = _.map(this.state.pager.get(), (a) => {
      return <TargetArcana
        key={a.jobCode}
        arcana={a}
        arcanaViewStream={this.props.arcanaViewStream}/>
    })
    return <ul id="choice-characters" className="list-inline">{as}</ul>
  }

  renderSortArea() {
    let sortCols = [
      ["コスト", "cost"],
      ["ATK", "maxAtk"],
      ["HP", "maxHp"],
      ["名前", "name"]
    ]

    let cs = _.map(_.zip(sortCols, _.range(sortCols.length)), (l) => {
      let cl = l[0]
      let name = cl[0]
      let col = cl[1]

      if (this.state.sortOrder[col]){
        return (
          <ButtonGroup key={l[1]}>
            <Button
              bsStyle="info"
              className="active"
              onClick={this.handleSort.bind(this, col)}>
              {name}
            </Button>
          </ButtonGroup>
        )
      } else {
        return (
          <ButtonGroup key={l[1]}>
            <Button
              key={l[1]}
              bsStyle="default"
              onClick={this.handleSort.bind(this, col)}>
              {name}
            </Button>
          </ButtonGroup>
        )
      }
    })

    return (
      <form className="form-horizontal">
        <div className="form-group">
          <label className="control-label col-sm-3 col-md-3" htmlFor="sort">ソート</label>
          <div className="col-sm-6 col-md-6">
            <ButtonGroup justified>
              {cs}
            </ButtonGroup>
          </div>
        </div>
      </form>
    )
  }

  render() {
    return (
      <div id="edit-area">
        <div className="row">
          <div className="col-sm-12 col-md-12">
            <div id="help-area" ref="helpArea">
              <div className="alert alert-warning small" role="alert">
                <ul className="list-unstyled">
                  <li>空いたところにドロップ -&gt; パーティーメンバーとしてセット</li>
                  <li>すでに登録されたところにドロップ -&gt; 「置き換え」か「絆」か選択</li>
                </ul>
              </div>
            </div>
            <div id="search-area">
              <div className="bg-info small text-muted">
                <ButtonGroup>
                  <Button
                    bsStyle="primary"
                    onClick={this.props.switchConditionMode}>
                    <i className="fa fa-search"/> 検索
                  </Button>
                  <SearchMenuButton
                    phoneDevice={this.props.phoneDevice}
                    queryStream={this.props.queryStream}
                    resultStream={this.props.resultStream}/>
                </ButtonGroup>
                &nbsp;表示中：{this.state.searchDetail}
                <span className="pager-count">{this.renderPageCount()}</span>
              </div>
              <div>
                <span className="help-block small">アルカナをドラッグ -&gt; 上のパーティーエリアでドロップ</span>
              </div>
            </div>

            <div>
              {this.renderArcanas()}
            </div>
            <p className="clearfix"></p>
            <PagerArea
              pager={this.state.pager}
              phoneDevice={this.props.phoneDevice}
              changePage={this.changePage.bind(this)}/>
            {this.renderSortArea()}
            <NameSearchForm
              conditionStream={this.props.conditionStream}
              queryStream={this.props.queryStream}/>
          </div>
        </div>
      </div>
    )
  }
}
