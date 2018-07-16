import _ from "lodash"
import React from "react"
import { Alert } from "react-bootstrap"

import { Cookie } from "../../lib/Cookie"

export default class LatestInfoArea extends React.Component {

  constructor(props) {
    super(props)

    this.ver = this.props.latestInfo.version

    this.state = {
      visible: true
    }
  }

  handleAlertDismiss() {
    this.setState({ visible: false })
  }

  isShowLatestInfo() {
    const ver = String(this.ver)
    if (_.isEmpty(ver)) {
      return false
    }

    let showed = ""
    try {
      showed = String(Cookie.valueFor("latest-info"))
    } catch (e) {
      showed = ""
    }

    if (_.isEmpty(showed)) {
      return true
    }

    return (_.eq(ver, showed) ? false : true)
  }

  render() {
    if (!this.state.visible) {
      return null
    }

    const info = this.props.latestInfo
    if (_.isEmpty(info)) {
      return null
    }

    if (!this.isShowLatestInfo()) {
      return null
    }
    Cookie.set({ "latest-info": this.ver })

    return (
      <div className="row">
        <div className="col-xs-12 col-sm-12 col-md-12">
          <Alert bsStyle="info"
            closeLabel={"&times; Close"}
            onDismiss={this.handleAlertDismiss.bind(this)}>
            <p>
              <i className="fa fa-info-circle" /> {`更新：${info.body} (${info.date})`}
            </p>
          </Alert>
        </div>
      </div>
    )
  }
}
