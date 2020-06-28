import * as React from "react"
import { Button, ButtonToolbar } from "react-bootstrap"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faCloud, faCheck, faEdit } from "@fortawesome/free-solid-svg-icons"

import Party from "../../model/Party"

import RequestFormModal from "../concerns/RequestFormModal"

import EditHelpModal from "./EditHelpModal"
import MemberShareModal from "./MemberShareModal"

interface MemberControlAreaProps {
  party: Party
  appPath: string
  aboutPath: string
  editMode: boolean
  switchEditMode(): void
}

interface MemberControlAreaState {
  showShareModal: boolean
  showHelpModal: boolean
  showRequestModal: boolean
}

export default class MemberControlArea extends React.Component<MemberControlAreaProps, MemberControlAreaState> {

  constructor(props: Readonly<MemberControlAreaProps>) {
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

  public render(): JSX.Element {
    return (
      <div className="hidden-xs">
        <div className="row">
          <div className="col-sm-12 col-md-12">
            <ButtonToolbar>
              {this.renderModeButton()}
              <Button
                bsStyle="info"
                className="act-btn"
                onClick={this.openShareModal.bind(this)}
              >
                <FontAwesomeIcon icon={faCloud} /> 共有
              </Button>
              <Button
                bsStyle="link"
                className="act-btn"
                onClick={this.openHelpModal.bind(this)}
              >
                使い方
              </Button>
              <Button
                bsStyle="link"
                className="act-btn"
                onClick={this.openRequestModal.bind(this)}
              >
                管理者への要望・情報提供
              </Button>
            </ButtonToolbar>
          </div>

          <RequestFormModal
            showModal={this.state.showRequestModal}
            closeModal={this.closeRequestModal}
          />
          <EditHelpModal
            aboutPath={this.props.aboutPath}
            showModal={this.state.showHelpModal}
            closeModal={this.closeHelpModal}
          />
          <MemberShareModal
            appPath={this.props.appPath}
            party={this.props.party}
            showModal={this.state.showShareModal}
            closeModal={this.closeShareModal}
          />
        </div>
      </div>
    )
  }

  private openShareModal(): void {
    this.setState({ showShareModal: true })
  }

  private closeShareModal(): void {
    this.setState({ showShareModal: false })
  }

  private openHelpModal(): void {
    this.setState({ showHelpModal: true })
  }

  private closeHelpModal(): void {
    this.setState({ showHelpModal: false })
  }

  private openRequestModal() {
    this.setState({ showRequestModal: true })
  }

  private closeRequestModal(): void {
    this.setState({ showRequestModal: false })
  }

  private renderModeButton(): JSX.Element | null {
    if (this.props.editMode) {
      return (
        <Button
          bsStyle="primary"
          className="act-btn"
          onClick={this.props.switchEditMode}
        >
          <FontAwesomeIcon icon={faCheck} /> 編集終了
        </Button>
      )
    } else {
      return (
        <Button
          bsStyle="primary"
          className="act-btn"
          onClick={this.props.switchEditMode}
        >
          <FontAwesomeIcon icon={faEdit} /> 編集する
        </Button>
      )
    }
  }
}
