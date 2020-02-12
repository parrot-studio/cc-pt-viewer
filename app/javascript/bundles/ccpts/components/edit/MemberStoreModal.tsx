import * as _ from "lodash"
import * as React from "react"
import { Button, Modal } from "react-bootstrap"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faSave, faTimes } from "@fortawesome/free-solid-svg-icons"

import Party from "../../model/Party"
import PartyRepositroy from "../../model/PartyRepositroy"

interface MemberStoreModalProps {
  party: Party
  showModal: boolean
  closeModal(): void
}

export default class MemberStoreModal extends React.Component<MemberStoreModalProps> {

  private ptname: HTMLInputElement | null = null

  public render(): JSX.Element {
    return (
      <Modal
        show={this.props.showModal}
        onHide={this.props.closeModal}
      >
        <Modal.Header closeButton={true}>
          <Modal.Title>パーティーを保存</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <p>
            現在のパーティーを保存します。<br />
            名前を入力し、以下のボタンを押してください。
          </p>
          <div className="form-group" id="store-pt-form">
            <label htmlFor="member-comment">パーティーの名前（10文字まで）</label>
            <input
              type="text"
              ref={(d) => { this.ptname = d }}
              className="form-control"
              maxLength={10}
              placeholder="例：ストーリー用PT"
            />
            <span className="help-block small">
              保存されたパーティーは古いものから消えていきます。<br />
              残したい場合、呼び出して再度保存してください。
            </span>
          </div>
          <p>
            <button className="btn btn-primary" onClick={this.storeParty.bind(this)}>
              <FontAwesomeIcon icon={faSave} /> 保存
            </button>
          </p>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.closeModal}>
            <FontAwesomeIcon icon={faTimes} /> 閉じる
          </Button>
        </Modal.Footer>
      </Modal>
    )
  }

  private storeParty(): void {
    if (!this.ptname || _.isEmpty(this.ptname.value)) {
      return
    }
    PartyRepositroy.addParty(this.props.party, this.ptname.value)
    this.props.closeModal()
  }
}
