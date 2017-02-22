import _ from 'lodash'
import React from 'react'
import { Alert } from 'react-bootstrap'

import { Cookie } from '../../lib/Cookie'
import Searcher from '../../lib/Searcher'

export default class LatestInfoArea extends React.Component {

  constructor(props) {
    super(props)

    this.state = {
      visible: true,
      info: null
    }
  }

  componentDidMount() {
    if (this.isShowLatestInfo()) {
      Searcher.loadLatestInfo().onValue((info) => {
        this.setState({info}, () => {
          Cookie.set({'latest-info': info.version})
        })
      })
    }
  }

  handleAlertDismiss() {
    this.setState({visible: false})
  }

  isShowLatestInfo() {
    const ver = String(this.props.ver)
    if (_.isEmpty(ver)) {
      return false
    }

    let showed = ""
    try {
      showed = String(Cookie.valueFor('latest-info'))
    } catch (e) {
      showed = ""
    }

    if (_.isEmpty(showed)) {
      return true
    }

    return (_.eq(ver, showed) ? false : true)
  }

  render() {
    if (!this.state.visible){
      return null
    }

    const info = this.state.info
    if (_.isEmpty(info)){
      return null
    }

    return (
      <div className="row">
        <div className="col-xs-12 col-sm-12 col-md-12">
          <Alert bsStyle="info"
            closeLabel={"&times; Close"}
            onDismiss={this.handleAlertDismiss.bind(this)}>
            <p>
              <i className="fa fa-info-circle"/> {`更新：${info.body} (${info.date})`}
            </p>
          </Alert>
        </div>
      </div>
    )
  }
}
