import * as React from "react"
import { Button, ButtonGroup, ButtonToolbar } from "react-bootstrap"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faSearch, faCloud } from "@fortawesome/free-solid-svg-icons"

import SearchMenuButton from "../concerns/SearchMenuButton"
import RequestFormModal from "../concerns/RequestFormModal"
import DatabaseShareModal from "./DatabaseShareModal"

interface DatabaseAreaHeaderProps {
  appPath: string
  switchConditionMode(): void
}

interface DatabaseAreaHeaderState {
  showShareModal: boolean
  showRequestModal: boolean
}

export default class DatabaseAreaHeader extends React.Component<DatabaseAreaHeaderProps, DatabaseAreaHeaderState> {

  constructor(props: Readonly<DatabaseAreaHeaderProps>) {
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
                <FontAwesomeIcon icon={faSearch} /> 検索
              </Button>
              <SearchMenuButton />
            </ButtonGroup>
            <Button
              bsStyle="info"
              onClick={this.openShareModal.bind(this)}
            >
              <FontAwesomeIcon icon={faCloud} /> 共有
            </Button>
            <Button
              bsStyle="link"
              className="hidden-xs"
              onClick={this.openRequestModal.bind(this)}
            >
              管理者への要望
            </Button>
          </ButtonToolbar>

          <DatabaseShareModal
            appPath={this.props.appPath}
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
}
