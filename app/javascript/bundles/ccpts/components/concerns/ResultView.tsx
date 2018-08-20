import * as React from "react"

import Pager from "../../lib/Pager"
import MessageStream from "../../model/MessageStream"
import Arcana from "../../model/Arcana"

export interface ResultViewProps {
  pagerSize: number
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

    this.state = {
      pager: Pager.create([], this.props.pagerSize),
      sortOrder: {},
      searchDetail: ""
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
}
