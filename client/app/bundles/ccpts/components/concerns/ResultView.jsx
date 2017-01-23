import React from 'react'

import Pager from '../../lib/Pager'

export default class ResultView extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      pager: (Pager.create([], this.props.pagerSize)),
      sortOrder: {},
      searchDetail: "",
    }

    this.props.resultStream.onValue((result) => {
      if (result.reload) {
        const pager = Pager.create(this.state.pager.all, this.props.pagerSize)
        this.setState({pager})
      } else {
        const pager = Pager.create(result.arcanas, this.props.pagerSize)
        this.setState({
          pager,
          sortOrder: {},
          searchDetail: result.detail
        })
      }
    })
    this.sortOrderDefault = {name: 'asc'}
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
