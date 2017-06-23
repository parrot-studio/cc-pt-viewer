import _ from "lodash"

import React from "react"

import Arcana from "../../model/Arcana"
import Member from "../../model/Member"
import MessageStream from "../../model/MessageStream"

import MemberCharacter from "./MemberCharacter"
import MemberSelectModal from "./MemberSelectModal"

export default class MemberAreaBody extends React.Component {

  constructor(props) {
    super(props)

    this.state = {
      showSelectModal: false,
      orgKey: null,
      chainMember: null,
      replaceMember: null
    }

    this.handleDropedArcana = this.handleDropedArcana.bind(this)
  }

  addDropHandler(div, code) {
    $(div).droppable({
      drop: (e, ui) => {
        e.preventDefault()
        this.handleDropedArcana(code, ui.draggable)
      }
    })
  }

  handleDropedArcana(orgKey, drag) {
    const swapKey = drag.data("memberKey")
    if (orgKey === swapKey) {
      return
    }

    const party = this.props.party
    let jobCode = drag.data("jobCode")
    // drop member
    if (swapKey) {
      jobCode = party.memberFor(swapKey).arcana.jobCode
    }

    let arcana = Arcana.forCode(jobCode)
    // drop buddy
    if (arcana.hasOwner()) {
      jobCode = arcana.owner().jobCode
      arcana = Arcana.forCode(jobCode)
    }

    const orgMember = party.memberFor(orgKey)
    const target = new Member(arcana)
    if (swapKey) {
      target.memberKey = swapKey
      target.chainArcana = party.memberFor(swapKey).chainArcana
    }

    if (!orgMember || Arcana.sameArcana(orgMember.arcana, target.arcana)) {
      this.replaceMemberArea(orgKey, target)
      return
    }

    const chainMember = new Member(orgMember.arcana)
    chainMember.chainArcana = Arcana.forCode(jobCode)
    chainMember.memberKey = orgKey

    this.setState({
      showSelectModal: true,
      orgKey,
      chainMember,
      replaceMember: target
    })
  }

  closeModal() {
    this.setState({
      showSelectModal: false,
      orgKey: null,
      chainMember: null,
      replaceMember: null
    })
  }

  selectChain() {
    const orgKey = this.state.orgKey
    const chainMember = this.state.chainMember
    const party = this.props.party
    party.addMember(orgKey, chainMember)
    MessageStream.partyStream.push(party)
    this.closeModal()
  }

  selectReplace() {
    const orgKey = this.state.orgKey
    const replaceMember = this.state.replaceMember
    this.replaceMemberArea(orgKey, replaceMember)
    this.closeModal()
  }

  replaceMemberArea(orgKey, target) {
    const party = this.props.party
    if (target.memberKey && orgKey !== "friend") {
      party.swap(orgKey, target.memberKey)
    } else {
      party.addMember(orgKey, target)
    }
    MessageStream.partyStream.push(party)
  }

  removeMember(code, e) {
    e.preventDefault()
    const party = this.props.party
    party.removeMember(code)
    MessageStream.partyStream.push(party)
  }

  removeChain(code, e) {
    e.preventDefault()
    const party = this.props.party
    party.removeChain(code)
    MessageStream.partyStream.push(party)
  }

  renderMembers() {
    const list = [
      ["mem1", "Leader"],
      ["mem2", "2nd"],
      ["mem3", "3rd"],
      ["mem4", "4th"],
      ["sub1", "Sub1"],
      ["sub2", "Sub2"],
      ["friend", "Friend"]
    ]

    const party = this.props.party
    return _.map(list, (l) => {
      const code = l[0]
      return (
        <li className="col-xs-6 col-sm-3 col-md-3 member-list" key={code}
          ref={(div) => {
            this.addDropHandler(div, code)
          }}>
          <MemberCharacter
            code={code}
            member={party.memberFor(code)}
            name={l[1]}
            removeMember={this.removeMember.bind(this, code)}
            removeChain={this.removeChain.bind(this, code)}/>
        </li>
      )
    })
  }

  render() {
    return (
      <div className="row">
        <div className="col-xs-12 col-sm-12 col-md-12">
          <ul className="list-inline">
            {this.renderMembers()}
            <li className="col-xs-6 col-sm-3 col-md-3 member-list">
              <p className="text-center">
                <label htmlFor="cost">Total Cost</label><br/>
                <span id="cost" className="cost">{this.props.party.cost}</span>
              </p>
            </li>
          </ul>
        </div>

        <MemberSelectModal
          showModal={this.state.showSelectModal}
          chainMember={this.state.chainMember}
          replaceMember={this.state.replaceMember}
          closeModal={this.closeModal.bind(this)}
          selectChain={this.selectChain.bind(this)}
          selectReplace={this.selectReplace.bind(this)}/>
      </div>
    )
  }
}
