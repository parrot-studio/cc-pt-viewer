import * as Bacon from "baconjs"
import * as React from "react"

import { QueryParam } from "../../model/Query"
import MessageStream from "../../lib/MessageStream"

interface NameSearchFormState {
  name: string
}

// eslint-disable-next-line @typescript-eslint/ban-types
export default class NameSearchForm extends React.Component<{}, NameSearchFormState> {

  private nameStream: Bacon.Bus<QueryParam> = new Bacon.Bus()

  // eslint-disable-next-line @typescript-eslint/ban-types
  constructor(props: Readonly<{}>) {
    super(props)

    this.state = {
      name: ""
    }

    const arcanaNameStream = this.nameStream
      .filter((q) => q.name.length > 1)

    MessageStream.queryStream.plug(arcanaNameStream)

    MessageStream.conditionStream.onValue((q) => {
      this.setState({ name: (q.name || "") })
    })
  }

  public render(): JSX.Element {
    return (
      <div id="name-search">
        <form className="form-horizontal">
          <div className="form-group">
            <label className="control-label col-xs-12 col-sm-3 col-md-3" htmlFor="arcana-name">名前から検索</label>
            <div className="col-xs-10 col-sm-5 col-md-5">
              <input
                type="text"
                className="form-control"
                id="arcana-name"
                value={this.state.name}
                placeholder="名前を入力（2文字以上）"
                onChange={this.handleChange.bind(this)}
              />
            </div>
            <div>
              <button
                type="button"
                className="btn btn-primary"
                onClick={this.handleClick.bind(this)}
              >
                検索
              </button>
            </div>
          </div>
        </form>
      </div>
    )
  }

  private handleChange(e: React.FormEvent<HTMLInputElement>): void {
    this.setState({ name: e.currentTarget.value })
  }

  private handleClick(): void {
    this.nameStream.push({ name: this.state.name })
  }
}
