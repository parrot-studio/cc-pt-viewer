import _ from 'lodash'

import React from 'react'

import Query from '../../model/Query'
import Party from '../../model/Party'
import Parties from '../../model/Parties'
import MessageStream from '../../model/MessageStream'
import Searcher from '../../lib/Searcher'

import MemberControlArea from './MemberControlArea'
import MemberAreaHeader from './MemberAreaHeader'
import MemberAreaBody from './MemberAreaBody'
import TargetsEditArea from './TargetsEditArea'
import PartyView from './PartyView'

export default class EditModeView extends React.Component {

  constructor(props) {
    super(props)

    Party.ptver = this.props.ptver
    Parties.init()

    MessageStream.partyStream.onValue((party) => {
      Parties.setLastParty(party)
      MessageStream.historyStream.push(party.createCode())
      this.setState({party})
    })

    MessageStream.memberCodeStream.onValue((code) => {
      Searcher.searchMembers(code).onValue((as) => {
        const party = Party.build(as)
        this.setState({party})
      })
    })

    MessageStream.historyStream.onValue((target) => {
      let uri = ''
      if (!_.isEmpty(target) ) {
        uri = target
      } else if (!_.isEmpty(Parties.lastParty)) {
        uri = Parties.lastParty
      }
      history.replaceState('', '', `/${uri}`)
    })

    this.state = {
      editMode: (_.isEmpty(this.props.ptm) ? true : false),
      party: Party.create()
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
      if (!code) {
        MessageStream.historyStream.push(Parties.lastParty)
      }
    } else {
      MessageStream.memberCodeStream.push(this.props.ptm)
    }

    if (this.state.editMode)  {
      $(this.refs.partyArea).hide()
      $(this.refs.editArea).show()
    } else {
      $(this.refs.editArea).hide()
      $(this.refs.partyArea).show()
    }
  }

  switchEditMode() {
    this.setState({editMode: !this.state.editMode}, () => {
      this.fadeArea()
    })
  }

  fadeArea() {
    if (this.state.editMode)  {
      $(this.refs.partyArea).hide()
      $(this.refs.editArea).fadeIn()
    } else {
      $(this.refs.editArea).hide()
      $(this.refs.partyArea).fadeIn()
    }
  }

  renderTargetsArea() {
    if (this.props.phoneDevice) {
      return null
    } else {
      return <TargetsEditArea
        phoneDevice={this.props.phoneDevice}
        pagerSize={this.props.pagerSize}
        switchConditionMode={this.props.switchConditionMode}/>
    }
  }

  renderEditArea() {
    if (this.props.phoneDevice) {
      return null
    }
    return(
      <div id="edit-area" ref="editArea">
        <div id="member-area" className="well well-sm">
          <MemberAreaHeader party={this.state.party}/>
          <MemberAreaBody party={this.state.party}/>
        </div>
        {this.renderTargetsArea()}
      </div>
    )
  }

  render() {
    return (
      <div>
        <MemberControlArea
          phoneDevice={this.props.phoneDevice}
          appPath={this.props.appPath}
          aboutPath={this.props.aboutPath}
          party={this.state.party}
          editMode={this.state.editMode}
          switchEditMode={this.switchEditMode.bind(this)}/>
        {this.renderEditArea()}
        <div id="party-area" ref="partyArea">
          <PartyView
            phoneDevice={this.props.phoneDevice}
            party={this.state.party}/>
        </div>
      </div>
    )
  }
}
