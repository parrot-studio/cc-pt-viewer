import * as React from "react"
import { Modal, Button } from "react-bootstrap"

export interface TwitterShareModalProps {
  phoneDevice: boolean
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
          {this.renderShareForm(text)}
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
            <i className="fa fa-remove" /> 閉じる
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

  private renderShareForm(text): JSX.Element | null {
    if (this.props.phoneDevice) {
      return null
    }
    return (
      <div className="form-group">
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
    )
  }
}
