import * as _ from "lodash"
import * as React from "react"

import Pager from "../../lib/Pager"
import MessageStream from "../../lib/MessageStream"
import Arcana from "../../model/Arcana"
import QueryResult from "../../model/QueryResult"

export interface ResultViewProps {
  pagerSize: number
  firstResults: any
}

interface ResultViewState {
  pager: Pager<Arcana>
  sortOrder: { [key: string]: string }
  searchDetail: string
}

export abstract class ResultView<P extends ResultViewProps> extends React.Component<P, ResultViewState> {

  protected static readonly DEFAULT_SORT_ORDER: { [key: string]: string } = { name: "asc" }

  constructor(props: P) {
    super(props)

    const firstResult = this.parseFirstResults()
    this.state = {
      pager: Pager.create(firstResult.arcanas, this.props.pagerSize),
      sortOrder: {},
      searchDetail: firstResult.detail
    }

    MessageStream.resultStream.onValue((r) => {
      if (r) {
        const p = Pager.create(r.arcanas, this.props.pagerSize)
        this.setState({
          pager: p,
          sortOrder: {},
          searchDetail: r.detail
        })
      } else {
        const p = Pager.create(this.state.pager.all, this.props.pagerSize)
        this.setState({ pager: p })
      }
    })
  }

  protected changePage(page: string | number): void {
    const pager = this.state.pager
    pager.jumpPage(page)
    this.setState({ pager })
  }

  protected renderPageCount(): string {
    const pager = this.state.pager
    if (pager.size > 0) {
      return `（${pager.head()} - ${pager.tail()} / ${pager.size}件）`
    } else {
      return "（0件）"
    }
  }

  private parseFirstResults(): QueryResult {
    const data = this.props.firstResults
    try {
      const as = _.chain(_.map(data.result, (d) => Arcana.build(d))).compact().value()
      const detail = data.detail || ""
      return QueryResult.create(as, detail)
    } catch (e) {
      return QueryResult.create([], "")
    }
  }
}
