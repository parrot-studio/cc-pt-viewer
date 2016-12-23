import _ from 'lodash'

import React from 'react'
import ReactBootstrap, { Modal, Button, ButtonToolbar, DropdownButton, MenuItem } from 'react-bootstrap'

import Searcher from '../../lib/Searcher'
import Favorites from '../../model/Favorites'
import QueryLogs from '../../model/QueryLogs'

export default class SearchMenuButton extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      querys: QueryLogs.querys
    }

    QueryLogs.notifyStream.onValue(querys => {
      this.setState({querys: querys})
    })
  }

  search(q) {
    this.props.queryStream.push(q)
  }

  searchRecently() {
    this.search({})
  }

  searchFavorite() {
    Searcher.searchCodes(Favorites.list()).onValue((result) => {
      result.detail = 'お気に入り'
      this.props.resultStream.push(result)
    })
  }

  renderQueryLogs() {
    let limit = (this.props.phoneDevice ? 20 : 30)

    let querys = this.state.querys
    return _.map(_.zip(querys, _.range(querys.length)), (m) => {
      let q = m[0]
      let text = q.detail || ""
      if (text.length > limit) {
        text = text.slice(0, limit-3) + '...'
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
