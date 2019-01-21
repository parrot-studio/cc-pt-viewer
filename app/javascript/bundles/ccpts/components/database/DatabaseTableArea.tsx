import * as _ from "lodash"
import * as React from "react"
import { Button } from "react-bootstrap"

import MessageStream from "../../lib/MessageStream"
import Browser from "../../lib/BrowserProxy"
import Arcana from "../../model/Arcana"

import { ResultView, ResultViewProps } from "../concerns/ResultView"
import NameSearchForm from "../concerns/NameSearchForm"
import PagerArea from "../concerns/PagerArea"

export default class DatabaseTableArea extends ResultView<ResultViewProps> {

  private arcanaTable: HTMLTableElement | null = null

  public componentDidMount(): void {
    Browser.addSwipeHandler(
      this.arcanaTable,
      this.handleLeftSwipe.bind(this),
      this.handleRightSwipe.bind(this)
    )
  }

  public componentWillUpdate(): void {
    if (this.arcanaTable) {
      Browser.hide(this.arcanaTable)
    }
  }

  public componentDidUpdate(): void {
    if (this.arcanaTable) {
      Browser.fadeIn(this.arcanaTable)
    }
  }

  public render(): JSX.Element {
    return (
      <div className="row">
        <div className="col-sm-12 col-md-12">
          <PagerArea
            pager={this.state.pager}
            changePage={this.changePage.bind(this)}
          />
          <div className="well well-sm small text-muted">
            {this.state.searchDetail}
            <span className="pager-count">{this.renderPageCount()}</span>
          </div>
          <div className="table-responsive">
            <table
              id="arcana-table"
              className="table table-bordered table-condensed"
              ref={(d) => { this.arcanaTable = d }}
            >
              <thead>{this.renderTableHeader()}</thead>
              <tbody>{this.renderArcanas()}</tbody>
            </table>
          </div>
          <NameSearchForm />
          <div className="hidden-xs">
            <div className="well well-sm small text-muted">
              {this.state.searchDetail}
              <span className="pager-count">{this.renderPageCount()}</span>
            </div>
            <PagerArea
              pager={this.state.pager}
              changePage={this.changePage.bind(this)}
            />
          </div>
        </div>
      </div >
    )
  }

  private handleLeftSwipe(): void {
    if (this.state.pager.hasPrevPage()) {
      this.changePage(this.state.pager.prevPage())
    }
  }

  private handleRightSwipe(): void {
    if (this.state.pager.hasNextPage()) {
      this.changePage(this.state.pager.nextPage())
    }
  }

  private handleSort(col: string, e) {
    e.stopPropagation()

    const orgOrder = this.state.sortOrder[col]
    let order = ""
    if (orgOrder) {
      order = (orgOrder === "desc" ? "asc" : "desc")
    } else {
      order = (DatabaseTableArea.DEFAULT_SORT_ORDER[col] || "desc")
    }

    const pager = this.state.pager
    pager.sort(col, order)
    pager.jumpPage(1)

    this.setState({
      pager,
      sortOrder: { [col]: order },
    })
  }

  private openArcanaViewModal(a: Arcana, e) {
    e.preventDefault()
    MessageStream.arcanaViewStream.push(a)
  }

  private renderSortIcon(col: string): JSX.Element {
    const order = this.state.sortOrder[col]
    switch (order) {
      case "asc":
        return (<i className="fa fa-sort-amount-up active" />)
      case "desc":
        return (<i className="fa fa-sort-amount-down active" />)
      default:
        return (<i className="fa fa-sort" />)
    }
  }

  private renderTableHeader(): JSX.Element {
    const cols = [
      ["名前", "name", ""],
      ["職", "", ""],
      ["★", "", ""],
      ["コスト", "cost", ""],
      ["武器", "", "hidden-xs"],
      ["最大ATK", "maxAtk", "hidden-xs"],
      ["最大HP", "maxHp", "hidden-xs"],
      ["限界ATK", "limitAtk", "hidden-xs"],
      ["限界HP", "limitHp", "hidden-xs"],
      ["所属", "", ""]
    ]

    const cs = _.map(cols, (col) => {
      if (!_.isEmpty(col[1])) {
        return (
          <th
            className={`sortable ${col[2]}`}
            key={col[1]}
            onClick={this.handleSort.bind(this, col[1])}
          >
            {col[0]}
            <Button
              bsStyle="default"
              bsSize="xsmall"
              className="hidden-xs"
              onClick={this.handleSort.bind(this, col[1])}
            >
              {this.renderSortIcon(col[1])}
            </Button>
          </th>
        )
      } else {
        return (
          <th key={col[0]} className={`${col[2]}`}>{col[0]}</th>
        )
      }
    })
    return (<tr>{cs}</tr>)
  }

  private renderArcanas(): JSX.Element[] {
    return _.map(this.state.pager.get(), (a) => {
      const body: JSX.Element[] = []

      body.push(
        <td className="arcana-header" key={`${a.jobCode}.header`}>
          <div className={a.jobClass}>
            <span className="text-muted small" key={`${a.jobCode}.title`}>{a.title}</span><br />
            <a
              href="#"
              key={`${a.jobCode}.header.view`}
              onClick={this.openArcanaViewModal.bind(this, a)}
            >
              {a.name}
            </a>
          </div>
        </td>
      )
      body.push(<td key={`${a.jobCode}.jobNameShort`}>{a.jobNameShort}</td>)
      body.push(<td key={`${a.jobCode}.rarity`}>{a.rarity}</td>)
      body.push(<td key={`${a.jobCode}.cost`}>{`${a.cost} (${a.chainCost} )`}</td>)
      body.push(<td key={`${a.jobCode}.weaponName`} className="hidden-xs">{a.weaponName}</td>)
      body.push(<td key={`${a.jobCode}.maxAtk`} className="hidden-xs">{a.maxAtkForView()}</td>)
      body.push(<td key={`${a.jobCode}.maxHp`} className="hidden-xs">{a.maxHpForView()}</td>)
      body.push(<td key={`${a.jobCode}.limitAtk`} className="hidden-xs">{a.limitAtkForView()}</td>)
      body.push(<td key={`${a.jobCode}.limitHp`} className="hidden-xs">{a.limitHpForView()}</td>)
      body.push(<td key={`${a.jobCode}.union`}>{a.union}</td>)
      return (<tr key={a.jobCode}>{body}</tr>)
    })
  }
}
