import React from "react"
import { Button, ButtonToolbar } from "react-bootstrap"

import RequestFormModal from "../concerns/RequestFormModal"

import EditHelpModal from "./EditHelpModal"
import MemberShareModal from "./MemberShareModal"

export default class MemberControlArea extends React.Component {

  constructor(props) {
    super(props)

    this.state = {
      showShareModal: false,
      showHelpModal: false,
      showRequestModal: false
    }

    this.closeShareModal = this.closeShareModal.bind(this)
    this.closeHelpModal = this.closeHelpModal.bind(this)
    this.closeRequestModal = this.closeRequestModal.bind(this)
  }

  openShareModal(){
    this.setState({showShareModal: true})
  }

  closeShareModal(){
    this.setState({showShareModal: false})
  }

  openHelpModal(){
    this.setState({showHelpModal: true})
  }

  closeHelpModal(){
    this.setState({showHelpModal: false})
  }

  openRequestModal(){
    this.setState({showRequestModal: true})
  }

  closeRequestModal(){
    this.setState({showRequestModal: false})
  }

  renderModeButton() {
    if (this.props.phoneDevice) {
      return null
    }

    if (this.props.editMode) {
      return (
        <Button
          bsStyle="primary"
          className="act-btn"
          onClick={this.props.switchEditMode}>
          <i className="fa fa-check"/> 編集終了
        </Button>
      )
    } else {
      return (
        <Button
          bsStyle="primary"
          className="act-btn"
          onClick={this.props.switchEditMode}>
          <i className="fa fa-edit"/> 編集する
        </Button>
      )
    }
  }

  render() {
    return (
      <div>
        <div className="row hidden-xs">
          <div className="col-sm-12 col-md-12">
            <ButtonToolbar>
              {this.renderModeButton()}
              <Button
                bsStyle="info"
                className="act-btn"
                onClick={this.openShareModal.bind(this)}>
                <i className="fa fa-cloud"/> 共有
              </Button>
              <Button
                bsStyle="link"
                className="act-btn"
                onClick={this.openHelpModal.bind(this)}>
                使い方
              </Button>
              <Button
                bsStyle="link"
                className="act-btn"
                onClick={this.openRequestModal.bind(this)}>
                管理者への要望・情報提供
              </Button>
            </ButtonToolbar>
          </div>

          <RequestFormModal
            showModal={this.state.showRequestModal}
            closeModal={this.closeRequestModal}/>
          <EditHelpModal
            aboutPath={this.props.aboutPath}
            showModal={this.state.showHelpModal}
            closeModal={this.closeHelpModal}/>
          <MemberShareModal
            phoneDevice={this.props.phoneDevice}
            appPath={this.props.appPath}
            party={this.props.party}
            showModal={this.state.showShareModal}
            closeModal={this.closeShareModal}/>
        </div>
      </div>
    )
  }
}
