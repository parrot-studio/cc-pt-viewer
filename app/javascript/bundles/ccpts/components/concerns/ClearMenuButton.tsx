import * as React from "react"
import { DropdownButton, MenuItem } from "react-bootstrap"
declare var window

import Favorites from "../../model/Favorites"
import QueryLogs from "../../model/QueryLogs"

export default class ClearMenuButton extends React.Component {

  public render(): JSX.Element {
    return (
      <DropdownButton bsStyle="default" title="履歴消去" id="clear-menu">
        <MenuItem onClick={this.clearFavs.bind(this)}>
          お気に入りの消去
        </MenuItem>
        <MenuItem onClick={this.clearLogs.bind(this)}>
          検索履歴の消去
        </MenuItem>
        <MenuItem onClick={this.clearAll.bind(this)}>
          全履歴の消去
        </MenuItem>
      </DropdownButton>
    )
  }

  private clearFavs(): void {
    if (window.confirm("お気に入りを消去します。よろしいですか？")) {
      Favorites.clear()
      window.alert("お気に入りを消去しました。")
    }
  }

  private clearLogs(): void {
    if (window.confirm("検索履歴を消去します。よろしいですか？")) {
      QueryLogs.clear()
      window.alert("検索履歴を消去しました。")
    }
  }

  private clearAll(): void {
    if (window.confirm("全ての履歴（お気に入り/検索）を消去します。よろしいですか？")) {
      Favorites.clear()
      QueryLogs.clear()
      window.alert("全ての履歴を消去しました。")
    }
  }
}
