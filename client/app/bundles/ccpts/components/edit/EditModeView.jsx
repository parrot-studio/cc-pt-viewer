import _ from "lodash"

import React from "react"

import Query from "../../model/Query"
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
      Searcher.searchMembers(code).onValue((as) => {
        const party = Party.build(as)
        this.setState({party})
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
    if (!this.props.imageMode) {
      editMode = _.isEmpty(this.props.ptm) ? true : false
    }

    this.state = {
      editMode,
      party: Party.create(),
      lastHistory: this.props.ptm
    }
  }

  componentDidMount() {
    const code = this.props.code
    if (code) {
      Searcher.searchCodes([code]).onValue((result) => {
        const a = result.arcanas[0]
        if (a) {
          MessageStream.queryStream.push({name: a.name})
          MessageStream.arcanaViewStream.push(a)
        }
      })
    }

    if (!this.props.phoneDevice) {
      MessageStream.queryStream.push(Query.parse().params())
    }
    if (_.isEmpty(this.props.ptm)) {
      MessageStream.memberCodeStream.push(Parties.lastParty)
      if (_.isEmpty(code)){
        MessageStream.historyStream.push("reset")
      }
    } else {
      MessageStream.memberCodeStream.push(this.props.ptm)
    }

    if (this.state.editMode)  {
      $(this.partyArea).hide()
      $(this.editArea).show()
    } else {
      $(this.editArea).hide()
      $(this.partyArea).show()
    }
  }

  replaceHistory(uri) {
    history.replaceState("", "", `/${uri}`)
  }

  switchEditMode() {
    this.setState({editMode: !this.state.editMode}, () => {
      this.fadeArea()
      if (this.state.editMode) {
        MessageStream.historyStream.push("reset")
        this.setState({lastHistory: ""})
      } else {
        MessageStream.historyStream.push(Parties.lastParty)
        this.setState({lastHistory: Parties.lastParty})
      }
    })
  }

  fadeArea() {
    if (this.state.editMode)  {
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
      switchConditionMode={this.props.switchConditionMode}/>
  }

  renderAreaHeader() {
    if (this.props.imageMode) {
      return null
    }

    return <MemberAreaHeader party={this.state.party}/>
  }

  renderEditArea() {
    if (this.props.phoneDevice) {
      return null
    }

    return(
      <div id="edit-area" ref={(d) => { this.editArea = d }}>
        <div id="member-area" className="well well-sm">
          {this.renderAreaHeader()}
          <MemberAreaBody party={this.state.party}/>
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
      switchEditMode={this.switchEditMode.bind(this)}/>
  }

  render() {
    return (
      <div>
        {this.renderControlArea()}
        {this.renderEditArea()}
        <div id="party-area" ref={(d) => { this.partyArea = d }}>
          <PartyView
            phoneDevice={this.props.phoneDevice}
            party={this.state.party}/>
        </div>
      </div>
    )
  }
}
