import * as React from "react"
import { Button, ButtonGroup, ButtonToolbar } from "react-bootstrap"

import SearchMenuButton from "../concerns/SearchMenuButton"
import RequestFormModal from "../concerns/RequestFormModal"
import DatabaseShareModal from "./DatabaseShareModal"

interface DatabaseAreaHeaderProps {
  appPath: string
  phoneDevice: boolean
  switchConditionMode(): void
}

interface DatabaseAreaHeaderState {
  showShareModal: boolean
  showRequestModal: boolean
}

export default class DatabaseAreaHeader extends React.Component<DatabaseAreaHeaderProps, DatabaseAreaHeaderState> {

  constructor(props) {
    super(props)
    this.state = {
      showShareModal: false,
      showRequestModal: false
    }

    this.closeShareModal = this.closeShareModal.bind(this)
    this.closeRequestModal = this.closeRequestModal.bind(this)
  }

  public render(): JSX.Element {
    return (
      <div className="row">
        <div className="col-sm-12 col-md-12">
          <ButtonToolbar>
            <ButtonGroup>
              <Button
                bsStyle="primary"
                onClick={this.props.switchConditionMode}
              >
                <i className="fa fa-search" /> 検索
              </Button>
              <SearchMenuButton phoneDevice={this.props.phoneDevice} />
            </ButtonGroup>
            <Button
              bsStyle="info"
              onClick={this.openShareModal.bind(this)}
            >
              <i className="fa fa-cloud" /> 共有
            </Button>
            {this.renderRequest()}
          </ButtonToolbar>

          <DatabaseShareModal
            appPath={this.props.appPath}
            phoneDevice={this.props.phoneDevice}
            showModal={this.state.showShareModal}
            closeModal={this.closeShareModal}
          />
          <RequestFormModal
            showModal={this.state.showRequestModal}
            closeModal={this.closeRequestModal}
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

  private openRequestModal(): void {
    this.setState({ showRequestModal: true })
  }

  private closeRequestModal(): void {
    this.setState({ showRequestModal: false })
  }

  private renderRequest(): JSX.Element | null {
    if (this.props.phoneDevice) {
      return null
    }

    return (
      <Button
        bsStyle="link"
        onClick={this.openRequestModal.bind(this)}
      >
        管理者への要望
      </Button>
    )
  }
}
