import React from 'react'

import Query from '../../model/Query'

import DatabaseAreaHeader from './DatabaseAreaHeader'
import DatabaseTableArea from './DatabaseTableArea'

export default class DatabaseModeView extends React.Component {

  componentDidMount() {
    this.props.queryStream.push(Query.parse().params())
  }

  render() {
    return (
      <div>
        <DatabaseAreaHeader
          phoneDevice={this.props.phoneDevice}
          appPath={this.props.appPath}
          switchConditionMode={this.props.switchConditionMode}
          conditionStream={this.props.conditionStream}
          queryStream={this.props.queryStream}
          resultStream={this.props.resultStream}/>
        <DatabaseTableArea
          phoneDevice={this.props.phoneDevice}
          pagerSize={this.props.pagerSize}
          conditionStream={this.props.conditionStream}
          queryStream={this.props.queryStream}
          resultStream={this.props.resultStream}
          arcanaViewStream={this.props.arcanaViewStream}/>
      </div>
    )
  }
}
