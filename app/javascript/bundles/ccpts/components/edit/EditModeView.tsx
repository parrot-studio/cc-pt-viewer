import * as _ from "lodash"
import * as React from "react"

import Arcana from "../../model/Arcana"
import Party from "../../model/Party"
import PartyRepositroy, { PartyLog } from "../../model/PartyRepositroy"
import LatestInfo from "../../model/LatestInfo"
import MessageStream from "../../lib/MessageStream"
import Searcher from "../../lib/Searcher"
import Browser from "../../lib/BrowserProxy"

import LatestInfoArea from "../concerns/LatestInfoArea"

import MemberControlArea from "./MemberControlArea"
import MemberAreaHeader from "./MemberAreaHeader"
import MemberAreaBody from "./MemberAreaBody"
import TargetsEditArea from "./TargetsEditArea"
import PartyView from "./PartyView"
import EditTutorialArea from "./EditTutorialArea"
import NameSearchForm from "../concerns/NameSearchForm"

interface EditModeViewProps {
  appPath: string
  aboutPath: string
  ptver: string
  originTitle: string
  pagerSize: number
  arcana: string
  initParty: { [key: string]: any }
  heroes: any[]
  partyView: boolean
  latestInfo: LatestInfo | null
  firstResults: any
  tutorial: boolean
  lastMembers: string
  parties: PartyLog[]
  switchConditionMode(): void
}

interface EditModeViewState {
  party: Party
  lastHistory: string
  editMode: boolean
  showHeader: boolean
}

export default class EditModeView extends React.Component<EditModeViewProps, EditModeViewState> {

  private editArea: HTMLDivElement | null = null
  private partyArea: HTMLDivElement | null = null

  constructor(props) {
    super(props)

    Party.ptver = this.props.ptver
    PartyRepositroy.init(this.props.parties, this.props.lastMembers)

    MessageStream.partyStream.onValue((party) => {
      PartyRepositroy.setLastParty(party)
      const code = party.code
      MessageStream.historyStream.push(code)
      this.setState({
        party,
        lastHistory: code
      })
    })

    MessageStream.memberCodeStream.onValue((code) => {
      Searcher.searchMembers(code).onValue((party) => {
        this.setState({ party })
      })
    })

    MessageStream.historyStream
      .filter((t) => _.eq(t, "reset"))
      .onValue(() => this.replaceHistory(""))

    MessageStream.historyStream
      .filter((t) => !_.eq(t, "reset"))
      .onValue((t) => {
        if (!_.isEmpty(t)) {
          this.replaceHistory(t)
        } else {
          this.replaceHistory(this.state.lastHistory)
        }
      })

    const editMode = !this.props.partyView
    const initPt = Party.build(this.props.initParty)
    let lastHistory = ""
    let showHeader = true
    if (this.props.partyView) {
      lastHistory = initPt.code
      showHeader = false
    }

    this.state = {
      editMode,
      lastHistory,
      showHeader,
      party: initPt
    }
  }

  public render(): JSX.Element {
    return (
      <div>
        {this.renderHeadInfo()}
        <MemberControlArea
          appPath={this.props.appPath}
          aboutPath={this.props.aboutPath}
          party={this.state.party}
          editMode={this.state.editMode}
          switchEditMode={this.switchEditMode.bind(this)}
        />
        {this.renderEditArea()}
        {this.renderPartyArea()}
      </div>
    )
  }

  private replaceHistory(uri: string): void {
    Browser.changeUrl(`/${uri}`)
  }

  private switchEditMode(): void {
    this.setState({
      editMode: !this.state.editMode,
      showHeader: true
    }, () => {
      this.fadeArea()
      if (this.state.editMode) {
        MessageStream.historyStream.push("reset")
        this.setState({ lastHistory: "" })

        Browser.changeTitle(this.props.originTitle)
      } else {
        MessageStream.historyStream.push(PartyRepositroy.lastParty)
        this.setState({ lastHistory: PartyRepositroy.lastParty })
      }
    })
  }

  private fadeArea(): void {
    if (this.state.editMode) {
      if (this.partyArea) {
        Browser.hide(this.partyArea)
      }
      if (this.editArea) {
        Browser.fadeIn(this.editArea)
      }
    } else {
      if (this.editArea) {
        Browser.hide(this.editArea)
      }
      if (this.partyArea) {
        Browser.fadeIn(this.partyArea)
      }
    }
  }

  private renderHeadInfo(): JSX.Element | null {
    if (!this.state.showHeader) {
      return null
    }

    if (!this.props.tutorial) {
      return <EditTutorialArea />
    } else {
      return <LatestInfoArea latestInfo={this.props.latestInfo} />
    }
  }

  private renderEditArea(): JSX.Element | null {
    if (!this.state.editMode) {
      return null
    }

    return (
      <div id="edit-area" className="hidden-xs" ref={(d) => { this.editArea = d }}>
        <div id="member-area" className="well well-sm">
          <MemberAreaHeader party={this.state.party} />
          <MemberAreaBody
            party={this.state.party}
            heroes={this.props.heroes}
          />
        </div>
        <TargetsEditArea
          pagerSize={this.props.pagerSize}
          switchConditionMode={this.props.switchConditionMode}
          firstResults={this.props.firstResults}
        />
        <NameSearchForm />
      </div>
    )
  }

  private renderPartyArea(): JSX.Element | null {
    if (this.state.editMode) {
      return null
    }

    return (
      <div id="party-area" ref={(d) => { this.partyArea = d }}>
        <PartyView
          party={this.state.party}
        />
      </div>
    )
  }
}
