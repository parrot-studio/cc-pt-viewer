import * as _ from "lodash"
import * as React from "react"
declare var $: JQueryStatic
declare var history: History

import Arcana from "../../model/Arcana"
import Party from "../../model/Party"
import Parties from "../../model/Parties"
import MessageStream from "../../lib/MessageStream"
import Searcher from "../../lib/Searcher"

import MemberControlArea from "./MemberControlArea"
import MemberAreaHeader from "./MemberAreaHeader"
import MemberAreaBody from "./MemberAreaBody"
import TargetsEditArea from "./TargetsEditArea"
import PartyView from "./PartyView"

interface EditModeViewProps {
  appPath: string
  aboutPath: string
  ptver: string
  originTitle: string
  phoneDevice: boolean
  pagerSize: number
  arcana: string
  initParty: { [key: string]: any }
  heroes: string[]
  switchConditionMode(): void
}

interface EditModeViewState {
  party: Party
  lastHistory: string
  editMode: boolean
  targetInitialized: boolean
}

export default class EditModeView extends React.Component<EditModeViewProps, EditModeViewState> {

  private editArea: HTMLDivElement | null = null
  private partyArea: HTMLDivElement | null = null

  constructor(props) {
    super(props)

    Party.ptver = this.props.ptver
    Parties.init()

    MessageStream.partyStream.onValue((party) => {
      Parties.setLastParty(party)
      const code = party.createCode()
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

    const editMode = _.isEmpty(this.props.initParty)
    const targetInitialized = !_.isEmpty(this.props.arcana)

    let initPt = Party.create()
    let lastHistory = ""
    if (!_.isEmpty(this.props.initParty)) {
      initPt = Party.build(this.props.initParty)
      lastHistory = initPt.createCode()
    }

    this.state = {
      editMode,
      lastHistory,
      targetInitialized,
      party: initPt
    }
  }

  public componentDidMount(): void {
    const arcana = this.props.arcana
    if (!_.isEmpty(arcana)) {
      const a = Arcana.build(arcana)
      if (!a) {
        return
      }
      MessageStream.queryStream.push({ name: a.name })
      MessageStream.arcanaViewStream.push(a)
    }

    if (_.isEmpty(this.props.initParty)) {
      MessageStream.memberCodeStream.push(Parties.lastParty)
      if (_.isEmpty(arcana)) {
        MessageStream.historyStream.push("reset")
      }
    }

    if (this.state.editMode) {
      if (this.partyArea) {
        $(this.partyArea).hide()
      }
      if (this.editArea) {
        $(this.editArea).show()
      }

      if (!this.props.phoneDevice && !this.state.targetInitialized) {
        this.initSearchTarget()
      }
    } else {
      if (this.editArea) {
        $(this.editArea).hide()
      }
      if (this.partyArea) {
        $(this.partyArea).show()
      }
    }
  }

  public render(): JSX.Element {
    return (
      <div>
        <MemberControlArea
          phoneDevice={this.props.phoneDevice}
          appPath={this.props.appPath}
          aboutPath={this.props.aboutPath}
          party={this.state.party}
          editMode={this.state.editMode}
          switchEditMode={this.switchEditMode.bind(this)}
        />
        {this.renderEditArea()}
        <div id="party-area" ref={(d) => { this.partyArea = d }}>
          <PartyView
            phoneDevice={this.props.phoneDevice}
            party={this.state.party}
          />
        </div>
      </div>
    )
  }

  private initSearchTarget(): void {
    MessageStream.queryStream.push({})
    Searcher.searchCodes(this.props.heroes).onValue(() => {
      this.setState({ targetInitialized: true })
    })
  }

  private replaceHistory(uri: string): void {
    history.replaceState("", "", `/${uri}`)
  }

  private switchEditMode(): void {
    this.setState({ editMode: !this.state.editMode }, () => {
      this.fadeArea()
      if (this.state.editMode) {
        MessageStream.historyStream.push("reset")
        this.setState({ lastHistory: "" })

        document.title = this.props.originTitle

        if (!this.state.targetInitialized) {
          this.initSearchTarget()
        }
      } else {
        MessageStream.historyStream.push(Parties.lastParty)
        this.setState({ lastHistory: Parties.lastParty })
      }
    })
  }

  private fadeArea(): void {
    if (this.state.editMode) {
      if (this.partyArea) {
        $(this.partyArea).hide()
      }
      if (this.editArea) {
        $(this.editArea).fadeIn()
      }
    } else {
      if (this.editArea) {
        $(this.editArea).hide()
      }
      if (this.partyArea) {
        $(this.partyArea).fadeIn()
      }
    }
  }

  private renderTargetsArea(): JSX.Element | null {
    if (this.props.phoneDevice) {
      return null
    }

    return (
      <TargetsEditArea
        phoneDevice={this.props.phoneDevice}
        pagerSize={this.props.pagerSize}
        switchConditionMode={this.props.switchConditionMode}
      />
    )
  }

  private renderEditArea(): JSX.Element | null {
    if (this.props.phoneDevice) {
      return null
    }

    return (
      <div id="edit-area" ref={(d) => { this.editArea = d }}>
        <div id="member-area" className="well well-sm">
          <MemberAreaHeader party={this.state.party} />
          <MemberAreaBody
            party={this.state.party}
            heroes={this.props.heroes}
          />
        </div>
        {this.renderTargetsArea()}
      </div>
    )
  }
}
