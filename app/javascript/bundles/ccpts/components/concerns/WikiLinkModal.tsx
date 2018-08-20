import * as _ from "lodash"

import * as React from "react"
import { Modal, Button } from "react-bootstrap"

import Arcana from "../../model/Arcana"

interface WikiLinkModalProps {
  viewArcana: Arcana | null
  showModal: boolean
  closeModal(): void
}

export default class WikiLinkModal extends React.Component<WikiLinkModalProps> {
  public render(): JSX.Element | null {
    if (this.props.viewArcana) {
      return this.renderWikiLink()
    } else {
      return null
    }
  }

  private renderLinkButton(): JSX.Element | null {
    const a = this.props.viewArcana
    if (!a) {
      return null
    }

    let btnName = ""
    if (_.isEmpty(a.wikiLinkName)) {
      btnName = "Wikiで最新情報を確認する"
    } else {
      btnName = `Wikiで ${a.wikiLinkName} を確認する`
    }

    return (
      <a
        id="outside-link"
        href={a.wikiUrl}
        className="btn btn-primary"
        target="_blank"
        rel="noopener noreferrer"
        onClick={this.props.closeModal}
      >
        {btnName}
      </a>
    )
  }

  private renderWikiLink(): JSX.Element {
    return (
      <Modal
        show={this.props.showModal}
        onHide={this.props.closeModal}
      >
        <Modal.Header closeButton={true}>
          <Modal.Title>外部リンク確認</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <p>
            リンク先は外部サイト（チェインクロニクル攻略・交流Wiki）になります。<br />
            よろしければ以下のボタンを押してください。
          </p>
          <p>
            {this.renderLinkButton()}
          </p>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.closeModal}>
            <i className="fa fa-remove" /> 閉じる
          </Button>
        </Modal.Footer>
      </Modal >
    )
  }
}
