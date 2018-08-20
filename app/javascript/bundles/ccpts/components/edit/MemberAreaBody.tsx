import * as _ from "lodash"
import * as React from "react"
declare var $

import Arcana from "../../model/Arcana"
import Member from "../../model/Member"
import Party from "../../model/Party"
import MessageStream from "../../model/MessageStream"

import MemberCharacter from "./MemberCharacter"
import MemberSelectModal from "./MemberSelectModal"

interface MemberAreaBodyProps {
  party: Party
}

interface MemberAreaBodyState {
  showSelectModal: boolean
  targetKey: string | null
  chainMember: Member | null
  replaceMember: Member | null
}

export default class MemberAreaBody extends React.Component<MemberAreaBodyProps, MemberAreaBodyState> {

  constructor(props) {
    super(props)

    this.state = {
      showSelectModal: false,
      targetKey: null,
      chainMember: null,
      replaceMember: null
    }

    this.handleDropedArcana = this.handleDropedArcana.bind(this)
  }

  public render(): JSX.Element {
    return (
      <div className="row">
        <div className="col-xs-12 col-sm-12 col-md-12">
          <ul className="list-inline">
            {this.renderMembers()}
            <li className="col-xs-6 col-sm-3 col-md-3 member-list">
              <p className="text-center">
                <label htmlFor="cost">Total Cost</label><br />
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
          selectReplace={this.selectReplace.bind(this)}
        />
      </div>
    )
  }

  private addDropHandler(div: HTMLLIElement | null, code: string): void {
    if (!div) {
      return
    }

    $(div).droppable({
      drop: (e, ui) => {
        e.preventDefault()
        this.handleDropedArcana(code, ui.draggable)
      }
    })
  }

  private handleDropedArcana(targetKey: string, drag) {
    const party = this.props.party

    const swapKey = drag.data("memberKey")
    if (swapKey && targetKey === swapKey) {
      return
    }

    let swapMember: Member | null = null
    if (swapKey) {
      swapMember = party.memberFor(swapKey)
    }

    let jobCode = drag.data("jobCode")
    // drop member
    if (swapMember) {
      jobCode = swapMember.arcana.jobCode
    }

    let arcana = Arcana.forCode(jobCode)
    if (!arcana) {
      return
    }

    // drop buddy
    if (arcana.hasOwner()) {
      const owner = arcana.owner()
      if (!owner) {
        return
      }
      jobCode = owner.jobCode
      arcana = Arcana.forCode(jobCode)
      if (!arcana) {
        return
      }
    }

    const orgMember = party.memberFor(targetKey)
    const target = new Member(arcana)
    if (swapMember) {
      target.memberKey = swapMember.memberKey
      target.chainArcana = swapMember.chainArcana
    }

    if (!orgMember || Arcana.sameArcana(orgMember.arcana, target.arcana)) {
      this.replaceMemberArea(targetKey, target)
      return
    }

    const chainMember = new Member(orgMember.arcana)
    chainMember.chainArcana = Arcana.forCode(jobCode)
    chainMember.memberKey = targetKey

    this.setState({
      showSelectModal: true,
      targetKey,
      chainMember,
      replaceMember: target
    })
  }

  private closeModal(): void {
    this.setState({
      showSelectModal: false,
      targetKey: null,
      chainMember: null,
      replaceMember: null
    })
  }

  private selectChain(): void {
    const targetKey = this.state.targetKey
    if (!targetKey) {
      return
    }

    const chainMember = this.state.chainMember
    const party = this.props.party
    party.addMember(targetKey, chainMember)
    MessageStream.partyStream.push(party)
    this.closeModal()
  }

  private selectReplace(): void {
    const targetKey = this.state.targetKey
    if (!targetKey) {
      return
    }

    const replaceMember = this.state.replaceMember
    this.replaceMemberArea(targetKey, replaceMember)
    this.closeModal()
  }

  private replaceMemberArea(targetKey: string, target: Member | null) {
    const party = this.props.party
    if (target && target.memberKey && targetKey !== "friend") {
      party.swap(targetKey, target.memberKey)
    } else {
      party.addMember(targetKey, target)
    }
    MessageStream.partyStream.push(party)
  }

  private removeMember(code: string, e: Event): void {
    e.preventDefault()
    const party = this.props.party
    party.removeMember(code)
    MessageStream.partyStream.push(party)
  }

  private removeChain(code: string, e: Event) {
    e.preventDefault()
    const party = this.props.party
    party.removeChain(code)
    MessageStream.partyStream.push(party)
  }

  private renderMembers(): JSX.Element[] {
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
        <li
          className="col-xs-6 col-sm-3 col-md-3 member-list"
          key={code}
          ref={(div) => { this.addDropHandler(div, code) }}
        >
          <MemberCharacter
            member={party.memberFor(code)}
            title={l[1]}
            removeMember={this.removeMember.bind(this, code)}
            removeChain={this.removeChain.bind(this, code)}
          />
        </li>
      )
    })
  }
}
