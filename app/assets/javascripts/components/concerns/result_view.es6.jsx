class ResultView extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      pager: (Pager.create([], this.props.pagerSize)),
      sortOrder: {},
      searchDetail: "",
    }

    this.props.resultStream.onValue(result => {
      let pager = Pager.create(result.arcanas, this.props.pagerSize)
      this.setState({
        pager: pager,
        sortOrder: {},
        searchDetail: result.detail
      })
    })
    this.sortOrderDefault = {name: 'asc'}
  }

  changePage(page) {
    let pager = this.state.pager
    pager.jumpPage(page)
    this.setState({pager: pager})
  }

  renderPageCount() {
    let pager = this.state.pager
    if (pager.size > 0){
      return `（${pager.head() + 1} - ${pager.tail() + 1} / ${pager.size}件）`
    } else {
      return "（0件）"
    }
  }
}
