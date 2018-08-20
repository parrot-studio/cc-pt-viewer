import * as React from "react"
import { Alert } from "react-bootstrap"

interface DisplaySizeWarningProps {
  appPath: string
}

export default class DisplaySizeWarning extends React.Component<DisplaySizeWarningProps> {
  public render(): JSX.Element {
    const dbPath = `${this.props.appPath}db`

    return (
      <div className="row">
        <div className="row hidden-sm hidden-md hidden-lg col-xs-12">
          <Alert bsStyle="danger">
            <p>
              PC/タブレット以外のデバイスでは、パーティーの閲覧のみで編集はできません。<br />
              アルカナの検索等は「<a className="alert-link" href={dbPath}>データベースモード</a>」でご利用いただけます。
            </p>
            <p>
              <a className="btn btn-default" href={dbPath} role="button">データベースモード</a>
            </p>
          </Alert>
        </div>
      </div>
    )
  }
}
