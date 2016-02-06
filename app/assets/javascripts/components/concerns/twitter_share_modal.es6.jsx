class TwitterShareModal extends React.Component {

  twitterUrl() {
    let text = `チェンクロ パーティーシミュレーター ${this.shareUrl()}`
    let url = "https://twitter.com/intent/tweet"
    url += `?text=${encodeURIComponent(text)}`
    url += "&hashtags=ccpts"
    return url
  }

  handleFocus() {
    this.refs.shareUrl.select()
  }

  renderShareForm(text) {
    if (this.props.phoneDevice) {
      return
    }
    return (
      <div className="form-group">
        <label>共有用URL</label>
        <input type="text"
          className="form-control"
          ref="shareUrl"
          defaultValue={this.shareUrl()}
          onFocus={this.handleFocus.bind(this)}/>
        <span className="help-block small">
          このURLでアクセスすると、{text}が表示されます。コピーして使ってください。
        </span>
      </div>
    )
  }

  renderModal(text) {
    return (
      <Modal
        show={this.props.showModal}
        onHide={this.props.closeModal}>
        <Modal.Header closeButton>
          <Modal.Title>{text}を共有する</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {this.renderShareForm(text)}
          <div className="form-group">
            <p>
              <a
                href={this.twitterUrl()}
                className="btn btn-primary"
                role="button"
                id="twitter-share">Twitterで共有する</a>
              <br/>
              <span className="help-block small">
                {text}をTwitterに投稿できます。自由にコメントを追加できます。<br/>
                ※Twitterのサイトを開きます
              </span>
            </p>
          </div>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.closeModal}>
            <i className="fa fa-remove"/> 閉じる
          </Button>
        </Modal.Footer>
      </Modal>
    )
  }
}
