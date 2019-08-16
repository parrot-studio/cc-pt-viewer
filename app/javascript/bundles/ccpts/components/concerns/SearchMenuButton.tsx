import * as _ from "lodash"
import * as React from "react"
import { DropdownButton, MenuItem } from "react-bootstrap"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faRedo, faStar } from "@fortawesome/free-solid-svg-icons"

import Searcher from "../../lib/Searcher"
import Favorites from "../../model/Favorites"
import Query, { QueryParam } from "../../model/Query"
import QueryLogs from "../../model/QueryLogs"
import MessageStream from "../../lib/MessageStream"

interface SearchMenuButtonState {
  querys: Query[]
}

export default class SearchMenuButton extends React.Component<{}, SearchMenuButtonState> {

  constructor(props) {
    super(props)
    this.state = {
      querys: QueryLogs.querys
    }

    MessageStream.queryLogsStream.onValue((querys) => {
      this.setState({ querys })
    })
  }

  public render(): JSX.Element {
    return (
      <DropdownButton bsStyle="default" title="履歴" id="search-menu">
        <MenuItem onClick={this.searchRecently.bind(this)}>
          <FontAwesomeIcon icon={faRedo} /> 最新のアルカナ
        </MenuItem>
        <MenuItem onClick={this.searchFavorite.bind(this)}>
          <FontAwesomeIcon icon={faStar} /> お気に入り
        </MenuItem>
        <MenuItem divider={true} />
        <MenuItem header={true}>検索履歴</MenuItem>
        {this.renderQueryLogs()}
      </DropdownButton>
    )
  }

  private search(q: QueryParam): void {
    MessageStream.queryStream.push(q)
  }

  private searchRecently(): void {
    this.search({})
  }

  private searchFavorite(): void {
    Searcher.searchCodes(Favorites.list()).onValue((result) => {
      result.detail = "お気に入り"
      MessageStream.resultStream.push(result)
    })
  }

  private renderQueryLogs(): JSX.Element[] {
    const limit = 25
    const querys = this.state.querys

    return _.chain(_.zip(querys, _.range(querys.length))
      .map((m) => {
        const q = m[0]
        if (!q) {
          return
        }
        let text = q.detail || ""
        if (text.length > limit) {
          text = `${text.slice(0, limit - 3)}...`
        }
        return (
          <MenuItem key={m[1]} onClick={this.search.bind(this, q.params())}>
            {text}
          </MenuItem>
        )
      })).compact().value()
  }
}
