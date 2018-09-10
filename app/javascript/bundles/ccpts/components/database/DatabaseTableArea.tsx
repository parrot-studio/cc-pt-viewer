import * as _ from "lodash"
import * as React from "react"
import { Button } from "react-bootstrap"
declare var $ // NOTE: jquery-touchswipeの型定義が存在しない

import MessageStream from "../../lib/MessageStream"
import Arcana from "../../model/Arcana"

import { ResultView, ResultViewProps } from "../concerns/ResultView"
import NameSearchForm from "../concerns/NameSearchForm"
import PagerArea from "../concerns/PagerArea"

interface DatabaseTableAreaProps extends ResultViewProps {
  phoneDevice: boolean
}

export default class DatabaseTableArea extends ResultView<DatabaseTableAreaProps> {

  private arcanaTable: HTMLTableElement | null = null

  public componentDidMount(): void {
    if (this.props.phoneDevice && this.arcanaTable) {
      $(this.arcanaTable).swipe({
        swipeLeft: ((e: Event) => {
          if (this.state.pager.hasPrevPage()) {
            this.changePage(this.state.pager.prevPage())
          }
          e.preventDefault()
        }),
        swipeRight: ((e: Event) => {
          if (this.state.pager.hasNextPage()) {
            this.changePage(this.state.pager.nextPage())
          }
          e.preventDefault()
        })
      })
    }

    this.fadeTable()
  }

  public componentDidUpdate(): void {
    this.fadeTable()
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
    )
  }

  private fadeTable(): void {
    if (this.arcanaTable) {
      const table = $(this.arcanaTable)
      table.hide()
      table.fadeIn("fast")
    }
  }

  private handleSort(col: string, e: Event) {
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

  private openArcanaViewModal(a: Arcana, e: Event) {
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
    const mainCols = [
      ["名前", "name"],
      ["職", ""],
      ["★", ""]
    ]

    const exCols = [
      ["コスト", "cost"],
      ["武器", ""],
      ["最大ATK", "maxAtk"],
      ["最大HP", "maxHp"],
      ["限界ATK", "limitAtk"],
      ["限界HP", "limitHp"],
      ["所属", ""]
    ]

    let cols: string[][] = []
    if (this.props.phoneDevice) {
      cols = mainCols
    } else {
      cols = mainCols.concat(exCols)
    }

    const cs = _.map(cols, (col) => {
      if (col[1]) {
        return (
          <th
            className="sortable"
            key={col[1]}
            onClick={this.handleSort.bind(this, col[1])}
          >
            {col[0]}
            <Button
              bsStyle="default"
              bsSize="xsmall"
              onClick={this.handleSort.bind(this, col[1])}
            >
              {this.renderSortIcon(col[1])}
            </Button>
          </th>
        )
      } else {
        return (
          <th key={col[0]}>{col[0]}</th>
        )
      }
    })
    return (<tr>{cs}</tr>)
  }

  private renderArcanas(): JSX.Element[] {
    const phone = this.props.phoneDevice
    return _.map(this.state.pager.get(), (a) => {
      let cost: JSX.Element | null = null
      if (phone) {
        cost = (
          <span
            className="badge badge-sm pull-right"
            key={`${a.jobCode}.header.cost`}
          >
            {`${a.cost}  ( ${a.chainCost} )`}
          </span>
        )
      }

      const body: JSX.Element[] = []
      body.push(
        <td className="arcana-header" key={`${a.jobCode}.header`}>
          <div className={a.jobClass}>
            {cost}
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
      if (!phone) {
        body.push(<td key={`${a.jobCode}.cost`}>{`${a.cost} ( ${a.chainCost} )`}</td>)
        body.push(<td key={`${a.jobCode}.weaponName`}>{a.weaponName}</td>)
        body.push(<td key={`${a.jobCode}.maxAtk`}>{a.maxAtkForView()}</td>)
        body.push(<td key={`${a.jobCode}.maxHp`}>{a.maxHpForView()}</td>)
        body.push(<td key={`${a.jobCode}.limitAtk`}>{a.limitAtkForView()}</td>)
        body.push(<td key={`${a.jobCode}.limitHp`}>{a.limitHpForView()}</td>)
        body.push(<td key={`${a.jobCode}.union`}>{a.union}</td>)
      }
      return (<tr key={a.jobCode}>{body}</tr>)
    })
  }
}