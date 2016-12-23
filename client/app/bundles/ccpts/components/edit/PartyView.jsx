import React from 'react'

import FullCharacter from './FullCharacter'

export default class PartyView extends React.Component {

  renderMembers() {
    let list = [
      ["mem1", "Leader"],
      ["mem2", "2nd"],
      ["mem3", "3rd"],
      ["mem4", "4th"],
      ["sub1", "Sub1"],
      ["sub2", "Sub2"],
      ["friend", "Friend"]
    ]

    let party = this.props.party
    return _.map(list, (l) => {
      let code = l[0]
      return (
        <li className="col-xs-6 col-sm-3 col-md-3" key={code}>
          <FullCharacter
            code={code}
            member={party.memberFor(code)}
            name={l[1]}
            phoneDevice={this.props.phoneDevice}
            arcanaViewStream={this.props.arcanaViewStream}/>
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
      </div>
    )
  }
}
