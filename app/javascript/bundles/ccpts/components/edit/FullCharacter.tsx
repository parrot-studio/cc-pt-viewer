import * as _ from "lodash"
import * as React from "react"

import Ability from "../../model/Ability"
import Member from "../../model/Member"

import { MemberRenderer, MemberRendererProps } from "./MemberRenderer"
import SummaryMember from "./SummaryMember"

export default class FullCharacter extends MemberRenderer<MemberRendererProps> {

  public render(): JSX.Element {
    return (
      <div className="member-character">
        {this.renderMember()}
      </div>
    )
  }

  private abilityNameForView(a: Ability | null): string {
    if (!a || _.isEmpty(a.name)) {
      return "なし"
    }
    return a.name
  }

  private renderFullSizeArcana(m: Member): JSX.Element {
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

  private renderMember(): JSX.Element {
    const m = this.props.member

    if (!m) {
      return (
        <div>
          <div className="none hidden-sm hidden-md hidden-lg summary-size arcana" />
          <div className="none hidden-xs full-size arcana" />
        </div>
      )
    }

    return (
      <div>
        <div className="hidden-sm hidden-md hidden-lg">
          <SummaryMember view="full" member={m} />
        </div>
        <div className="hidden-xs">
          {this.renderFullSizeArcana(m)}
        </div>
      </div>
    )

  }
}
