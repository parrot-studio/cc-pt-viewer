import * as _ from "lodash"
import * as React from "react"
import { Alert } from "react-bootstrap"
declare var $: JQueryStatic

import Query from "../model/Query"
import QueryLogs from "../model/QueryLogs"
import Favorites from "../model/Favorites"
import LatestInfo from "../model/LatestInfo"
import Conditions, { ConditionParams } from "../model/Conditions"
import MessageStream from "../lib/MessageStream"
import Searcher from "../lib/Searcher"

import EditModeView from "./edit/EditModeView"
import DatabaseModeView from "./database/DatabaseModeView"
import NavHeader from "./concerns/NavHeader"
import ConditionView from "./concerns/ConditionView"
import ArcanaView from "./concerns/ArcanaView"
import DisplaySizeWarning from "./concerns/DisplaySizeWarning"

interface AppViewProps {
  conditions: ConditionParams
  latestInfo: LatestInfo
  mode: string
  ptver: string
  dataver: string
  appPath: string
  aboutPath: string
  originTitle: string
  arcana: string
  party: { [key: string]: any }
  heroes: string[]
}

interface AppViewState {
  pagerSize: number
  showConditionArea: boolean
}

export default class AppView extends React.Component<AppViewProps, AppViewState> {

  private phoneDevice: boolean
  private errorArea: HTMLDivElement | null = null
  private mainArea: HTMLDivElement | null = null
  private conditionArea: HTMLDivElement | null = null

  constructor(props: AppViewProps) {
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

    // search stream
    MessageStream.conditionStream.plug(MessageStream.queryStream)
    const recentlyQuery = Query.create({ recently: recentlySize })
    MessageStream.queryStream
      .doAction(() => this.switchMainMode())
      .map((q) => Query.create(q))
      .map((q) => (q.isEmpty() ? recentlyQuery : q))
      .onValue((q) => {
        Searcher.searchArcanas(q).onValue((r) => MessageStream.resultStream.push(r))
      })

    this.state = {
      pagerSize,
      showConditionArea: false
    }
  }

  public componentDidMount(): void {
    if (this.errorArea) {
      $(this.errorArea).hide()
    }
    if (this.conditionArea) {
      $(this.conditionArea).hide()
    }
    $("#pre-header").hide()
  }

  public render(): JSX.Element {
    return (
      <div>
        <NavHeader
          appPath={this.props.appPath}
          mode={this.props.mode}
          phoneDevice={this.phoneDevice}
          latestInfo={this.props.latestInfo}
        />
        {this.renderErrorArea()}
        {this.renderWarning()}
        <div id="main-area" ref={(d) => { this.mainArea = d }}>
          {this.renderModeView()}
        </div>
        <div id="condition-area" ref={(d) => { this.conditionArea = d }}>
          {this.renderConditionView()}
        </div>
        <ArcanaView
          phoneDevice={this.phoneDevice}
          originTitle={this.props.originTitle}
        />
      </div>
    )
  }

  private switchMainMode(): void {
    $("#search-modal").modal("hide")
    if (this.state.showConditionArea) {
      this.setState({
        showConditionArea: false
      }, () => {
        MessageStream.resultStream.push(null)
        this.fadeModeArea()
      })
    }
  }

  private switchConditionMode(): void {
    if (!this.state.showConditionArea) {
      this.setState({
        showConditionArea: true
      }, () => {
        this.fadeModeArea()
      })
    }
  }

  private fadeModeArea(): void {
    if (this.state.showConditionArea) {
      if (this.mainArea) {
        $(this.mainArea).hide()
      }
      if (this.conditionArea) {
        $(this.conditionArea).fadeIn("slow")
      }
    } else {
      if (this.conditionArea) {
        $(this.conditionArea).hide()
      }
      if (this.mainArea) {
        $(this.mainArea).fadeIn("slow")
      }
    }
  }

  private renderWarning(): JSX.Element | null {
    if (this.props.mode === "ptedit" && this.phoneDevice) {
      return <DisplaySizeWarning appPath={this.props.appPath} />
    } else {
      return null
    }
  }

  private renderModeView(): JSX.Element | null {
    switch (this.props.mode) {
      case "ptedit":
        return (
          <EditModeView
            phoneDevice={this.phoneDevice}
            appPath={this.props.appPath}
            aboutPath={this.props.aboutPath}
            initParty={this.props.party}
            ptver={this.props.ptver}
            arcana={this.props.arcana}
            switchConditionMode={this.switchConditionMode.bind(this)}
            pagerSize={this.state.pagerSize}
            originTitle={this.props.originTitle}
            heroes={this.props.heroes}
          />
        )
      case "database":
        return (
          <DatabaseModeView
            phoneDevice={this.phoneDevice}
            appPath={this.props.appPath}
            switchConditionMode={this.switchConditionMode.bind(this)}
            pagerSize={this.state.pagerSize}
          />
        )
      default:
        return null
    }
  }

  private renderConditionView(): JSX.Element | null {
    if (this.props.mode === "ptedit" && this.phoneDevice) {
      return null
    }

    return (
      <ConditionView
        originTitle={this.props.originTitle}
        switchMainMode={this.switchMainMode.bind(this)}
      />
    )
  }

  private renderErrorArea(): JSX.Element {
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
}
