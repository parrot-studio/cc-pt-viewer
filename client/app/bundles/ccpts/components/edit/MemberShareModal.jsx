import TwitterShareModal from "../concerns/TwitterShareModal"

export default class MemberShareModal extends TwitterShareModal {

  shareUrl() {
    if (!this.props.party) {
      return ""
    }
    return `${this.props.appPath}${this.props.party.createCode()}`
  }

  render() {
    return this.renderModal("パーティー")
  }
}
