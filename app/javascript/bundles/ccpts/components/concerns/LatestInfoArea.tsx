import * as React from "react"
import { Alert } from "react-bootstrap"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faInfoCircle } from "@fortawesome/free-solid-svg-icons"

import LatestInfo from "../../model/LatestInfo"
import Cookie from "../../lib/Cookie"

interface LatestInfoAreaProps {
  latestInfo: LatestInfo | null
}

interface LatestInfoAreaState {
  visible: boolean
}

export default class LatestInfoArea extends React.Component<LatestInfoAreaProps, LatestInfoAreaState> {

  private static COOKIE_NAME = "latest-info"

  constructor(props: LatestInfoAreaProps) {
    super(props)

    let visible = false
    if (this.props.latestInfo) {
      const ver = String(this.props.latestInfo.version) || ""
      const cs = {}
      cs[LatestInfoArea.COOKIE_NAME] = ver
      Cookie.set(cs)
      visible = true
    }

    this.state = {
      visible
    }
  }

  public render(): JSX.Element | null {
    if (!this.state.visible) {
      return null
    }

    const info = this.props.latestInfo
    if (!info) {
      return null
    }

    return (
      <div className="row">
        <div className="col-xs-12 col-sm-12 col-md-12">
          <Alert
            bsStyle="info"
            closeLabel={"&times; Close"}
            onDismiss={this.handleAlertDismiss.bind(this)}
          >
            <p>
              <FontAwesomeIcon icon={faInfoCircle} /> {`更新：${info.body} (${info.date})`}
            </p>
          </Alert>
        </div>
      </div>
    )
  }

  private handleAlertDismiss(): void {
    this.setState({ visible: false })
  }
}
