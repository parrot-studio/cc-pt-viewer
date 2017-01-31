import React from 'react'
import { Alert } from 'react-bootstrap'

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

    const cc3Path = `${this.props.appPath}cc3`
    return (
      <div className="row">
        <div className="col-xs-12 col-sm-12 col-md-12">
          <Alert bsStyle="warning"
            closeLabel={"&times; Close"}
            onDismiss={this.handleAlertDismiss.bind(this)}>
            <p>
              <i className="fa fa-info-circle"/> おしらせ：第3部への対応を進めております。
              <a href={`${cc3Path}`}>詳しくはこちらで</a>
              <strong>（2017/1/31更新）</strong>
            </p>
          </Alert>
        </div>
      </div>
    )
  }
}
