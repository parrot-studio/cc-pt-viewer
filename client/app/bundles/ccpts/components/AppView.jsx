import Bacon from 'baconjs'

import React from 'react'
import { Nav, NavItem, Alert } from 'react-bootstrap'

import Query from '../model/Query'
import QueryLogs from '../model/QueryLogs'
import Favorites from '../model/Favorites'
import Conditions from '../model/Conditions'
import Searcher from '../lib/Searcher'
import { Cookie } from '../lib/Cookie'

import EditModeView from './edit/EditModeView'
import EditTutorialArea from './edit/EditTutorialArea'
import DisplaySizeWarning from './edit/DisplaySizeWarning'
import DatabaseModeView from './database/DatabaseModeView'
import LatestInfoArea from './concerns/LatestInfoArea'
import ConditionView from './concerns/ConditionView'
import ArcanaView from './concerns/ArcanaView'
import NextVersionWarning from './concerns/NextVersionWarning'

export default class AppView extends React.Component {

  constructor(props) {
    super(props)

    const mode = this.props.mode
    const phoneDevice = this.props.phoneDevice
    const queryStream = new Bacon.Bus()
    const conditionStream = new Bacon.Bus()
    const resultStream = new Bacon.Bus()
    const arcanaViewStream = new Bacon.Bus()
    const historyStream = new Bacon.Bus()

    let pagerSize = 8
    let recentlySize = 32
    switch (mode) {
      case 'ptedit':
        pagerSize = 8
        recentlySize = 32
        break
      case 'database':
        if (phoneDevice) {
          pagerSize = 8
          recentlySize = 16
        } else {
          pagerSize = 16
          recentlySize = 32
        }
        break
    }

    QueryLogs.init()
    Favorites.init()

    const recentlyQuery = Query.create({recently: recentlySize})
    const searchStream = queryStream
      .doAction(() => this.switchMainMode())
      .map((q) => Query.create(q))
      .map((q) => (q.isEmpty() ? recentlyQuery : q))
      .flatMap((query) => Searcher.searchArcanas(query))

    conditionStream.plug(queryStream)
    resultStream.plug(searchStream)

    this.state = {
      pagerSize,
      queryStream,
      conditionStream,
      resultStream,
      arcanaViewStream,
      historyStream,
      showConditionArea: false
    }
  }

  componentDidMount() {
    $(this.refs.errorArea).hide()
    $(this.refs.conditionArea).hide()
    $("#pre-header").hide()
  }

  switchMainMode() {
    $("#search-modal").modal('hide')
    if (this.state.showConditionArea) {
      this.setState({
        showConditionArea: false
      }, () => {
        this.state.resultStream.push({reload: true})
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
      $(this.refs.mainArea).hide()
      $(this.refs.conditionArea).fadeIn("slow")
    } else {
      $(this.refs.conditionArea).hide()
      $(this.refs.mainArea).fadeIn("slow")
    }
  }

  modeName(mode) {
    mode = (mode || this.props.mode)
    let name = ""
    switch (mode) {
      case 'ptedit':
        name = "パーティー編集モード"
        break
      case 'database':
        name = "データベースモード"
        break
    }
    return name
  }

  renderLatestInfo() {
    return <LatestInfoArea ver={this.props.infover}/>
  }

  renderHeadInfo() {
    if (this.props.mode !== 'ptedit') {
      return this.renderLatestInfo()
    }

    const tutorial = Cookie.valueFor('tutorial')
    if (!tutorial) {
      Cookie.set({tutorial: true})
      return <EditTutorialArea/>
    } else {
      return this.renderLatestInfo()
    }
  }

  renderWarning() {
    if (this.props.mode !== 'ptedit' || !this.props.phoneDevice) {
      return null
    }
    return <DisplaySizeWarning appPath={this.props.appPath}/>
  }

  renderNextVersionWarning() {
    return <NextVersionWarning appPath={this.props.appPath}/>
  }

  renderModeView() {
    switch (this.props.mode) {
      case 'ptedit':
        return <EditModeView
          phoneDevice={this.props.phoneDevice}
          appPath={this.props.appPath}
          aboutPath={this.props.aboutPath}
          ptm={this.props.ptm}
          ptver={this.props.ptver}
          code={this.props.code}
          switchConditionMode={this.switchConditionMode.bind(this)}
          pagerSize={this.state.pagerSize}
          conditionStream={this.state.conditionStream}
          queryStream={this.state.queryStream}
          resultStream={this.state.resultStream}
          arcanaViewStream={this.state.arcanaViewStream}
          historyStream={this.state.historyStream}/>
      case 'database':
        return <DatabaseModeView
          code={this.props.code}
          phoneDevice={this.props.phoneDevice}
          appPath={this.props.appPath}
          switchConditionMode={this.switchConditionMode.bind(this)}
          pagerSize={this.state.pagerSize}
          conditionStream={this.state.conditionStream}
          queryStream={this.state.queryStream}
          resultStream={this.state.resultStream}
          arcanaViewStream={this.state.arcanaViewStream}
          historyStream={this.state.historyStream}/>
    }
  }

  renderNav() {
    if (this.props.phoneDevice) {
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

  renderErrorArea() {
    return (
      <div id="error-area" ref="errorArea">
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
        {this.renderNav()}
        {this.renderHeader()}
        {this.renderErrorArea()}
        {this.renderWarning()}
        {this.renderHeadInfo()}
        {this.renderNextVersionWarning()}
        <div id="main-area" ref="mainArea">
          {this.renderModeView()}
        </div>
        <div id="condition-area" ref="conditionArea">
          <ConditionView
            conditions={Conditions}
            switchMainMode={this.switchMainMode.bind(this)}
            conditionStream={this.state.conditionStream}
            queryStream={this.state.queryStream}
            resultStream={this.state.resultStream}/>
        </div>
        <ArcanaView
          originTitle={this.props.originTitle}
          arcanaViewStream={this.state.arcanaViewStream}
          historyStream={this.state.historyStream}/>
      </div>
    )
  }
}
