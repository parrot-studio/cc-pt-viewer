import * as _ from "lodash"
import * as React from "react"
import { Alert } from "react-bootstrap"

import Cookie from "../../lib/Cookie"
import LatestInfo from "../../model/LatestInfo"

interface LatestInfoAreaProps {
  latestInfo: LatestInfo
}

interface LatestInfoAreaState {
  visible: boolean
}

export default class LatestInfoArea extends React.Component<LatestInfoAreaProps, LatestInfoAreaState> {

  private ver: string = ""

  constructor(props: LatestInfoAreaProps) {
    super(props)

    this.ver = String(this.props.latestInfo.version)

    this.state = {
      visible: true
    }
  }

  public render(): JSX.Element | null {
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
          <Alert
            bsStyle="info"
            closeLabel={"&times; Close"}
            onDismiss={this.handleAlertDismiss.bind(this)}
          >
            <p>
              <i className="fa fa-info-circle" /> {`更新：${info.body} (${info.date})`}
            </p>
          </Alert>
        </div>
      </div>
    )
  }

  private handleAlertDismiss(): void {
    this.setState({ visible: false })
  }

  private isShowLatestInfo(): boolean {
    if (_.isEmpty(this.ver)) {
      return false
    }

    let showed = ""
    try {
      showed = String(Cookie.valueFor("latest-info")) || ""
    } catch (e) {
      showed = ""
    }

    if (_.isEmpty(showed)) {
      return true
    }

    return (this.ver === showed ? false : true)
  }
}
