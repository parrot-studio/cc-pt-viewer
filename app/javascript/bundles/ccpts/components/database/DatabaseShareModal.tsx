import * as _ from "lodash"

import QueryRepository from "../../model/QueryRepository"

import { TwitterShareModal, TwitterShareModalProps } from "../concerns/TwitterShareModal"

interface DatabaseShareModalProps extends TwitterShareModalProps {
  appPath: string
}

export default class DatabaseShareModal extends TwitterShareModal<DatabaseShareModalProps> {
  public render(): JSX.Element | null {
    return this.renderModal("検索結果")
  }

  protected shareUrl(): string {
    const query = QueryRepository.lastQuery
    const qs = (query ? query.encode() : "")
    let path = `${this.props.appPath}db`
    if (!_.isEmpty(qs)) {
      path += `?${qs}`
    }
    return path
  }
}
