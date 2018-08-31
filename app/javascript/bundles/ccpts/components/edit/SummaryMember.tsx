import * as React from "react"

import { MemberRenderer, MemberRendererProps } from "./MemberRenderer"

interface SummaryMemberProps extends MemberRendererProps {
  view: "full" | "chain"
}

export default class SummaryMember extends MemberRenderer<SummaryMemberProps> {

  public render(): JSX.Element | null {
    const m = this.props.member
    if (!m) {
      return null
    }
    const a = m.arcana

    let modal = false
    if (this.props.view === "full") {
      modal = true
    }

    return (
      <div className={`${a.jobClass} ${this.props.view} summary-size arcana`}>
        <div className={`${a.jobClass}-title arcana-title small`}>
          {`${a.jobNameShort}:${a.rarityStars}`}
          <span className="badge badge-sm pull-right">{this.renderMemberCost(m)}</span>
        </div>
        <div className="arcana-summary">
          <small>
            {this.renderInfoButtonView()}
            <div className="pull-left overflow">
              <span className="text-muted small">{a.title}</span><br />
              <strong>{a.nameWithBuddy()}</strong>
            </div>
          </small>
          <p className="clearfix" />
          <small>
            <ul className="small text-muted list-unstyled summary-detail overflow">
              <li>{`${a.maxAtkForView()} / ${a.maxHpForView()}`}</li>
              <li>{this.renderSkill(a)}</li>
              <li>{this.renderAbilityNames(a)}</li>
              <li className="chain-ability-name">{this.renderChainAbility(m, modal)}</li>
            </ul>
          </small>
        </div>
      </div>
    )
  }

  private renderInfoButtonView() {
    if (this.props.view === "chain") {
      return null
    }
    const m = this.props.member
    if (!m) {
      return null
    }
    return (
      <div className="pull-right info">
        {this.renderInfoButton(m.arcana)}
      </div>
    )
  }
}
