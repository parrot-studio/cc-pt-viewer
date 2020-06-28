/* eslint-disable @typescript-eslint/no-explicit-any */
import * as _ from "lodash"
import * as React from "react"
import { Alert, Modal } from "react-bootstrap"

import Arcana from "../model/Arcana"
import Query, { QueryLog } from "../model/Query"
import QueryRepository from "../model/QueryRepository"
import Favorites from "../model/Favorites"
import { PartyLog } from "../model/PartyRepositroy"
import LatestInfo from "../model/LatestInfo"
import Conditions, { ConditionParams } from "../model/Conditions"
import MessageStream from "../lib/MessageStream"
import Searcher from "../lib/Searcher"
import Browser from "../lib/BrowserProxy"

import EditModeView from "./edit/EditModeView"
import DatabaseModeView from "./database/DatabaseModeView"
import NavHeader from "./concerns/NavHeader"
import ConditionView from "./concerns/ConditionView"
import ArcanaView from "./concerns/ArcanaView"
import DisplaySizeWarning from "./concerns/DisplaySizeWarning"

interface AppViewProps {
  conditions: ConditionParams
  latestInfo: LatestInfo | null
  mode: string
  ptver: string
  dataver: string
  appPath: string
  aboutPath: string
  originTitle: string
  arcana: string
  party: { [key: string]: any }
  heroes: any[]
  partyView: boolean
  queryLogs: QueryLog[]
  queryString: string
  firstResults: any
  tutorial: boolean
  favorites: string[]
  lastMembers: string
  parties: PartyLog[]
}

interface AppViewState {
  pagerSize: number
  showConditionArea: boolean
  showErrorArea: boolean
  loading: boolean
}

export default class AppView extends React.Component<AppViewProps, AppViewState> {

  private mainArea: HTMLDivElement | null = null
  private conditionArea: HTMLDivElement | null = null
  private firstArcana: Arcana | null = null
  private query: Query | null = null

  constructor(props: AppViewProps) {
    super(props)

    Searcher.init(
      this.props.dataver,
      this.props.appPath,
      Browser.csrfToken(),
      this.showLoadingModal.bind(this),
      this.showErrorArea.bind(this)
    )
    Conditions.init(this.props.conditions)
    QueryRepository.init(this.props.queryLogs)
    Favorites.init(this.props.favorites)

    const recentlySize = 32
    let pagerSize = 8
    if (this.props.mode === "database") {
      pagerSize = 16
    }

    const arcana = this.props.arcana
    if (!_.isEmpty(arcana)) {
      this.firstArcana = Arcana.build(arcana)
    }

    this.query = Query.parse(this.props.queryString)

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
    MessageStream.conditionStream.onValue((q) => this.query = Query.create(q))

    this.state = {
      pagerSize,
      showConditionArea: false,
      showErrorArea: false,
      loading: false
    }
  }

  public render(): JSX.Element {
    return (
      <div>
        <NavHeader
          appPath={this.props.appPath}
          mode={this.props.mode}
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
          originTitle={this.props.originTitle}
          firstArcana={this.firstArcana}
        />
        <Modal
          show={this.state.loading}
          onHide={this.showLoadingModal.bind(this, false)}
        />
      </div>
    )
  }

  private switchMainMode(): void {
    if (this.state.showConditionArea) {
      this.setState({
        showConditionArea: false,
        loading: false
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
        Browser.hide(this.mainArea)
      }
      if (this.conditionArea) {
        Browser.fadeIn(this.conditionArea)
      }
    } else {
      if (this.conditionArea) {
        Browser.hide(this.conditionArea)
      }
      if (this.mainArea) {
        Browser.fadeIn(this.mainArea)
      }
    }
  }

  private showLoadingModal(state: boolean): void {
    this.setState({ loading: state })
  }

  private showErrorArea(state: boolean): void {
    this.setState({ showErrorArea: state })
  }

  private renderWarning(): JSX.Element | null {
    if (this.props.mode === "ptedit") {
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
            appPath={this.props.appPath}
            aboutPath={this.props.aboutPath}
            initParty={this.props.party}
            ptver={this.props.ptver}
            arcana={this.props.arcana}
            partyView={this.props.partyView}
            switchConditionMode={this.switchConditionMode.bind(this)}
            pagerSize={this.state.pagerSize}
            originTitle={this.props.originTitle}
            heroes={this.props.heroes}
            latestInfo={this.props.latestInfo}
            firstResults={this.props.firstResults}
            tutorial={this.props.tutorial}
            lastMembers={this.props.lastMembers}
            parties={this.props.parties}
          />
        )
      case "database":
        return (
          <DatabaseModeView
            appPath={this.props.appPath}
            switchConditionMode={this.switchConditionMode.bind(this)}
            pagerSize={this.state.pagerSize}
            latestInfo={this.props.latestInfo}
            firstQuery={this.query}
            firstResults={this.props.firstResults}
          />
        )
      default:
        return null
    }
  }

  private renderConditionView(): JSX.Element | null {
    if (!this.state.showConditionArea) {
      return null
    }

    return (
      <ConditionView
        originTitle={this.props.originTitle}
        query={this.query}
        switchMainMode={this.switchMainMode.bind(this)}
      />
    )
  }

  private renderErrorArea(): JSX.Element | null {
    if (!this.state.showErrorArea) {
      return null
    }

    return (
      <div id="error-area">
        <div className="row">
          <div className="col-xs-12 col-md-12 col-sm-12">
            <Alert bsStyle="danger">
              <p>
                <strong>データの取得に失敗しました。</strong>
                <a href={Browser.thisPage()} className="alert-link">リロードする</a>か、もう一度検索してください。
              </p>
            </Alert>
          </div>
        </div>
      </div>
    )
  }
}
