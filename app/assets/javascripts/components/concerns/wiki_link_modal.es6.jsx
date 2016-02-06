class WikiLinkModal extends React.Component {

  renderLinkButton() {
    let a = this.props.viewArcana
    let btnName = ""
    if (_.isEmpty(a.wikiName)) {
      btnName = "Wikiで最新情報を確認する"
    } else {
      btnName = `Wikiで ${a.wikiName} を確認する`
    }

    return (
      <a id="outside-link" href={a.wikiUrl}
        className="btn btn-primary"
        target="_blank"
        onClick={this.props.closeModal}>
        {btnName}
      </a>
    )
  }

  renderWikiLink() {
    return (
      <Modal
        show={this.props.showModal}
        onHide={this.props.closeModal}>
        <Modal.Header closeButton>
          <Modal.Title>外部リンク確認</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <p>
            リンク先は外部サイト（チェインクロニクル攻略・交流Wiki）になります。<br/>
            よろしければ以下のボタンを押してください。
          </p>
          <p>
            {this.renderLinkButton()}
          </p>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.closeModal}>
            <i className="fa fa-remove"/> 閉じる
          </Button>
        </Modal.Footer>
      </Modal>
    )
  }

  render() {
    if (this.props.viewArcana) {
      return this.renderWikiLink()
    } else {
      return null
    }
  }
}
