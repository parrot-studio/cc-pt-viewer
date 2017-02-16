import _ from 'lodash'
import React from 'react'

import Query from '../../model/Query'
import Searcher from '../../lib/Searcher'

import DatabaseAreaHeader from './DatabaseAreaHeader'
import DatabaseTableArea from './DatabaseTableArea'

export default class DatabaseModeView extends React.Component {

  constructor(props) {
    super(props)

    this.state = {
      lastQueryCode: null
    }

    this.props.queryStream.onValue((q) => {
      const code = Query.create(q).encode()
      this.setState({lastQueryCode: code}, () => {
        this.props.historyStream.push('')
      })
    })

    this.props.historyStream.onValue((target) => {
      let uri = ''
      if (!_.isEmpty(target) ) {
        uri = target
      } else {
        const code = this.state.lastQueryCode
        if (_.isEmpty(code)) {
          uri = 'db'
        } else {
          uri = `db?${code}`
        }
      }
      history.replaceState('', '', `/${uri}`)
    })
  }

  componentDidMount() {
    const code = this.props.code
    if (code) {
      Searcher.searchCodes([code]).onValue((result) => {
        const a = result.arcanas[0]
        if (a) {
          this.props.queryStream.push({name: a.name})
          this.props.arcanaViewStream.push(a)
        }
      })
    }
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
