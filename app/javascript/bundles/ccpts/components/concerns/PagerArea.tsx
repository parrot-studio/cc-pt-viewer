import * as React from "react"

import Pager from "../../lib/Pager"
import Arcana from "../../model/Arcana"
import UltimatePagination from "./Pagination"

interface PagerAreaProps {
  pager: Pager<Arcana>
  changePage(page: string | number): void
}

export default class PagerArea extends React.Component<PagerAreaProps> {

  // eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
  public render() {
    const pager = this.props.pager

    return (
      <nav className="text-center">
        <UltimatePagination
          currentPage={pager.page}
          totalPages={pager.maxPage}
          siblingPagesRange={2}
          onChange={this.handlePager.bind(this)}
        />
      </nav>
    )
  }

  private handlePager(page: string | number) {
    this.props.changePage(page)
  }
}
