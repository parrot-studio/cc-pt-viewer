class MemberAreaHeader extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      showResetModal: false,
      showStoreModal: false,
      parties: Parties.parties
    }

    Parties.notifyStream.onValue((parties) => {
      this.setState({parties: parties})
    })

    this.closeResetModal = this.closeResetModal.bind(this)
    this.closeStoreModal = this.closeStoreModal.bind(this)
    this.resetParty = this.resetParty.bind(this)
  }

  openResetModal() {
    this.setState({showResetModal: true})
  }

  closeResetModal() {
    this.setState({showResetModal: false})
  }

  openStoreModal() {
    this.setState({showStoreModal: true})
  }

  closeStoreModal() {
    this.setState({showStoreModal: false})
  }

  resetParty() {
    this.props.partyStream.push(Party.create())
  }

  reloadLastMembers() {
    this.reloadMembers(Parties.lastParty)
  }

  reloadMembers(code) {
    this.props.memberCodeStream.push(code)
  }

  renderParties() {
    let ps = this.state.parties
    return _.map(_.zip(ps, _.range(ps.length)), (p) => {
      let pt = p[0]
      return (
        <MenuItem key={p[1]} onClick={this.reloadMembers.bind(this, pt.code)}>
          {pt.comment}
        </MenuItem>
      )
    })
  }

  render() {
    return (
      <div className="row" id="edit-title">
        <div className="col-md-12 col-sm-12 hidden-xs">
          <ButtonToolbar className="pull-right">
            <Button
              bsStyle="danger"
              onClick={this.openResetModal.bind(this)}>
              <i className="fa fa-trash"/> リセット
            </Button>
            <Button
              bsStyle="primary"
              onClick={this.openStoreModal.bind(this)}>
              <i className="fa fa-save-file"/> 保存
            </Button>
            <DropdownButton bsStyle="info" title="呼び出し" id="load-members">
              <MenuItem onClick={this.reloadLastMembers.bind(this)}>
                <i className="fa fa-export"/> 最後に作ったパーティー構成
              </MenuItem>
              <MenuItem divider />
              {this.renderParties()}
            </DropdownButton>
          </ButtonToolbar>
          <h2>パーティー編集</h2>

          <MemberResetModal
            showModal={this.state.showResetModal}
            closeModal={this.closeResetModal}
            resetParty={this.resetParty}/>
          <MemberStoreModal
            party={this.props.party}
            showModal={this.state.showStoreModal}
            closeModal={this.closeStoreModal}/>
        </div>
      </div>
    )
  }
}