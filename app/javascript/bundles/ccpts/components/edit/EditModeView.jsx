import _ from "lodash"

import React from "react"

import Arcana from "../../model/Arcana"
import Party from "../../model/Party"
import Parties from "../../model/Parties"
import MessageStream from "../../model/MessageStream"
import Searcher from "../../lib/Searcher"

import MemberControlArea from "./MemberControlArea"
import MemberAreaHeader from "./MemberAreaHeader"
import MemberAreaBody from "./MemberAreaBody"
import TargetsEditArea from "./TargetsEditArea"
import PartyView from "./PartyView"

export default class EditModeView extends React.Component {

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

    let editMode = true
    let targetInitialized = true
    if (!this.props.imageMode) {
      editMode = _.isEmpty(this.props.initParty)
      targetInitialized = !_.isEmpty(this.props.arcana)
    }

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

  componentDidMount() {
    const arcana = this.props.arcana
    if (!_.isEmpty(arcana)) {
      const a = Arcana.build(arcana)
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
      $(this.partyArea).hide()
      $(this.editArea).show()

      if (!this.props.phoneDevice && !this.state.targetInitialized) {
        this.initSearchTarget()
      }
    } else {
      $(this.editArea).hide()
      $(this.partyArea).show()
    }
  }

  initSearchTarget() {
    MessageStream.queryStream.push({})
    this.setState({ targetInitialized: true })
  }

  replaceHistory(uri) {
    history.replaceState("", "", `/${uri}`)
  }

  switchEditMode() {
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

  fadeArea() {
    if (this.state.editMode) {
      $(this.partyArea).hide()
      $(this.editArea).fadeIn()
    } else {
      $(this.editArea).hide()
      $(this.partyArea).fadeIn()
    }
  }

  renderTargetsArea() {
    if (this.props.imageMode || this.props.phoneDevice) {
      return null
    }

    return <TargetsEditArea
      phoneDevice={this.props.phoneDevice}
      pagerSize={this.props.pagerSize}
      switchConditionMode={this.props.switchConditionMode} />
  }

  renderAreaHeader() {
    if (this.props.imageMode) {
      return null
    }

    return <MemberAreaHeader party={this.state.party} />
  }

  renderEditArea() {
    if (this.props.phoneDevice) {
      return null
    }

    return (
      <div id="edit-area" ref={(d) => { this.editArea = d }}>
        <div id="member-area" className="well well-sm">
          {this.renderAreaHeader()}
          <MemberAreaBody party={this.state.party} />
        </div>
        {this.renderTargetsArea()}
      </div>
    )
  }

  renderControlArea() {
    if (this.props.imageMode) {
      return null
    }

    return <MemberControlArea
      phoneDevice={this.props.phoneDevice}
      appPath={this.props.appPath}
      aboutPath={this.props.aboutPath}
      party={this.state.party}
      editMode={this.state.editMode}
      switchEditMode={this.switchEditMode.bind(this)} />
  }

  render() {
    return (
      <div>
        {this.renderControlArea()}
        {this.renderEditArea()}
        <div id="party-area" ref={(d) => { this.partyArea = d }}>
          <PartyView
            phoneDevice={this.props.phoneDevice}
            party={this.state.party} />
        </div>
      </div>
    )
  }
}
