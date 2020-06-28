import * as React from "react"

import Arcana from "../../model/Arcana"
import Favorites from "../../model/Favorites"

import Browser from "../../lib/BrowserProxy"
import MessageStream from "../../lib/MessageStream"

import ArcanaRenderer from "./ArcanaRenderer"

interface TargetArcanaProps {
  arcana: Arcana
}

interface TargetArcanaState {
  favorite: boolean,
  switch: HTMLInputElement | null
}

export default class TargetArcana extends ArcanaRenderer<TargetArcanaProps, TargetArcanaState> {

  constructor(props: Readonly<TargetArcanaProps>) {
    super(props)

    const code = this.props.arcana.jobCode

    this.state = {
      favorite: Favorites.stateFor(code),
      switch: null
    }

    MessageStream.favoritesStream.onValue((fs) => {
      const s = this.state.switch
      if (s) {
        Browser.updateSwitchState(s, fs[code])
      }
    })
  }

  public shouldComponentUpdate(nextProps: { arcana: Arcana | null }): boolean {
    return !this.isSameArcana(this.props.arcana, nextProps.arcana)
  }

  public render(): JSX.Element {
    const a = this.props.arcana
    const fav = this.state.favorite

    return (
      <li
        className={"listed-character col-sm-3 col-md-3 col-xs-6"}
        id={`choice-${a.jobCode}`}
      >
        <div
          className={`${a.jobClass} choice summary-size arcana`}
          ref={(d) => { this.div = d; this.setDraggable(a.jobCode) }}
        >
          <div className={`${a.jobClass}-title arcana-title small`}>
            {`${a.jobNameShort}:${a.rarityStars}`}
            <span className="badge badge-sm pull-right">{`${this.renderTargetCost()}`}</span>
          </div>
          <div className="arcana-summary">
            <small>
              <div className="pull-right mini info">
                <input
                  type="checkbox"
                  id={`fav-${a.jobCode}`}
                  data-job-code={a.jobCode}
                  ref={(inp) => { this.addFavHandler(inp, fav) }}
                />
                {this.renderInfoButton(a)}
              </div>
              <div className="pull-left overflow">
                <span className="text-muted small">{a.title}</span><br />
                <strong>{a.name}</strong>
              </div>
            </small>
            <p className="clearfix" />
            <small>
              <ul className="small text-muted list-unstyled summary-detail overflow">
                <li>{`${a.maxAtkForView()} / ${a.maxHpForView()}`}</li>
                <li>{this.renderSkill(a)}</li>
                <li>{this.renderAbilityNames(a)}</li>
                <li className="chain-ability-name">{`（${this.renderChainAbilityName(a)}）`}</li>
              </ul>
            </small>
          </div>
        </div>
      </li>
    )
  }

  private addFavHandler(inp: HTMLInputElement | null, fav: boolean): void {
    if (!inp) {
      return
    }

    this.setState({ switch: inp }, () => {
      Browser.addSwitchHandler(
        inp,
        fav,
        this.hundleFavoriteSwitch.bind(this),
        {
          size: "mini",
          onColor: "warning",
          onText: "☆",
          offText: "★",
          labelWidth: "2"
        }
      )
    })
  }

  private hundleFavoriteSwitch(state: boolean): void {
    const a = this.props.arcana
    if (a) {
      Favorites.setState(a.jobCode, state)
    }
  }

  private renderTargetCost(): string {
    const a = this.props.arcana
    if (a.isBuddy()) {
      return "Buddy"
    } else {
      return `${a.cost} ( ${a.chainCost} )`
    }
  }
}
