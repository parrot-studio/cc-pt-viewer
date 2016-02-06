class AppView extends React.Component {

  constructor(props) {
    super(props)

    let mode = this.props.mode
    let phoneDevice = this.props.phoneDevice
    let queryStream = new Bacon.Bus()
    let conditionStream = new Bacon.Bus()
    let resultStream = new Bacon.Bus()
    let arcanaViewStream = new Bacon.Bus()

    let pagerSize = 8
    let recentlySize = 32
    switch (mode) {
      case 'ptedit':
        pagerSize = 8
        recentlySize = 32
        break
      case 'database':
        if (phoneDevice) {
          pagerSize = 8
          recentlySize = 16
        } else {
          pagerSize = 16
          recentlySize = 32
        }
        break
    }

    QueryLogs.init()
    Favorites.init()

    let recentlyQuery = Query.create({recently: recentlySize})
    let searchStream = queryStream
      .doAction(() => this.switchMainMode())
      .map((q) => Query.create(q))
      .map((q) => (q.isEmpty() ? recentlyQuery : q))
      .flatMap((query) => Searcher.searchArcanas(query))

    conditionStream.plug(queryStream)
    resultStream.plug(searchStream)

    this.state = {
      pagerSize: pagerSize,
      queryStream: queryStream,
      conditionStream: conditionStream,
      resultStream: resultStream,
      arcanaViewStream: arcanaViewStream,
      showConditionArea: false
    }
  }

  componentDidMount() {
    $(this.refs.errorArea).hide()
    $(this.refs.conditionArea).hide()
    $("#pre-header").hide()
  }

  switchMainMode() {
    $("#search-modal").modal('hide')
    if (this.state.showConditionArea) {
      this.setState({
        showConditionArea: false
      }, () => {
        this.state.queryStream.push(QueryLogs.lastQuery.params())
        this.fadeModeArea()
      })
    }
  }

  switchConditionMode() {
    if (!this.state.showConditionArea) {
      this.setState({
        showConditionArea: true
      }, () => {
        this.fadeModeArea()
      })
    }
  }

  fadeModeArea () {
    if (this.state.showConditionArea) {
      $(this.refs.mainArea).hide()
      $(this.refs.conditionArea).fadeIn("slow")
    } else {
      $(this.refs.conditionArea).hide()
      $(this.refs.mainArea).fadeIn("slow")
    }
  }

  modeName(mode) {
    mode = (mode || this.props.mode)
    let name = ""
    switch (mode) {
      case 'ptedit':
        name = "パーティー編集モード"
        break
      case 'database':
        name = "データベースモード"
        break
    }
    return name
  }

  isShowLatestInfo(info) {
    if (!info) {
      return false
    }

    let ver = String(info.version)
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

    return (ver === showed ? false : true)
  }

  renderLatestInfo() {
    let info = this.props.latestInfo
    if (this.isShowLatestInfo(info)) {
      Cookie.set({'latest-info': info.version})
      return <LatestInfoArea latestInfo={info}/>
    } else {
      return null
    }
  }

  renderHeadInfo() {
    if (this.props.mode !== 'ptedit') {
      return this.renderLatestInfo()
    }

    let tutorial = Cookie.valueFor('tutorial')
    if (!tutorial) {
      Cookie.set({tutorial: true})
      return <EditTutorialArea/>
    } else {
      return this.renderLatestInfo()
    }
  }

  renderWarning() {
    if (this.props.mode !== 'ptedit' || !this.props.phoneDevice) {
      return null
    }
    return <DisplaySizeWarning appPath={this.props.appPath}/>
  }

  renderModeView() {
    switch (this.props.mode) {
      case 'ptedit':
        return <EditModeView
          phoneDevice={this.props.phoneDevice}
          appPath={this.props.appPath}
          aboutPath={this.props.aboutPath}
          ptm={this.props.ptm}
          ptver={this.props.ptver}
          switchConditionMode={this.switchConditionMode.bind(this)}
          pagerSize={this.state.pagerSize}
          conditionStream={this.state.conditionStream}
          queryStream={this.state.queryStream}
          resultStream={this.state.resultStream}
          arcanaViewStream={this.state.arcanaViewStream}/>
        break
      case 'database':
        return <DatabaseModeView
          phoneDevice={this.props.phoneDevice}
          appPath={this.props.appPath}
          switchConditionMode={this.switchConditionMode.bind(this)}
          pagerSize={this.state.pagerSize}
          conditionStream={this.state.conditionStream}
          queryStream={this.state.queryStream}
          resultStream={this.state.resultStream}
          arcanaViewStream={this.state.arcanaViewStream}/>
        break
    }
  }

  renderNav() {
    if (this.props.phoneDevice) {
      return null
    }

    let rootPath = this.props.appPath
    let dbPath = this.props.appPath + 'db'
    return (
      <Nav bsStyle="tabs" justified activeKey={this.props.mode}>
        <NavItem eventKey="ptedit" href={rootPath}>{this.modeName("ptedit")}</NavItem>
        <NavItem eventKey="database" href={dbPath}>{this.modeName("database")}</NavItem>
      </Nav>
    )
  }

  renderHeader() {
    return (
      <div className="header">
        <h1>
          Get our light!
          <span className="hidden-sm hidden-md hidden-lg"><br/></span>
          &nbsp;
          <small className="text-muted lead">チェンクロ パーティーシミュレーター</small>
        </h1>
        <p className="pull-right">
          <small className="text-muted">【{this.modeName()}】</small>
        </p>
      </div>
    )
  }

  renderErrorArea() {
    return (
      <div id="error-area" ref="errorArea">
        <div className="row">
          <div className="col-xs-12 col-md-12 col-sm-12">
            <Alert bsStyle="danger">
              <p>
                <strong>データの取得に失敗しました。</strong>
                <a href={window.location.href} className="alert-link">リロードする</a>か、もう一度検索してください。
              </p>
            </Alert>
          </div>
        </div>
      </div>
    )
  }

  render() {
    return (
      <div>
        {this.renderNav()}
        {this.renderHeader()}
        {this.renderErrorArea()}
        {this.renderWarning()}
        {this.renderHeadInfo()}
        <div id="main-area" ref="mainArea">
          {this.renderModeView()}
        </div>
        <div id="condition-area" ref="conditionArea">
          <ConditionView
            switchMainMode={this.switchMainMode.bind(this)}
            conditionStream={this.state.conditionStream}
            queryStream={this.state.queryStream}
            resultStream={this.state.resultStream}/>
        </div>
        <ArcanaView arcanaViewStream={this.state.arcanaViewStream}/>
      </div>
    )
  }
}
