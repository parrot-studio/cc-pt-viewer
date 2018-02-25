import React from "react"

import ArcanaRenderer from "./ArcanaRenderer"

export default class SummaryMember extends ArcanaRenderer {
  render () {
    const m = this.props.member
    const a = m.arcana

    return (
      <div className={`${a.jobClass} ${this.props.view} summary-size arcana`}>
        <div className={`${a.jobClass}-title arcana-title small`}>
          {`${a.jobNameShort}:${a.rarityStars}`}
          <span className='badge badge-sm pull-right'>{this.renderMemberCost(m)}</span>
        </div>
        <div className='arcana-summary'>
          <small>
            <div className='pull-right info'>
              {this.renderInfoButton(a, this.props.view)}
            </div>
            <div className='pull-left overflow'>
              <span className='text-muted small'>{a.title}</span><br/>
              <strong>{a.nameWithBuddy()}</strong>
            </div>
          </small>
          <p className='clearfix'/>
          <small>
            <ul className='small text-muted list-unstyled summary-detail overflow'>
              <li>{`${a.maxAtk} / ${a.maxHp}`}</li>
              <li>{this.renderSkill(a)}</li>
              <li>{this.renderAbilityNames(a)}</li>
              <li className='chain-ability-name'>{this.renderChainAbility(m, this.props.view)}</li>
            </ul>
          </small>
        </div>
      </div>
    )
  }
}
