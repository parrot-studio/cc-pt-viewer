import React from 'react'
import { Modal, Button, ButtonToolbar } from 'react-bootstrap'

import Searcher from '../../lib/Searcher'

export default class RequestFormModal extends React.Component {

  constructor(props) {
    super(props)

    this.state = {
      requestText: ""
    }
  }

  handleChange(e) {
    const text = e.target.value.substr(0, 100)
    this.setState({requestText: text})
  }

  twitterUrl() {
    const text = `@parrot_studio ${this.state.requestText}`
    let url = "https://twitter.com/intent/tweet"
    url += `?text=${encodeURIComponent(text)}`
    url += "&hashtags=ccpts"
    return url
  }

  sendForm(e) {
    e.preventDefault()

    const text = this.state.requestText
    if (text.length <= 0) {
      window.alert("メッセージを入力してください")
      return
    }

    if (!window.confirm("メッセージを送信します。よろしいですか？")) {
      return
    }

    this.props.closeModal()
    Searcher.request(text).onValue(() => {
      window.alert("メッセージを送信しました")
      this.setState({requestText: ""})
    })
  }

  render() {
    return (
      <Modal
        show={this.props.showModal}
        onHide={this.props.closeModal}>
        <Modal.Header closeButton>
          <Modal.Title>管理者への要望・情報提供</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div className="form-group" id="request-form">
            <label htmlFor="ptm-code">内容</label>
            <textarea
              className="form-control"
              value={this.state.requestText}
              onChange={this.handleChange.bind(this)}/>
            <span className="help-block small">100文字まで入力できます。</span>
          </div>
          <div className="form-group">
            <div className="pull-left">
              <a
                href={this.twitterUrl()}
                className="btn btn-primary">
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
                  <i className="fa fa-remove"/> 閉じる
                </Button>
              </ButtonToolbar>
            </div>
          </div>
          <p className="clearfix"/>
          <hr/>
          <div>
            <a name="fr"/>
            <h4>よくある要望</h4>
            <div className="small">
              <dl>
                <dt>攻撃力UP等の具体的な％表示がほしい</dt>
                <dd>「ゲーム内で確認可能な情報」ではないので、対応しません。Wikiへのリンクで確認してください。</dd>
              </dl>
              <dl>
                <dt>Vita版専用のアルカナも登録してほしい</dt>
                <dd>管理人がVita版をプレイしていないので難しいです。</dd>
              </dl>
            </div>
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
