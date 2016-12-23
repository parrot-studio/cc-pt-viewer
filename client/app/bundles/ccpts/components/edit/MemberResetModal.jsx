import React from 'react'
import ReactBootstrap, { Button, Modal } from 'react-bootstrap'

export default class MemberResetModal extends React.Component {

  resetParty() {
    this.props.resetParty()
    this.props.closeModal()
  }

  render() {
    return (
      <Modal
        show={this.props.showModal}
        onHide={this.props.closeModal}>
        <Modal.Header closeButton>
          <Modal.Title>パーティーリセット</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <p>
            現在のパーティーをリセットして、メンバーを削除します。<br/>
            よろしければ以下のボタンを押してください。
          </p>
          <p>
            <Button
              bsStyle="danger"
              onClick={this.resetParty.bind(this)}>
              <i className="fa fa-trash"/> リセット
            </Button>
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
