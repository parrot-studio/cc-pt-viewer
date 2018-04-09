import _ from "lodash"

import React from "react"

import ArcanaRenderer from "./ArcanaRenderer"
import SummaryMember from "./SummaryMember"

export default class FullCharacter extends ArcanaRenderer {

  renderMember() {
    const m = this.props.member

    if (this.props.phoneDevice) {
      if (m) {
        return <SummaryMember
          view="full"
          member={m}/>
      } else {
        return <div className='none summary-size arcana'></div>
      }
    }

    if (!m) {
      return <div className='none full-size arcana'></div>
    }

    const a = m.arcana
    return (
      <div className={`${a.jobClass} full-size arcana`}>
        <div className={`${a.jobClass}-title arcana-title small`}>
          {`${a.jobNameShort}:${a.rarityStars}`}
          <span className='badge badge-sm pull-right'>{this.renderMemberCost(m)}</span>
        </div>
        <div className='arcana-body'>
          <p className='arcana-name overflow'>
            <span className="pull-right">{this.renderInfoButton(a)}</span>
            <span className='text-muted small'>{a.title}</span><br/>
            <strong>{a.nameWithBuddy()}</strong>
          </p>
          <dl className='small text-muted arcana-detail overflow'>
            <dt>ATK / HP</dt>
            <dd>{`${a.maxAtk} (${a.limitAtk}) / ${a.maxHp} (${a.limitHp})`}</dd>
            <dt>Skill</dt>
            <dd>{this.renderSkill(a)}</dd>
            <dt>Ability</dt>
            <dd>
              <ul className='list-unstyled'>
                <li>{_.isEmpty(a.firstAbility.name) ? "なし" : a.firstAbility.name }</li>
                <li>{_.isEmpty(a.secondAbility.name) ? "なし" : a.secondAbility.name}</li>
              </ul>
            </dd>
            <dt className='chain-ability-name'>ChainAbility</dt>
            <dd className='small'>{this.renderChainAbility(m, "full")}</dd>
          </dl>
        </div>
        <div className={`${a.jobClass}-footer arcana-footer`}></div>
      </div>
    )
  }

  render () {
    return (
      <div>
        <label className="member-label">{this.props.name}</label>
        <div className="member-character">
          {this.renderMember()}
        </div>
      </div>
    )
  }
}