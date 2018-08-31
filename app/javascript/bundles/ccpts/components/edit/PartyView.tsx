import * as _ from "lodash"
import * as React from "react"

import Party from "../../model/Party"

import FullCharacter from "./FullCharacter"
import HeroCharacter from "./HeroCharacter"

interface PartyViewProps {
  party: Party
  phoneDevice: boolean
}

export default class PartyView extends React.Component<PartyViewProps> {

  public render(): JSX.Element {
    return (
      <div className="row">
        <div className="col-xs-12 col-sm-12 col-md-12">
          <ul className="list-inline">
            {this.renderMembers()}
          </ul>
        </div>
      </div>
    )
  }

  private renderMembers(): JSX.Element[] {
    const list: Array<[string, string]> = [
      ["mem1", "Leader"],
      ["mem2", "2nd"],
      ["mem3", "3rd"],
      ["mem4", "4th"],
      ["sub1", "Sub1"],
      ["sub2", "Sub2"],
      [Party.FRIEND_KEY, "Friend"],
      [Party.HERO_KEY, "Heroic Skill"]
    ]

    const party = this.props.party
    return _.map(list, (l) => {
      const code = l[0]

      let body: JSX.Element | null = null
      if (code !== Party.HERO_KEY) {
        body = (
          <FullCharacter
            member={party.memberFor(code)}
            phoneDevice={this.props.phoneDevice}
          />
        )
      } else {
        body = (
          <div>
            <HeroCharacter member={party.memberFor(code)} mode="full" />
            <br />
            {this.renderCost()}
          </div>
        )
      }

      return (
        <li className="col-xs-6 col-sm-3 col-md-3" key={code}>
          <label className="member-label">{l[1]}</label>
          {body}
        </li>
      )
    })
  }

  private renderCost(): JSX.Element {
    return (
      <div className="well well-sm">
        <p className="text-center">
          <label htmlFor="cost">Total Cost</label><br />
          <span id="cost" className="cost">{this.props.party.cost}</span>
        </p>
      </div>
    )
  }
}
