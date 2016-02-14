class PagerArea extends React.Component {

  handlePager(e, selectedEvent) {
    this.props.changePage(selectedEvent.eventKey)
  }

  render() {
    let pager = this.props.pager
    let cn = "pagination"
    if (this.props.phoneDevice) {
      cn += " pagination-sm"
    }

    return (
      <nav className="text-center">
        <Pagination
          prev
          next
          first
          last
          ellipsis
          bsClass={cn}
          items={pager.maxPage}
          maxButtons={(this.props.phoneDevice ? 5 : 7)}
          activePage={pager.page}
          onSelect={this.handlePager.bind(this)} />
      </nav>
    )
  }
}