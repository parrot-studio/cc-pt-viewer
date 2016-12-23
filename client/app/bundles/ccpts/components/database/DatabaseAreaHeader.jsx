import React from 'react'
import ReactBootstrap, { Button, ButtonGroup, ButtonToolbar } from 'react-bootstrap'

import SearchMenuButton from '../concerns/SearchMenuButton'
import RequestFormModal from '../concerns/RequestFormModal'
import DatabaseShareModal from './DatabaseShareModal'

export default class DatabaseAreaHeader extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      showShareModal: false,
      showRequestModal: false
    }

    this.closeShareModal = this.closeShareModal.bind(this)
    this.closeRequestModal = this.closeRequestModal.bind(this)
  }

  openShareModal() {
    this.setState({showShareModal: true})
  }

  closeShareModal() {
    this.setState({showShareModal: false})
  }

  openRequestModal() {
    this.setState({showRequestModal: true})
  }

  closeRequestModal() {
    this.setState({showRequestModal: false})
  }

  renderRequest() {
    if (this.props.phoneDevice) {
      return null
    }
    return (
      <Button
        bsStyle="link"
        onClick={this.openRequestModal.bind(this)}>
        管理者への要望
      </Button>
    )
  }

  render() {
    return (
      <div className="row">
        <div className="col-sm-12 col-md-12">
          <ButtonToolbar>
            <ButtonGroup>
              <Button
                bsStyle="primary"
                onClick={this.props.switchConditionMode}>
                <i className="fa fa-search"/> 検索
              </Button>
              <SearchMenuButton
                phoneDevice={this.props.phoneDevice}
                queryStream={this.props.queryStream}
                resultStream={this.props.resultStream}/>
            </ButtonGroup>
            <Button
              bsStyle="info"
              onClick={this.openShareModal.bind(this)}>
              <i className="fa fa-cloud"/> 共有
            </Button>
            {this.renderRequest()}
          </ButtonToolbar>

          <DatabaseShareModal
            appPath={this.props.appPath}
            phoneDevice={this.props.phoneDevice}
            showModal={this.state.showShareModal}
            closeModal={this.closeShareModal}/>
          <RequestFormModal
            showModal={this.state.showRequestModal}
            closeModal={this.closeRequestModal}/>
        </div>
      </div>
    )
  }
}
