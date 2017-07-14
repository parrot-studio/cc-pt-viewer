import React from "react"
import { Modal, Button, ButtonToolbar } from "react-bootstrap"

import Searcher from "../../lib/Searcher"

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
          <div className="small">
            <p>
              当サイトのデータは<a href='https://xn--eckfza0gxcvmna6c.gamerch.com/' target='_blank' rel='noopener noreferrer'>Wiki</a>の情報と、管理人が所有するアルカナ情報でメンテナンスしていますが、<br/>
              それ以外の情報が足りていません。<br/>
              <br/>
              情報をお持ちの方は<a href='https://xn--eckfza0gxcvmna6c.gamerch.com/' target='_blank' rel='noopener noreferrer'>Wiki</a>に提供していただくか、
              以下のフォーム・Twitterでお願いします。<br/>
              新機能に関する要望も歓迎です。
            </p>
          </div>
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
            </div>
          </div>
          <hr/>
          <div>
            <a name="info"/>
            <h4>ATK/HPの情報がないアルカナ</h4>
            <div className="well well-sm">
              <small>
                （現在ありません）
              </small>
            </div>
            <h4>伝授スキルの情報がないアルカナ</h4>
            <div className="well well-sm">
              <dl>
                <dt>戦士</dt>
                <dd className="small">
                  ヨシツグ / ライア / ロレッタ（浴衣ver.） / リンリー / グララオ /
                  バラクーダ（ver.1） / ニンファ（ver.2） / スーリヤ /
                  ソーマ / コモディア / カラミティ / ブリジット / キャロ / ラントカルテ
                </dd>
                <dt>騎士</dt>
                <dd className="small">
                  パーシェル（1部ver.） / モルガン / セラカ / ソール / フェーベ /
                  ケーテ / セラフィー / リズベル / ジルヴェスター
                </dd>
                <dt>弓使い</dt>
                <dd className="small">
                  ファルリン（1部ver.） / グレタ / バルトロ / コネリ / タチアナ /
                  アリシア / ヨハンナ / イシュチェル / チェイス / グール＝ヴール / ダスク /
                  バッカス / メディア / ファクト
                </dd>
                <dt>魔法使い</dt>
                <dd className="small">
                  シューレ（1部ver.） / ヘリシティー / ファルベ / クララ / コラール /
                  ピノ / ラナ / ザラ / フリーダ / クズノハ / フリージア / カティア（ver.2） /
                  マスカルウィン / ペレキュデス / シヴァーニ / シャニ / レイチェル・アナスタシア /
                  ストラッセ / アステリア / ケテ
                </dd>
                <dt>僧侶</dt>
                <dd className="small">
                  リヒト / ノエル（特典ver.） / トゥキリス / ヘロディア（ver.2）
                </dd>
                <dt>コラボ（閃の軌跡II）</dt>
                <dd className="small">
                  リィン / アリサ / ラウラ
                </dd>
                <dt>コラボ（ヴァルキュリア）</dt>
                <dd className="small">
                  イムカ / リエラ / ユリアナ / ウェルキン / クルト
                </dd>
                <dt>コラボ（ペルソナ）</dt>
                <dd className="small">
                  パンサー / スカル / フォックス
                </dd>
                <dt>コラボ（ツインエンジェル）</dt>
                <dd className="small">
                  神無月葵 / 葉月クルミ
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
            <i className="fa fa-remove"/> 閉じる
          </Button>
        </Modal.Footer>
      </Modal>
    )
  }
}
