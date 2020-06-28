import * as _ from "lodash"
import * as React from "react"
import { Button, ButtonToolbar, DropdownButton, MenuItem } from "react-bootstrap"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faTrash, faSave, faFileDownload } from "@fortawesome/free-solid-svg-icons"

import Party from "../../model/Party"
import PartyRepositroy, { PartyLog } from "../../model/PartyRepositroy"
import MessageStream from "../../lib/MessageStream"

import MemberResetModal from "./MemberResetModal"
import MemberStoreModal from "./MemberStoreModal"

interface MemberAreaHeaderProps {
  party: Party
}

interface MemberAreaHeaderState {
  showResetModal: boolean
  showStoreModal: boolean
  parties: PartyLog[]
}

export default class MemberAreaHeader extends React.Component<MemberAreaHeaderProps, MemberAreaHeaderState> {

  constructor(props: Readonly<MemberAreaHeaderProps>) {
    super(props)

    this.state = {
      showResetModal: false,
      showStoreModal: false,
      parties: PartyRepositroy.parties
    }

    MessageStream.partiesStream.onValue((parties) => {
      this.setState({ parties })
    })

    this.closeResetModal = this.closeResetModal.bind(this)
    this.closeStoreModal = this.closeStoreModal.bind(this)
    this.resetParty = this.resetParty.bind(this)
  }

  public render(): JSX.Element {
    return (
      <div className="row" id="edit-title">
        <div className="col-md-12 col-sm-12 hidden-xs">
          <ButtonToolbar className="pull-right">
            <Button
              bsStyle="danger"
              onClick={this.openResetModal.bind(this)}
            >
              <FontAwesomeIcon icon={faTrash} /> リセット
            </Button>
            <Button
              bsStyle="primary"
              onClick={this.openStoreModal.bind(this)}
            >
              <FontAwesomeIcon icon={faSave} /> 保存
            </Button>
            <DropdownButton bsStyle="info" title="呼び出し" id="load-members">
              <MenuItem onClick={this.reloadLastMembers.bind(this)}>
                <FontAwesomeIcon icon={faFileDownload} /> 最後に作ったパーティー構成
              </MenuItem>
              <MenuItem divider={true} />
              {this.renderParties()}
            </DropdownButton>
          </ButtonToolbar>
          <div className="pull-left">
            <h2>パーティー編集</h2>
          </div>
          <div className="pull-right">
            <label htmlFor="cost">Total Cost</label><span id="cost" className="cost-mini">{this.props.party.cost}</span>
          </div>

          <MemberResetModal
            showModal={this.state.showResetModal}
            closeModal={this.closeResetModal}
            resetParty={this.resetParty}
          />
          <MemberStoreModal
            party={this.props.party}
            showModal={this.state.showStoreModal}
            closeModal={this.closeStoreModal}
          />
        </div>
      </div>
    )
  }

  private openResetModal(): void {
    this.setState({ showResetModal: true })
  }

  private closeResetModal() {
    this.setState({ showResetModal: false })
  }

  private openStoreModal(): void {
    this.setState({ showStoreModal: true })
  }

  private closeStoreModal(): void {
    this.setState({ showStoreModal: false })
  }

  private resetParty(): void {
    MessageStream.partyStream.push(Party.create())
    MessageStream.historyStream.push("reset")
  }

  private reloadLastMembers(): void {
    this.reloadMembers(PartyRepositroy.lastParty)
  }

  private reloadMembers(code: string): void {
    MessageStream.memberCodeStream.push(code)
  }

  private renderParties(): JSX.Element[] {
    const ps = this.state.parties

    return _.chain(_.zip(ps, _.range(ps.length)))
      .map((p) => {
        const pt = p[0]
        if (!pt) {
          return
        }
        return (
          <MenuItem key={p[1]} onClick={this.reloadMembers.bind(this, pt.code)}>
            {pt.comment}
          </MenuItem>
        )
      }).compact().value()
  }
}
