import React from "react"

import Favorites from "../../model/Favorites"
import ArcanaRenderer from "./ArcanaRenderer"

export default class TargetArcana extends ArcanaRenderer {

  addFavHandler(inp, a) {
    $(inp).bootstrapSwitch({
      state: Favorites.stateFor(a.jobCode),
      size: "mini",
      onColor: "warning",
      onText: "☆",
      offText: "★",
      labelWidth: "2",
      onSwitchChange: (e, state) => {
        Favorites.setState($(e.target).data("jobCode"), state)
      }
    })
  }

  renderTargetCost() {
    const a = this.props.arcana
    if (a.isBuddy()) {
      return "Buddy"
    } else {
      return `${a.cost} ( ${a.chainCost} )`
    }
  }

  render () {
    const a = this.props.arcana
    return (
      <li className={"listed-character col-sm-3 col-md-3 col-xs-6"}
        id={`choice-${a.jobCode}`}>
        <div className={`${a.jobClass} choice summary-size arcana`}
          ref={(div) => {
            this._div = div
            this.setDraggable(a.jobCode)
          }}>
          <div className={`${a.jobClass}-title arcana-title small`}>
            {`${a.jobNameShort}:${a.rarityStars}`}
            <span className='badge badge-sm pull-right'>{`${this.renderTargetCost()}`}</span>
          </div>
          <div className='arcana-summary'>
            <small>
              <div className='pull-right mini info'>
                <input type='checkbox'
                  id={`fav-${a.jobCode}`}
                  data-job-code={a.jobCode}
                  ref={(inp) => {
                    this.addFavHandler(inp, a)
                  }}/>
                {this.renderInfoButton(a)}
              </div>
              <div className='pull-left overflow'>
                <span className='text-muted small'>{a.title}</span><br/>
                <strong>{a.name}</strong>
              </div>
            </small>
            <p className='clearfix'/>
            <small>
              <ul className='small text-muted list-unstyled summary-detail overflow'>
                <li>{`${a.maxAtk} / ${a.maxHp}`}</li>
                <li>{this.renderSkill(a)}</li>
                <li>{this.renderAbilityNames(a)}</li>
                <li className='chain-ability-name'>{`（${this.renderChainAbilityName(a)}）`}</li>
              </ul>
            </small>
          </div>
        </div>
      </li>
    )
  }
}
