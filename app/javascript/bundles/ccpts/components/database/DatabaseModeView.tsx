import * as _ from "lodash"
import * as React from "react"
declare var history

import Query from "../../model/Query"
import MessageStream from "../../lib/MessageStream"

import DatabaseAreaHeader from "./DatabaseAreaHeader"
import DatabaseTableArea from "./DatabaseTableArea"

interface DatabaseModeViewProps {
  appPath: string
  phoneDevice: boolean
  pagerSize: number
  switchConditionMode(): void
}

interface DatabaseModeViewState {
  lastQueryCode: string | null
}

export default class DatabaseModeView extends React.Component<DatabaseModeViewProps, DatabaseModeViewState> {

  constructor(props) {
    super(props)

    this.state = {
      lastQueryCode: null
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
      history.replaceState("", "", `/${uri}`)
    })
  }

  public componentDidMount(): void {
    MessageStream.queryStream.push(Query.parse("").params())
  }

  public render(): JSX.Element {
    return (
      <div>
        <DatabaseAreaHeader
          phoneDevice={this.props.phoneDevice}
          appPath={this.props.appPath}
          switchConditionMode={this.props.switchConditionMode}
        />
        <DatabaseTableArea
          phoneDevice={this.props.phoneDevice}
          pagerSize={this.props.pagerSize}
        />
      </div>
    )
  }
}
