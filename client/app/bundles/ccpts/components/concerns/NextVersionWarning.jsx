import React from 'react'
import ReactBootstrap, { Alert } from 'react-bootstrap'

export default class NextVersionWarning extends React.Component {

  constructor(props) {
    super(props)
    this.state = {visible: true}
  }

  handleAlertDismiss() {
    this.setState({visible: false})
  }

  render() {
    if (!this.state.visible){
      return null
    }

    let cc3Path = `${this.props.appPath}cc3`
    return (
      <div className="row">
        <div className="col-xs-12 col-sm-12 col-md-12">
          <Alert bsStyle="warning"
            closeLabel={"&times; Close"}
            onDismiss={this.handleAlertDismiss.bind(this)}>
            <p>
              <i className="fa fa-info-circle"/> おしらせ：2016/11/24に実装された第3部への対応を進めております。<a href={`${cc3Path}`}>詳しくはこちらで</a>
            </p>
          </Alert>
        </div>
      </div>
    )
  }
}
