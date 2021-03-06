import * as _ from "lodash"

import * as React from "react"
import { Button, ButtonGroup } from "react-bootstrap"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faSearch } from "@fortawesome/free-solid-svg-icons"

import { ResultView, ResultViewProps } from "../concerns/ResultView"
import PagerArea from "../concerns/PagerArea"
import SearchMenuButton from "../concerns/SearchMenuButton"

import TargetArcana from "./TargetArcana"

interface TargetsEditAreaProps extends ResultViewProps {
  switchConditionMode(): void
}

export default class TargetsEditArea extends ResultView<TargetsEditAreaProps> {

  public render(): JSX.Element {
    return (
      <div id="edit-area">
        <div className="row">
          <div className="col-sm-12 col-md-12">
            <div id="help-area" className="hide">
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
                    onClick={this.props.switchConditionMode}
                  >
                    <FontAwesomeIcon icon={faSearch} /> 検索
                  </Button>
                  <SearchMenuButton />
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
            <p className="clearfix" />
            <PagerArea
              pager={this.state.pager}
              changePage={this.changePage.bind(this)}
            />
            {this.renderSortArea()}
          </div>
        </div>
      </div>
    )
  }

  private handleSort(col: string, e): void {
    e.stopPropagation()

    const order = (TargetsEditArea.DEFAULT_SORT_ORDER[col] || "desc")
    const pager = this.state.pager
    pager.sort(col, order)
    pager.jumpPage(1)

    this.setState({
      pager,
      sortOrder: { [col]: order }
    })
  }

  private renderArcanas(): JSX.Element {
    const as = _.map(this.state.pager.get(), (a) => <TargetArcana key={a.jobCode} arcana={a} />)
    return <ul id="choice-characters" className="list-inline">{as}</ul>
  }

  private renderSortArea(): JSX.Element {
    const sortCols = [
      ["コスト", "cost"],
      ["ATK", "maxAtk"],
      ["HP", "maxHp"],
      ["名前", "name"]
    ]

    const cs = _.chain(_.zip(sortCols, _.range(sortCols.length))
      .map((l) => {
        const cl = l[0]
        const num = l[1]
        if (!cl) {
          return
        }
        const name = cl[0]
        const col = cl[1]
        if (!name || !col) {
          return
        }

        if (!_.isEmpty(this.state.sortOrder[col])) {
          return (
            <ButtonGroup key={num}>
              <Button
                bsStyle="info"
                className="active"
                onClick={this.handleSort.bind(this, col)}
              >
                {name}
              </Button>
            </ButtonGroup>
          )
        } else {
          return (
            <ButtonGroup key={num}>
              <Button
                key={num}
                bsStyle="default"
                onClick={this.handleSort.bind(this, col)}
              >
                {name}
              </Button>
            </ButtonGroup>
          )
        }
      }))
      .compact().value()

    return (
      <form className="form-horizontal">
        <div className="form-group">
          <label className="control-label col-sm-3 col-md-3" htmlFor="sort">ソート</label>
          <div className="col-sm-6 col-md-6">
            <ButtonGroup justified={true}>
              {cs}
            </ButtonGroup>
          </div>
        </div>
      </form>
    )
  }
}
