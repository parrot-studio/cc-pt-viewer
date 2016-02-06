class SourceConditions extends React.Component {

  constructor(props) {
    super(props)

    this.conditions = this.props.conditions
    this.notifier = this.props.notifier
  }

  handleCategoryChange(e) {
    this.notifier.push({sourcecategory: e.target.value})
  }

  handleSourceChange(e) {
    this.notifier.push({source: e.target.value})
  }

  renderSourceOptions() {
    let source = this.props.sourcecategory
    if (source) {
      let ss = _.map(this.conditions.sourceTypesFor(source), (s) => {
        return <option value={s[0]} key={s[0]}>{s[1]}</option>
      })
      return _.concat([<option value={""} key={""}>{"（全て）"}</option>], ss)
    } else {
      return <option value={""}>{"-"}</option>
    }
  }

  render() {
    return (
      <div className="form-group">
        <div className="col-sm-4 col-md-4">
          <label htmlFor="source-category">入手先</label>
          <select id="source-category" className="form-control"
            value={this.props.sourcecategory} onChange={this.handleCategoryChange.bind(this)}>
            <option value={""}>-</option>
            <option value={"first"}>1部</option>
            <option value={"second"}>2部</option>
            <option value={"ring"}>リング系</option>
            <option value={"event"}>イベント限定</option>
            <option value={"collaboration"}>コラボ限定</option>
          </select>
        </div>
        <div className="col-sm-4 col-md-4">
          <label htmlFor="source">入手先・詳細</label>
          <select id="source" className="form-control"
            value={this.props.source} onChange={this.handleSourceChange.bind(this)}>
            {this.renderSourceOptions()}
          </select>
        </div>
      </div>
    )
  }
}
