import * as _ from "lodash"
import * as React from "react"
import { FormGroup, ControlLabel, FormControl } from "react-bootstrap"

import Arcana from "../../model/Arcana"
import Member from "../../model/Member"
import Party from "../../model/Party"
import MessageStream from "../../lib/MessageStream"

import MemberCharacter from "./MemberCharacter"
import MemberSelectModal from "./MemberSelectModal"
import HeroCharacter from "./HeroCharacter"
import Browser from "../../lib/BrowserProxy"

interface MemberAreaBodyProps {
  party: Party
  heroes: any[]
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
              {this.renderHeroicArea()}
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
    Browser.addDropHandler(div, code, this.handleDropedArcana)
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
    if (target && target.memberKey && targetKey !== Party.FRIEND_KEY) {
      party.swap(targetKey, target.memberKey)
    } else {
      party.addMember(targetKey, target)
    }
    MessageStream.partyStream.push(party)
  }

  private removeMember(code: string): void {
    const party = this.props.party
    party.removeMember(code)
    MessageStream.partyStream.push(party)
  }

  private removeChain(code: string) {
    const party = this.props.party
    party.removeChain(code)
    MessageStream.partyStream.push(party)
  }

  private changeHeroicSKill(e): void {
    const party = this.props.party
    party.addHero(e.currentTarget.value)
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
      [Party.FRIEND_KEY, "Friend"]
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

  private renderHeroicArea(): JSX.Element {
    const hero = this.props.party.memberFor(Party.HERO_KEY)
    let hcode = ""
    if (hero) {
      hcode = hero.arcana.jobCode
    }

    const opts: JSX.Element[] = _.chain(this.props.heroes)
      .map((h) => Arcana.build(h))
      .compact()
      .map((a) => <option key={a.jobCode} value={a.jobCode}>{a.title} {a.name}</option>)
      .value()

    return (
      <div>
        <FormGroup controlId="heroic-skill">
          <ControlLabel>Heroic Skill</ControlLabel>
          <FormControl
            componentClass="select"
            placeholder="ヒロイックスキル"
            value={hcode}
            onChange={this.changeHeroicSKill.bind(this)}
          >
            <option key="none" value="">（なし）</option>
            {opts}
          </FormControl>
        </FormGroup>
        <HeroCharacter member={hero} mode="edit" />
      </div>
    )
  }
}
