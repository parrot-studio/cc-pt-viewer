import * as React from "react"
import { Button, Modal } from "react-bootstrap"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faTrash, faTimes } from "@fortawesome/free-solid-svg-icons"

interface MemberResetModalProps {
  showModal: boolean
  resetParty(): void
  closeModal(): void
}

export default class MemberResetModal extends React.Component<MemberResetModalProps> {

  public render(): JSX.Element {
    return (
      <Modal
        show={this.props.showModal}
        onHide={this.props.closeModal}
      >
        <Modal.Header closeButton={true}>
          <Modal.Title>パーティーリセット</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <p>
            現在のパーティーをリセットして、メンバーを削除します。<br />
            よろしければ以下のボタンを押してください。
          </p>
          <p>
            <Button
              bsStyle="danger"
              onClick={this.resetParty.bind(this)}
            >
              <FontAwesomeIcon icon={faTrash} /> リセット
            </Button>
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

  private resetParty(): void {
    this.props.resetParty()
    this.props.closeModal()
  }
}
