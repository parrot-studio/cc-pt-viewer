import * as _ from "lodash"

import * as React from "react"

import Member from "../../model/Member"
import Ability from "../../model/Ability"

import { MemberRenderer, MemberRendererProps } from "./MemberRenderer"
import SummaryMember from "./SummaryMember"

interface FullCharacterProps extends MemberRendererProps {
  title: string
  phoneDevice: boolean
}

export default class FullCharacter extends MemberRenderer<FullCharacterProps> {

  public render(): JSX.Element {
    return (
      <div>
        <label className="member-label">{this.props.title}</label>
        <div className="member-character">
          {this.renderMember()}
        </div>
      </div>
    )
  }

  private abilityNameForView(a: Ability | null): string {
    if (!a || _.isEmpty(a.name)) {
      return "なし"
    }
    return a.name
  }

  private renderMember(): JSX.Element {
    const m = this.props.member

    if (this.props.phoneDevice) {
      if (m) {
        return <SummaryMember view="full" member={m} />
      } else {
        return <div className="none summary-size arcana" />
      }
    }

    if (!m) {
      return <div className="none full-size arcana" />
    }

    const a = m.arcana
    return (
      <div className={`${a.jobClass} full-size arcana`}>
        <div className={`${a.jobClass}-title arcana-title small`}>
          {`${a.jobNameShort}:${a.rarityStars}`}
          <span className="badge badge-sm pull-right">{this.renderMemberCost(m)}</span>
        </div>
        <div className="arcana-body">
          <p className="arcana-name overflow">
            <span className="pull-right">{this.renderInfoButton(a)}</span>
            <span className="text-muted small">{a.title}</span><br />
            <strong>{a.nameWithBuddy()}</strong>
          </p>
          <dl className="small text-muted arcana-detail overflow">
            <dt>ATK / HP</dt>
            <dd>{`${a.maxAtkForView()} (${a.limitAtkForView()}) / ${a.maxHpForView()} (${a.limitHpForView()})`}</dd>
            <dt>Skill</dt>
            <dd>{this.renderSkill(a)}</dd>
            <dt>Ability</dt>
            <dd>
              <ul className="list-unstyled">
                <li>{this.abilityNameForView(a.firstAbility)}</li>
                <li>{this.abilityNameForView(a.secondAbility)}</li>
              </ul>
            </dd>
            <dt className="chain-ability-name">ChainAbility</dt>
            <dd className="small">{this.renderChainAbility(m, true)}</dd>
          </dl>
        </div>
        <div className={`${a.jobClass}-footer arcana-footer`} />
      </div>
    )
  }
}
