import React from "react"
import { Button, Modal } from "react-bootstrap"

import Parties from "../../model/Parties"

export default class MemberStoreModal extends React.Component {

  storeParty() {
    const comment = this.refs.ptname.value
    const party = this.props.party
    Parties.addParty(party, comment)
    this.props.closeModal()
  }

  render() {
    return (
      <Modal
        show={this.props.showModal}
        onHide={this.props.closeModal}>
        <Modal.Header closeButton>
          <Modal.Title>パーティーを保存</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <p>
            現在のパーティーを保存します。<br/>
            名前を入力し、以下のボタンを押してください。
          </p>
          <div className="form-group" id="store-pt-form">
            <label htmlFor="member-comment">パーティーの名前（10文字まで）</label>
            <input type="text" ref="ptname" className="form-control"
              maxLength="10" placeholder="例：ストーリー用PT"/>
            <span className="help-block small">
              保存されたパーティーは古いものから消えていきます。<br/>
              残したい場合、呼び出して再度保存してください。
            </span>
          </div>
          <p>
            <button className="btn btn-primary" onClick={this.storeParty.bind(this)}>
              <i className="fa fa-save-file"/> 保存
            </button>
          </p>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.closeModal}>
            <i className="fa fa-remove"/> 閉じる
          </Button>
        </Modal.Footer>
      </Modal>
    )
  }
}
