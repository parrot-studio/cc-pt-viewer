import _ from 'lodash'
import Bacon from 'baconjs'

import React from 'react'

import Query from '../../model/Query'
import Party from '../../model/Party'
import Parties from '../../model/Parties'
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

    let partyStream = new Bacon.Bus()
    let memberCodeStream = new Bacon.Bus()

    partyStream.onValue((party) => {
      Parties.setLastParty(party)
      this.setState({party: party})
    })

    memberCodeStream.onValue((code) => {
      Searcher.searchMembers(code).onValue((as) => {
        let party = Party.build(as)
        this.setState({party: party})
      })
    })

    this.state = {
      editMode: (_.isEmpty(this.props.ptm) ? true : false),
      party: Party.create(),
      partyStream: partyStream,
      memberCodeStream: memberCodeStream
    }
  }

  componentDidMount() {
    this.props.queryStream.push(Query.parse().params())
    if (_.isEmpty(this.props.ptm)) {
      this.state.memberCodeStream.push(Parties.lastParty)
    } else {
      this.state.memberCodeStream.push(this.props.ptm)
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
        switchConditionMode={this.props.switchConditionMode}
        conditionStream={this.props.conditionStream}
        queryStream={this.props.queryStream}
        resultStream={this.props.resultStream}
        arcanaViewStream={this.props.arcanaViewStream}/>
    }
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
        <div id="edit-area" ref="editArea">
          <div id="member-area" className="well well-sm">
            <MemberAreaHeader
              party={this.state.party}
              partyStream={this.state.partyStream}
              memberCodeStream={this.state.memberCodeStream}/>
            <MemberAreaBody
              party={this.state.party}
              partyStream={this.state.partyStream}
              arcanaViewStream={this.props.arcanaViewStream}/>
          </div>
          {this.renderTargetsArea()}
        </div>
        <div id="party-area" ref="partyArea">
          <PartyView
            phoneDevice={this.props.phoneDevice}
            party={this.state.party}
            arcanaViewStream={this.props.arcanaViewStream}/>
        </div>
      </div>
    )
  }
}
