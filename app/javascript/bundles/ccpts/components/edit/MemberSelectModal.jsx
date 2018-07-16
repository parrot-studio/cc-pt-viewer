import React from "react"
import { Button, Modal, Label } from "react-bootstrap"

import SummaryMember from "./SummaryMember"

export default class MemberSelectModal extends React.Component {

  renderLabels() {
    const m = this.props.chainMember
    const labels = []

    if (m.canUseChainAbility()) {
      labels.push(<Label key="c" bsStyle="success">絆アビリティ使用可能</Label>)
    } else {
      labels.push(<Label key="c" bsStyle="danger">絆アビリティ使用不可</Label>)
    }

    if (m.isSameUnion()) {
      labels.push(<Label key="u" bsStyle="success">所属ボーナスあり</Label>)
    } else {
      labels.push(<Label key="u" bsStyle="warning">所属ボーナスなし</Label>)
    }

    return labels
  }

  renderModal() {
    return (
      <Modal
        show={this.props.showModal}
        onHide={this.props.closeModal}>
        <Modal.Header closeButton>
          <Modal.Title>セット先選択</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="row">
            <div className="col-sm-6 col-md-6">
              <Button
                bsStyle="primary"
                onClick={this.props.selectChain}>
                <i className="fa fa-link" /> 絆として追加する
              </Button>
              <p className="clearfix" />
              <label>絆設定後</label>
              <div className="col-sm-10 col-md-10">
                <SummaryMember
                  view="chain"
                  member={this.props.chainMember} />
              </div>
              <p className="clearfix" />
              {this.renderLabels()}
            </div>
            <div className="col-sm-6 col-md-6">
              <Button
                bsStyle="info"
                onClick={this.props.selectReplace}>
                <i className="fa fa-user" /> メンバーとして置き換える
              </Button>
              <p className="clearfix" />
              <label>置き換え後</label>
              <div className="col-sm-10 col-md-10">
                <SummaryMember
                  view="chain"
                  member={this.props.replaceMember} />
              </div>
            </div>
          </div>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.closeModal}>
            <i className="fa fa-remove" /> セットしないで閉じる
          </Button>
        </Modal.Footer>
      </Modal>
    )
  }

  render() {
    if (!this.props.chainMember || !this.props.replaceMember) {
      return null
    }
    return this.renderModal()
  }
}
