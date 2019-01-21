import * as _ from "lodash"
import * as React from "react"
import { Nav, NavItem } from "react-bootstrap"

interface NavHeaderProps {
  mode: string
  appPath: string
}

export default class NavHeader extends React.Component<NavHeaderProps> {

  public render(): JSX.Element {
    return (
      <div>
        {this.renderNav()}
        {this.renderHeader()}
      </div>
    )
  }

  private modeName(mode: string): string {
    let name = ""
    switch (mode) {
      case "ptedit":
        name = "パーティー編集モード"
        break
      case "database":
        name = "データベースモード"
        break
    }
    return name
  }

  private renderNav(): JSX.Element | null {
    const rootPath = this.props.appPath
    const dbPath = `${this.props.appPath}db`
    return (
      <Nav bsStyle="tabs" className="hidden-xs" justified={true} activeKey={this.props.mode}>
        <NavItem eventKey="ptedit" href={rootPath}>{this.modeName("ptedit")}</NavItem>
        <NavItem eventKey="database" href={dbPath}>{this.modeName("database")}</NavItem>
      </Nav>
    )
  }

  private renderHeader(): JSX.Element {
    return (
      <div className="header">
        <h1>
          Get our light!
          <span className="hidden-sm hidden-md hidden-lg"><br /></span>
          &nbsp;
          <small className="text-muted lead">チェンクロ パーティーシミュレーター</small>
        </h1>
        <p className="pull-right">
          <small className="text-muted">【{this.modeName(this.props.mode)}】</small>
        </p>
      </div>
    )
  }
}
