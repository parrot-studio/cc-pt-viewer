class DatabaseShareModal extends TwitterShareModal {

  shareUrl() {
    let query = QueryLogs.lastQuery
    let qs = (query ? query.encode() : "")
    let path = `${this.props.appPath}db`
    if (!_.isEmpty(qs)) {
      path += `?${qs}`
    }
    return path
  }

  render() {
    return this.renderModal("検索結果")
  }
}
