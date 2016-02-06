class LatestInfoArea extends React.Component {

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

    let info = this.props.latestInfo
    return (
      <div className="row">
        <div className="col-xs-12 col-sm-12 col-md-12">
          <Alert bsStyle="info"
            closeLabel={"&times; Close"}
            onDismiss={this.handleAlertDismiss.bind(this)}>
            <p>
              <i className="fa fa-info-sign"/> {`更新：${info.body} (${info.date})`}
            </p>
          </Alert>
        </div>
      </div>
    )
  }
}
