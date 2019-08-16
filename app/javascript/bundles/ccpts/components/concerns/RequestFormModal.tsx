import * as React from "react"
import { Modal, Button, ButtonToolbar } from "react-bootstrap"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faTimes } from "@fortawesome/free-solid-svg-icons"

import Searcher from "../../lib/Searcher"
import Browser from "../../lib/BrowserProxy"

interface RequestFormModalProps {
  showModal: boolean
  closeModal(): void
}

interface RequestFormModalState {
  requestText: string
}

export default class RequestFormModal extends React.Component<RequestFormModalProps, RequestFormModalState> {

  constructor(props: RequestFormModalProps) {
    super(props)

    this.state = {
      requestText: ""
    }
  }

  public render(): JSX.Element {
    return (
      <Modal
        show={this.props.showModal}
        onHide={this.props.closeModal}
      >
        <Modal.Header closeButton={true}>
          <Modal.Title>管理者への要望・情報提供</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="small">
            <p>
              当サイトのデータは
              <a href="https://xn--eckfza0gxcvmna6c.gamerch.com/" target="_blank" rel="noopener noreferrer">Wiki</a>
              の情報と、管理人が所有するアルカナ情報でメンテナンスしていますが、<br />
              それ以外の情報が足りていません。<br />
              <br />
              情報をお持ちの方は
              <a href="https://xn--eckfza0gxcvmna6c.gamerch.com/" target="_blank" rel="noopener noreferrer">Wiki</a>
              に提供していただくか、以下のフォーム・Twitterでお願いします。<br />
              新機能に関する要望も歓迎です。
            </p>
          </div>
          <div className="form-group" id="request-form">
            <label htmlFor="ptm-code">内容</label>
            <textarea
              className="form-control"
              value={this.state.requestText}
              onChange={this.handleChange.bind(this)}
            />
            <span className="help-block small">100文字まで入力できます。</span>
          </div>
          <div className="form-group">
            <div className="pull-left">
              <a
                href={this.twitterUrl()}
                className="btn btn-primary"
              >
                Twitterでメッセージを送る
              </a>
              <span className="help-block small">※Twitterのサイトを開きます</span>
            </div>
            <div className="pull-right">
              <ButtonToolbar>
                <Button bsStyle="info" onClick={this.sendForm.bind(this)}>
                  フォームで送る
                </Button>
                <Button onClick={this.props.closeModal}>
                  <FontAwesomeIcon icon={faTimes} /> 閉じる
                </Button>
              </ButtonToolbar>
            </div>
          </div>
          <p className="clearfix" />
          <hr />
          <div>
            <a id="fr" />
            <h4>よくある要望</h4>
            <div className="small">
              <dl>
                <dt>攻撃力UP等の具体的な％表示がほしい</dt>
                <dd>「ゲーム内で確認可能な情報」ではないので、対応しません。Wikiへのリンクで確認してください。</dd>
              </dl>
            </div>
          </div>
          <hr />
          <div>
            <a id="info" />
            <h4>ATK/HPの情報がないアルカナ</h4>
            <div className="well well-sm">
              <small>
                （現在ありません）
              </small>
            </div>
            <h4>伝授必殺技の情報がないアルカナ</h4>
            <div className="well well-sm">
              <dl>
                <dt>戦士</dt>
                <dd className="small">
                  セラフィー / カラミティ / ブリジット
                </dd>
                <dt>弓使い</dt>
                <dd className="small">
                  イシュチェル / ダスク
                </dd>
                <dt>魔法使い</dt>
                <dd className="small">
                  ザラ / カティア（ver.2） / マスカルウィン（ver.1） / ペレキュデス / ストラッセ
                </dd>
                <dt>コラボ（ギルティギア）</dt>
                <dd className="small">
                  シン＝キスク / 梅喧 /  蔵土縁紗夢
                </dd>
              </dl>
            </div>
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

  private handleChange(e: React.FormEvent<HTMLTextAreaElement>): void {
    const text = e.currentTarget.value.substr(0, 100)
    this.setState({ requestText: text })
  }

  private twitterUrl(): string {
    const text = `@parrot_studio ${this.state.requestText}`
    let url = "https://twitter.com/intent/tweet"
    url += `?text=${encodeURIComponent(text)}`
    url += "&hashtags=ccpts"
    return url
  }

  private sendForm(e): void {
    e.preventDefault()

    const text = this.state.requestText
    if (text.length <= 0) {
      Browser.alert("メッセージを入力してください")
      return
    }

    if (!Browser.confirm("メッセージを送信します。よろしいですか？")) {
      return
    }

    Searcher.request(text).onValue(() => {
      this.props.closeModal()
      this.setState({ requestText: "" }, () => {
        Browser.alert("メッセージを送信しました")
      })
    })
  }
}
