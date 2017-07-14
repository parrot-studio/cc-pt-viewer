import React from "react"
import { Nav, NavItem } from "react-bootstrap"

import { Cookie } from "../../lib/Cookie"

import EditTutorialArea from "./EditTutorialArea"
import LatestInfoArea from "./LatestInfoArea"

export default class NavHeader extends React.Component {

  modeName(mode) {
    mode = (mode || this.props.mode)
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

  renderNav() {
    if (this.props.imageMode) {
      return null
    }

    // TODO: どこかに移す
    const phoneDevice = (window.innerWidth < 768 ? true : false)
    if (phoneDevice) {
      return null
    }

    const rootPath = this.props.appPath
    const dbPath = `${this.props.appPath}db`
    return (
      <Nav bsStyle="tabs" justified activeKey={this.props.mode}>
        <NavItem eventKey="ptedit" href={rootPath}>{this.modeName("ptedit")}</NavItem>
        <NavItem eventKey="database" href={dbPath}>{this.modeName("database")}</NavItem>
      </Nav>
    )
  }

  renderHeader() {
    return (
      <div className="header">
        <h1>
          Get our light!
          <span className="hidden-sm hidden-md hidden-lg"><br/></span>
          &nbsp;
          <small className="text-muted lead">チェンクロ パーティーシミュレーター</small>
        </h1>
        <p className="pull-right">
          <small className="text-muted">【{this.modeName()}】</small>
        </p>
      </div>
    )
  }

  renderLatestInfo() {
    return <LatestInfoArea latestInfo={this.props.latestInfo}/>
  }

  renderHeadInfo() {
    if (this.props.imageMode) {
      return null
    }

    if (this.props.mode !== "ptedit") {
      return this.renderLatestInfo()
    }

    const tutorial = Cookie.valueFor("tutorial")
    if (!tutorial) {
      Cookie.set({tutorial: true})
      return <EditTutorialArea/>
    } else {
      return this.renderLatestInfo()
    }
  }

  render(){
    return (
      <div>
        {this.renderNav()}
        {this.renderHeader()}
        {this.renderHeadInfo()}
      </div>
    )
  }
}
