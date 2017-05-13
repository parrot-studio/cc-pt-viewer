import _ from "lodash"

import QueryLogs from "../../model/QueryLogs"
import TwitterShareModal from "../concerns/TwitterShareModal"

export default class DatabaseShareModal extends TwitterShareModal {

  shareUrl() {
    const query = QueryLogs.lastQuery
    const qs = (query ? query.encode() : "")
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
