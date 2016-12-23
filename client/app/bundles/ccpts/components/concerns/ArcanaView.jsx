import React from 'react'

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

    this.props.arcanaViewStream.onValue((a) => {
      this.openArcanaViewModal(a)
    })
  }

  openArcanaViewModal(a) {
    this.setState({
      viewArcana: a,
      showArcanaViewModal: true,
      showWikiModal: false
    })
  }

  closeArcanaViewModal() {
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
    this.setState({
      viewArcana: null,
      showArcanaViewModal: false,
      showWikiModal: false
    })
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
