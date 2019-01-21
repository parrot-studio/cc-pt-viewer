import * as _ from "lodash"
import * as React from "react"

import Query from "../../model/Query"
import LatestInfo from "../../model/LatestInfo"
import MessageStream from "../../lib/MessageStream"
import Browser from "../../lib/BrowserProxy"

import LatestInfoArea from "../concerns/LatestInfoArea"

import DatabaseAreaHeader from "./DatabaseAreaHeader"
import DatabaseTableArea from "./DatabaseTableArea"

interface DatabaseModeViewProps {
  appPath: string
  pagerSize: number
  latestInfo: LatestInfo | null
  firstQuery: Query | null
  firstResults: any
  switchConditionMode(): void
}

interface DatabaseModeViewState {
  lastQueryCode: string | null
  showHeader: boolean
}

export default class DatabaseModeView extends React.Component<DatabaseModeViewProps, DatabaseModeViewState> {

  constructor(props) {
    super(props)

    let showHeader = true
    if (this.props.firstQuery && !this.props.firstQuery.isEmpty()) {
      showHeader = false
    }

    this.state = {
      lastQueryCode: null,
      showHeader
    }

    MessageStream.queryStream.onValue((q) => {
      const code = Query.create(q).encode()
      this.setState({ lastQueryCode: code }, () => {
        MessageStream.historyStream.push("")
      })
    })

    MessageStream.historyStream.onValue((target) => {
      let uri = ""
      if (!_.isEmpty(target)) {
        uri = target
      } else {
        const code = this.state.lastQueryCode
        if (_.isEmpty(code)) {
          uri = "db"
        } else {
          uri = `db?${code}`
        }
      }
      Browser.changeUrl(`/${uri}`)
    })
  }

  public render(): JSX.Element {
    return (
      <div>
        {this.renderHeadInfo()}
        <DatabaseAreaHeader
          appPath={this.props.appPath}
          switchConditionMode={this.props.switchConditionMode}
        />
        <DatabaseTableArea
          pagerSize={this.props.pagerSize}
          firstResults={this.props.firstResults}
        />
      </div>
    )
  }

  private renderHeadInfo(): JSX.Element | null {
    if (!this.state.showHeader) {
      return null
    }

    return <LatestInfoArea latestInfo={this.props.latestInfo} />
  }
}
