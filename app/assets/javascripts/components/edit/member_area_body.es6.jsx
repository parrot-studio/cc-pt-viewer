class MemberAreaBody extends React.Component {

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
    let jobCode = drag.data('jobCode')
    let swapKey = drag.data('memberKey')
    if (orgKey === swapKey) {
      return
    }

    let party = this.props.party
    let orgMember = party.memberFor(orgKey)
    let target = new Member(Arcana.forCode(jobCode))
    if (swapKey) {
      target.memberKey = swapKey
      target.chainArcana = party.memberFor(swapKey).chainArcana
    }

    if (!orgMember || Arcana.sameArcana(orgMember.arcana, target.arcana)) {
      this.replaceMemberArea(orgKey, target)
      return
    }

    let chainMember = new Member(orgMember.arcana)
    chainMember.chainArcana = Arcana.forCode(jobCode)
    chainMember.memberKey = orgKey

    this.setState({
      showSelectModal: true,
      orgKey: orgKey,
      chainMember: chainMember,
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
    let orgKey = this.state.orgKey
    let chainMember = this.state.chainMember
    let party = this.props.party
    party.addMember(orgKey, chainMember)
    this.props.partyStream.push(party)
    this.closeModal()
  }

  selectReplace() {
    let orgKey = this.state.orgKey
    let replaceMember = this.state.replaceMember
    this.replaceMemberArea(orgKey, replaceMember)
    this.closeModal()
  }

  replaceMemberArea(orgKey, target) {
    let party = this.props.party
    if (target.memberKey && orgKey !== "friend") {
      party.swap(orgKey, target.memberKey)
    } else {
      party.addMember(orgKey, target)
    }
    this.props.partyStream.push(party)
  }

  removeMember(code, e) {
    e.preventDefault()
    let party = this.props.party
    party.removeMember(code)
    this.props.partyStream.push(party)
  }

  removeChain(code, e) {
    e.preventDefault()
    let party = this.props.party
    party.removeChain(code)
    this.props.partyStream.push(party)
  }

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
        <li className="col-xs-6 col-sm-3 col-md-3 member-list" key={code}
          ref={(div) => {
            this.addDropHandler(ReactDOM.findDOMNode(div), code)
          }}>
          <MemberCharacter
            code={code}
            member={party.memberFor(code)}
            name={l[1]}
            arcanaViewStream={this.props.arcanaViewStream}
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
