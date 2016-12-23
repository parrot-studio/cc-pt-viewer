import React from 'react'

import TwitterShareModal from '../concerns/TwitterShareModal'

export default class MemberShareModal extends TwitterShareModal {

  shareUrl() {
    return `${this.props.appPath}${this.props.party.createCode()}`
  }

  render() {
    return this.renderModal("パーティー")
  }
}
