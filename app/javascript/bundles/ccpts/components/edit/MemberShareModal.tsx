import Party from "../../model/Party"

import { TwitterShareModal, TwitterShareModalProps } from "../concerns/TwitterShareModal"

interface MemberShareModalProps extends TwitterShareModalProps {
  party: Party
  appPath: string
}

export default class MemberShareModal extends TwitterShareModal<MemberShareModalProps> {
  public render(): JSX.Element | null {
    return this.renderModal("パーティー")
  }

  protected shareUrl(): string {
    if (!this.props.party) {
      return ""
    }
    return `${this.props.appPath}${this.props.party.createCode()}`
  }
}
