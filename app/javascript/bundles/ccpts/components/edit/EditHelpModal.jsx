import React from "react"
import { Button, Modal } from "react-bootstrap"

export default class EditHelpModal extends React.Component {

  render() {
    if (!this.props.showModal) {
      return null
    }

    return (
      <Modal
        show={this.props.showModal}
        onHide={this.props.closeModal}>
        <Modal.Body>
          <button type="button" className="close" onClick={this.props.closeModal}>
            <span aria-hidden="true">&times; Close</span>
          </button>
          <br />
          <h3>基本的な使い方</h3>
          <div className="embed-responsive embed-responsive-16by9">
            <iframe className="embed-responsive-item" src="//www.youtube.com/embed/j5NG-3cTlPs"></iframe>
          </div>
          <h3>パーティー編成方法</h3>
          <ol className="help">
            <li>「検索する」をタップして、検索条件ウィンドウを開きます</li>
            <li>検索ウィンドウで好きな条件を選び、「検索」をタップします</li>
            <li>検索されたアルカナが下エリアにリストアップされます</li>
            <li>「Info」をタップすれば、各アルカナのより詳細な情報を確認できます</li>
            <li>
              <strong>アルカナをドラッグして、パーティーに追加したい位置でドロップします</strong>
              <ul>
                <li>すでにアルカナが存在する位置にドロップした場合、<br />「絆」か「置き換え」の選択が出ます</li>
              </ul>
            </li>
            <li>納得いく編成ができたら、「共有する」をタップします</li>
            <li>表示されたURLを他の人に渡せば、編成したパーティーを見てもらえます</li>
            <li>「Twitterで共有する」をタップすると、投稿用のウィンドウが開きます</li>
          </ol>
          <h3>注意事項・その他</h3>
          <ul className="help">
            <li>スマートフォン等、小さい画面では編集ができません（構成の確認のみ）</li>
            <li>編成を一度クリアしたい場合、「パーティーをリセット」をタップすると、パーティーが空になります</li>
            <li>編成すると自動的にブラウザのURLが変わります<br />こちらのURLをSNS等で共有することが可能です</li>
            <li>Twitterに投稿する際、自由に文章を追加できますが、URLを書き換えると正しく共有できません</li>
            <li>
              <strong>データはスマートフォン版（Android/iOS）のもの</strong>です。Vita版には対応していません</li>
          </ul>
          <p>
            もっと細かい説明や更新履歴等は
            <a href={this.props.aboutPath}>こちら</a>
          </p>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.closeModal}>
            <i className="fa fa-remove" /> 閉じる
          </Button>
        </Modal.Footer>
      </Modal>
    )
  }
}
