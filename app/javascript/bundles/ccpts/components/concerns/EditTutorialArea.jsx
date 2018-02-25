import React from "react"
import { Alert } from "react-bootstrap"

export default class EditTutorialArea extends React.Component {

  constructor(props) {
    super(props)
    this.state = {visible: true}
  }

  handleAlertDismiss() {
    this.setState({visible: false})
  }

  render() {
    if (!this.state.visible){
      return null
    }

    return (
      <div className="row">
        <div className="col-xs-12 col-sm-12 col-md-12">
          <Alert bsStyle="success"
            closeLabel={"&times; Close"}
            onDismiss={this.handleAlertDismiss.bind(this)}>
            <h4>簡単な使い方</h4>
            <ol>
              <li>上が「メンバーエリア」、下が「検索エリア」です。</li>
              <li>「検索する」ボタンで条件を指定して、パーティーに入れたいアルカナを探します。</li>
              <li>検索エリアのアルカナを<strong>ドラッグアンドドロップして</strong>、メンバーエリアに追加します。</li>
              <li>好みのパーティーが組めたら、「共有する」ボタンからみんなと共有しましょう！</li>
            </ol>
            <p>
              もっと詳しい使い方は、「使い方」から確認してください。
            </p>
          </Alert>
        </div>
      </div>
    )
  }
}
