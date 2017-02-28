import React from 'react'

import MessageStream from '../../model/MessageStream'

import ArcanaViewModal from './ArcanaViewModal'
import WikiLinkModal from './WikiLinkModal'

export default class ArcanaView extends React.Component {

  constructor(props) {
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

  openArcanaViewModal(a) {
    if (!a){
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

  closeArcanaViewModal() {
    this.changeTitle()
    MessageStream.historyStream.push('')
    this.setState({
      viewArcana: null,
      showArcanaViewModal: false,
      showWikiModal: false
    })
  }

  openWikiModal() {
    this.setState({
      showArcanaViewModal: false,
      showWikiModal: true
    })
  }

  closeWikiModal() {
    this.changeTitle()
    MessageStream.historyStream.push('')
    this.setState({
      viewArcana: null,
      showArcanaViewModal: false,
      showWikiModal: false
    })
  }

  changeTitle(title) {
    document.title = (title || this.props.originTitle)
  }

  render () {
    return (
      <div>
        <ArcanaViewModal
          showModal={this.state.showArcanaViewModal}
          viewArcana={this.state.viewArcana}
          closeModal={this.closeArcanaViewModal.bind(this)}
          openWikiModal={this.openWikiModal.bind(this)}/>
        <WikiLinkModal
          showModal={this.state.showWikiModal}
          viewArcana={this.state.viewArcana}
          closeModal={this.closeWikiModal.bind(this)}/>
      </div>
    )
  }
}
