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

export default class AppView extends React.Component {

  constructor(props) {
    super(props)

    Searcher.init(this.props.dataver, this.props.appPath)
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

    const recentlyQuery = Query.create({recently: recentlySize})
    const searchStream = MessageStream.queryStream
      .doAction(() => this.switchMainMode())
      .map((q) => Query.create(q))
      .map((q) => (q.isEmpty() ? recentlyQuery : q))
      .flatMap((query) => Searcher.searchArcanas(query))
    MessageStream.resultStream.plug(searchStream)

    this.state = {
      pagerSize,
      showConditionArea: false,
      phoneRedirect: false
    }
  }

  componentWillMount() {
    if (_.eq(this.props.mode, "ptedit") && this.phoneDevice && _.isEmpty(this.props.ptm)) {
      location.href=`${this.props.appPath}/db`
      this.setState({phoneRedirect: true})
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
        MessageStream.resultStream.push({reload: true})
        this.fadeModeArea()
      })
    }
  }

  switchConditionMode() {
    if (!this.state.showConditionArea) {
      Conditions.init().onValue(() => {
        this.setState({
          showConditionArea: true
        }, () => {
          this.fadeModeArea()
        })
      })
    }
  }

  fadeModeArea () {
    if (this.state.showConditionArea) {
      $(this.mainArea).hide()
      $(this.conditionArea).fadeIn("slow")
    } else {
      $(this.conditionArea).hide()
      $(this.mainArea).fadeIn("slow")
    }
  }

  renderModeView() {
    switch (this.props.mode) {
      case "ptedit":
        return <EditModeView
          phoneDevice={this.props.phoneDevice}
          appPath={this.props.appPath}
          aboutPath={this.props.aboutPath}
          ptm={this.props.ptm}
          ptver={this.props.ptver}
          code={this.props.code}
          switchConditionMode={this.switchConditionMode.bind(this)}
          pagerSize={this.state.pagerSize}
          imageMode={this.props.imageMode}/>
      case "database":
        return <DatabaseModeView
          code={this.props.code}
          phoneDevice={this.props.phoneDevice}
          appPath={this.props.appPath}
          switchConditionMode={this.switchConditionMode.bind(this)}
          pagerSize={this.state.pagerSize}
          imageMode={this.props.imageMode}/>
    }
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
    if (this.state.phoneRedirect) {
      return
    }

    return (
      <div>
        <NavHeader
          appPath={this.props.appPath}
          mode={this.props.mode}
          latestInfo={this.props.latestInfo}/>
        {this.renderErrorArea()}
        <div id="main-area" ref={(d) => { this.mainArea = d }}>
          {this.renderModeView()}
        </div>
        <div id="condition-area" ref={(d) => { this.conditionArea = d }}>
          <ConditionView
            conditions={Conditions}
            switchMainMode={this.switchMainMode.bind(this)}/>
        </div>
        <ArcanaView originTitle={this.props.originTitle}/>
      </div>
    )
  }
}
