import * as React from "react"

import Arcana from "../../model/Arcana"
import MessageStream from "../../lib/MessageStream"

import ArcanaViewModal from "./ArcanaViewModal"
import WikiLinkModal from "./WikiLinkModal"

interface ArcanaViewProps {
  phoneDevice: boolean
  originTitle: string
}

interface ArcanaViewState {
  viewArcana: Arcana | null
  showArcanaViewModal: boolean
  showWikiModal: boolean
}

export default class ArcanaView extends React.Component<ArcanaViewProps, ArcanaViewState> {

  constructor(props: ArcanaViewProps) {
    super(props)

    this.state = {
      viewArcana: null,
      showArcanaViewModal: false,
      showWikiModal: false
    }

    MessageStream.arcanaViewStream.onValue((a) => {
      this.openArcanaViewModal(a)
    })
  }

  public render(): JSX.Element {
    return (
      <div>
        <ArcanaViewModal
          showModal={this.state.showArcanaViewModal}
          viewArcana={this.state.viewArcana}
          phoneDevice={this.props.phoneDevice}
          closeModal={this.closeArcanaViewModal.bind(this)}
          openWikiModal={this.openWikiModal.bind(this)}
        />
        <WikiLinkModal
          showModal={this.state.showWikiModal}
          viewArcana={this.state.viewArcana}
          closeModal={this.closeWikiModal.bind(this)}
        />
      </div>
    )
  }

  private openArcanaViewModal(a: Arcana | null): void {
    if (!a) {
      return
    }
    const uri = `data/${a.jobCode}/${a.wikiLinkName}`
    MessageStream.historyStream.push(uri)
    const title = `${a.wikiLinkName} : Get our light! - チェンクロ パーティーシミュレーター`
    this.changeTitle(title)
    this.setState({
      viewArcana: a,
      showArcanaViewModal: true,
      showWikiModal: false
    })
  }

  private closeArcanaViewModal(): void {
    this.changeTitle(null)
    MessageStream.historyStream.push("")
    this.setState({
      viewArcana: null,
      showArcanaViewModal: false,
      showWikiModal: false
    })
  }

  private openWikiModal(): void {
    this.setState({
      showArcanaViewModal: false,
      showWikiModal: true
    })
  }

  private closeWikiModal(): void {
    this.changeTitle(null)
    MessageStream.historyStream.push("")
    this.setState({
      viewArcana: null,
      showArcanaViewModal: false,
      showWikiModal: false
    })
  }

  private changeTitle(title: string | null): void {
    document.title = (title || this.props.originTitle)
  }
}
