import _ from "lodash"

import React from "react"
import { Alert } from "react-bootstrap"

import Query from "../model/Query"
import QueryLogs from "../model/QueryLogs"
import Favorites from "../model/Favorites"
import Conditions from "../model/Conditions"
import MessageStream from "../model/MessageStream"
import Searcher from "../lib/Searcher"

import EditModeView from "./edit/EditModeView"
import DatabaseModeView from "./database/DatabaseModeView"
import NavHeader from "./concerns/NavHeader"
import ConditionView from "./concerns/ConditionView"
import ArcanaView from "./concerns/ArcanaView"
import DisplaySizeWarning from "./concerns/DisplaySizeWarning"

export default class AppView extends React.Component {

  constructor(props) {
    super(props)

    Searcher.init(this.props.dataver, this.props.appPath)
    Conditions.init(this.props.conditions)
    QueryLogs.init()
    Favorites.init()

    const mode = this.props.mode
    this.phoneDevice = (window.innerWidth < 768 ? true : false)

    let pagerSize = 8
    let recentlySize = 32
    switch (mode) {
      case "ptedit":
        pagerSize = 8
        recentlySize = 32
        break
      case "database":
        if (this.phoneDevice) {
          pagerSize = 8
          recentlySize = 16
        } else {
          pagerSize = 16
          recentlySize = 32
        }
        break
    }

    MessageStream.conditionStream.plug(MessageStream.queryStream)
    const recentlyQuery = Query.create({ recently: recentlySize })
    const searchStream = MessageStream.queryStream
      .doAction(() => this.switchMainMode())
      .map((q) => Query.create(q))
      .map((q) => (q.isEmpty() ? recentlyQuery : q))
      .flatMap((query) => Searcher.searchArcanas(query))
    MessageStream.resultStream.plug(searchStream)

    this.state = {
      pagerSize,
      showConditionArea: false
    }
  }

  componentDidMount() {
    $(this.errorArea).hide()
    $(this.conditionArea).hide()
    $("#pre-header").hide()
  }

  switchMainMode() {
    $("#search-modal").modal("hide")
    if (this.state.showConditionArea) {
      this.setState({
        showConditionArea: false
      }, () => {
        MessageStream.resultStream.push({ reload: true })
        this.fadeModeArea()
      })
    }
  }

  switchConditionMode() {
    if (!this.state.showConditionArea) {
      this.setState({
        showConditionArea: true
      }, () => {
        this.fadeModeArea()
      })
    }
  }

  fadeModeArea() {
    if (this.state.showConditionArea) {
      $(this.mainArea).hide()
      $(this.conditionArea).fadeIn("slow")
    } else {
      $(this.conditionArea).hide()
      $(this.mainArea).fadeIn("slow")
    }
  }

  renderWarning() {
    if (this.props.imageMode) {
      return null
    }

    if (!_.eq(this.props.mode, "ptedit") || !this.phoneDevice) {
      return null
    }

    return <DisplaySizeWarning appPath={this.props.appPath} />
  }

  renderModeView() {
    switch (this.props.mode) {
      case "ptedit":
        return <EditModeView
          phoneDevice={this.phoneDevice}
          appPath={this.props.appPath}
          aboutPath={this.props.aboutPath}
          initParty={this.props.party}
          ptver={this.props.ptver}
          arcana={this.props.arcana}
          switchConditionMode={this.switchConditionMode.bind(this)}
          pagerSize={this.state.pagerSize}
          originTitle={this.props.originTitle}
          imageMode={this.props.imageMode} />
      case "database":
        return <DatabaseModeView
          phoneDevice={this.phoneDevice}
          appPath={this.props.appPath}
          switchConditionMode={this.switchConditionMode.bind(this)}
          pagerSize={this.state.pagerSize}
          imageMode={this.props.imageMode} />
    }
  }

  renderConditionView() {
    if (_.eq(this.props.mode, "ptedit") && this.phoneDevice) {
      return null
    }

    return <ConditionView
      conditions={Conditions}
      originTitle={this.props.originTitle}
      switchMainMode={this.switchMainMode.bind(this)} />
  }

  renderErrorArea() {
    return (
      <div id="error-area" ref={(d) => { this.errorArea = d }}>
        <div className="row">
          <div className="col-xs-12 col-md-12 col-sm-12">
            <Alert bsStyle="danger">
              <p>
                <strong>データの取得に失敗しました。</strong>
                <a href={window.location.href} className="alert-link">リロードする</a>か、もう一度検索してください。
              </p>
            </Alert>
          </div>
        </div>
      </div>
    )
  }

  render() {
    return (
      <div>
        <NavHeader
          appPath={this.props.appPath}
          mode={this.props.mode}
          latestInfo={this.props.latestInfo} />
        {this.renderErrorArea()}
        {this.renderWarning()}
        <div id="main-area" ref={(d) => { this.mainArea = d }}>
          {this.renderModeView()}
        </div>
        <div id="condition-area" ref={(d) => { this.conditionArea = d }}>
          {this.renderConditionView()}
        </div>
        <ArcanaView originTitle={this.props.originTitle} />
      </div>
    )
  }
}
