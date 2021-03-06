import * as React from "react"
import { Modal, Button } from "react-bootstrap"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faTimes } from "@fortawesome/free-solid-svg-icons"

export interface TwitterShareModalProps {
  showModal: boolean
  closeModal(): void
}

export abstract class TwitterShareModal<T extends TwitterShareModalProps> extends React.Component<T> {

  private shareUrlForm: HTMLInputElement | null = null

  protected abstract shareUrl(): string

  protected renderModal(text: string): JSX.Element | null {
    return (
      <Modal
        show={this.props.showModal}
        onHide={this.props.closeModal}
      >
        <Modal.Header closeButton={true}>
          <Modal.Title>{text}を共有する</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="form-group hidden-xs">
            <label>共有用URL</label>
            <input
              type="text"
              className="form-control"
              ref={(d) => { this.shareUrlForm = d }}
              defaultValue={this.shareUrl()}
              onFocus={this.handleFocus.bind(this)}
            />
            <span className="help-block small">
              このURLでアクセスすると、{text}が表示されます。コピーして使ってください。
            </span>
          </div>
          <div className="form-group">
            <p>
              <a
                href={this.twitterUrl()}
                className="btn btn-primary"
                role="button"
                id="twitter-share"
              >
                Twitterで共有する
              </a>
              <br />
              <span className="help-block small">
                {text}をTwitterに投稿できます。自由にコメントを追加できます。<br />
                ※Twitterのサイトを開きます
              </span>
            </p>
          </div>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.closeModal}>
            <FontAwesomeIcon icon={faTimes} /> 閉じる
          </Button>
        </Modal.Footer>
      </Modal>
    )
  }

  private twitterUrl(): string {
    const text = `チェンクロ パーティーシミュレーター ${this.shareUrl()}`
    let url = "https://twitter.com/intent/tweet"
    url += `?text=${encodeURIComponent(text)}`
    url += "&hashtags=ccpts"
    return url
  }

  private handleFocus(): void {
    if (this.shareUrlForm) {
      this.shareUrlForm.select()
    }
  }
}
