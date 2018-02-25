import _ from "lodash"

import React from "react"
import { DropdownButton, MenuItem } from "react-bootstrap"

import Searcher from "../../lib/Searcher"
import Favorites from "../../model/Favorites"
import QueryLogs from "../../model/QueryLogs"
import MessageStream from "../../model/MessageStream"

export default class SearchMenuButton extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      querys: QueryLogs.querys
    }

    MessageStream.queryLogsStream.onValue((querys) => {
      this.setState({querys})
    })
  }

  search(q) {
    MessageStream.queryStream.push(q)
  }

  searchRecently() {
    this.search({})
  }

  searchFavorite() {
    Searcher.searchCodes(Favorites.list()).onValue((result) => {
      result.detail = "お気に入り"
      MessageStream.resultStream.push(result)
    })
  }

  renderQueryLogs() {
    const limit = (this.props.phoneDevice ? 20 : 30)

    const querys = this.state.querys
    return _.map(_.zip(querys, _.range(querys.length)), (m) => {
      const q = m[0]
      let text = q.detail || ""
      if (text.length > limit) {
        text = `${text.slice(0, limit-3)}...`
      }
      return (
        <MenuItem key={m[1]} onClick={this.search.bind(this, q.params())}>
          {text}
        </MenuItem>
      )
    })
  }

  render () {
    return (
      <DropdownButton bsStyle="default" title="履歴" id="search-menu">
        <MenuItem onClick={this.searchRecently.bind(this)}>
          <i className="fa fa-refresh"/> 最新のアルカナ
        </MenuItem>
        <MenuItem onClick={this.searchFavorite.bind(this)}>
          <i className="fa fa-star"/> お気に入り
        </MenuItem>
        <MenuItem divider />
        <MenuItem header>検索履歴</MenuItem>
        {this.renderQueryLogs()}
      </DropdownButton>
    )
  }
}
