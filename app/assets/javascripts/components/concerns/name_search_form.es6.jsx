class NameSearchForm extends React.Component {

  constructor(props) {
    super(props)

    this.state = {
      name: ""
    }

    this.nameStream = new Bacon.Bus()

    let arcanaNameStream = this.nameStream
      .delay(400).debounce(800)
      .skipDuplicates()
      .map((n) => {
        if (n.length > 1){
          return {name: n}
        } else if (n.length < 1) {
          return {}
        }
      })

    this.props.queryStream.plug(arcanaNameStream)

    this.props.conditionStream.onValue((q) => {
      this.setState({name: (q.name || "")})
    })
  }

  handleChange(e) {
    this.setState({name: e.target.value}, () => {
      this.nameStream.push(this.state.name)
    })
  }

  render() {
    return (
      <div id="name-search">
        <form className="form-horizontal">
          <div className="form-group">
            <label className="control-label col-sm-3 col-md-3" htmlFor="arcana-name">名前から検索</label>
            <div className="col-sm-6 col-md-6">
              <input type="text" className="form-control" id="arcana-name"
                value={this.state.name} placeholder="名前を入力（2文字以上）"
                onChange={this.handleChange.bind(this)}/>
            </div>
          </div>
        </form>
      </div>
    )
  }
}
