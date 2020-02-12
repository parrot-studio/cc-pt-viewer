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
    let swapMember: Member | null = null // drop member
    if (swapKey) {
      if (targetKey === swapKey) {
        return
      }
      swapMember = party.memberFor(swapKey)
    }

    // target
    let jobCode = drag.data("jobCode")
    let arcana: Arcana | null = null
    if (swapMember) {
      arcana = swapMember.arcana
    } else {
      arcana = Arcana.forCode(jobCode)
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
    }

    // for select view
    const orgMember = party.memberFor(targetKey)
    let replaceMember: Member | null = null
    if (swapMember) {
      replaceMember = swapMember
    } else {
      replaceMember = new Member(targetKey, arcana, null)
    }

    if (!orgMember || Arcana.sameArcana(orgMember.arcana, replaceMember.arcana)) {
      this.replaceMemberArea(targetKey, replaceMember)
      return
    }

    const chainMember = new Member(targetKey, orgMember.arcana, arcana)

    this.setState({
      showSelectModal: true,
      targetKey,
      chainMember,
      replaceMember
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
    const member = this.state.chainMember
    if (member) {
      const party = this.props.party
      party.addMember(member)
      MessageStream.partyStream.push(party)
    }
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
    if (target && target.position !== targetKey && targetKey !== Member.FRIEND_KEY) {
      party.swap(targetKey, target.position)
    } else {
      if (target) {
        party.addMember(new Member(targetKey, target.arcana, target.chainArcana))
      } else {
        party.removeMember(targetKey)
      }
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
    const arcana = Arcana.forCode(e.currentTarget.value)
    party.addHero(arcana)
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
      [Member.FRIEND_KEY, "Friend"]
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
    const hero = this.props.party.memberFor(Member.HERO_KEY)
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
