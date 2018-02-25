import React from "react"
import UltimatePagination from "./Pagination"

export default class PagerArea extends React.Component {

  handlePager(eventKey) {
    this.props.changePage(eventKey)
  }

  render() {
    const pager = this.props.pager

    return (
      <nav className="text-center">
        <UltimatePagination
          currentPage={pager.page}
          totalPages={pager.maxPage}
          siblingPagesRange={2}
          onChange={this.handlePager.bind(this)} />
      </nav>
    )
  }
}
