import React from 'react'

import Pager from '../../lib/Pager'
import MessageStream from '../../model/MessageStream'

export default class ResultView extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      pager: (Pager.create([], this.props.pagerSize)),
      sortOrder: {},
      searchDetail: "",
    }

    this.sortOrderDefault = {name: 'asc'}

    MessageStream.resultStream
      .filter((r) => r.reload)
      .onValue(() => {
        const pager = Pager.create(this.state.pager.all, this.props.pagerSize)
        this.setState({pager})
      })

    MessageStream.resultStream
      .filter((r) => !r.reload)
      .onValue((r) => {
        const pager = Pager.create(r.arcanas, this.props.pagerSize)
        this.setState({
          pager,
          sortOrder: {},
          searchDetail: r.detail
        })
      })
  }

  changePage(page) {
    const pager = this.state.pager
    pager.jumpPage(page)
    this.setState({pager})
  }

  renderPageCount() {
    const pager = this.state.pager
    if (pager.size > 0){
      return `（${pager.head()} - ${pager.tail()} / ${pager.size}件）`
    } else {
      return "（0件）"
    }
  }
}
