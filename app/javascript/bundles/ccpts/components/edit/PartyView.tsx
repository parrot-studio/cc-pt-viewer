import * as _ from "lodash"
import * as React from "react"

import Party from "../../model/Party"

import FullCharacter from "./FullCharacter"

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
            <li className="col-xs-6 col-sm-3 col-md-3 member-list">
              <p className="text-center">
                <label htmlFor="cost">Total Cost</label><br />
                <span id="cost" className="cost">{this.props.party.cost}</span>
              </p>
            </li>
          </ul>
        </div>
      </div>
    )
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
        <li className="col-xs-6 col-sm-3 col-md-3" key={code}>
          <FullCharacter
            member={party.memberFor(code)}
            title={l[1]}
            phoneDevice={this.props.phoneDevice}
          />
        </li>
      )
    })
  }
}
