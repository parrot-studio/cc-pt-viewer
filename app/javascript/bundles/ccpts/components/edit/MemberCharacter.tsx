import * as React from "react"

import { MemberRenderer, MemberRendererProps } from "./MemberRenderer"

interface MemberCharacterProps extends MemberRendererProps {
  title: string
  removeChain(): void
  removeMember(): void
}

export default class MemberCharacter extends MemberRenderer<MemberCharacterProps> {

  public render(): JSX.Element {
    return (
      <div>
        {this.renderRemoveButton()}
        <label className="member-label">{this.props.title}</label>
        <div className="member-character">
          {this.renderMember()}
        </div>
      </div>
    )
  }

  private renderMember(): JSX.Element[] | JSX.Element {
    const m = this.props.member
    if (!m) {
      return <div className="none summary-size arcana" />
    }

    const a = m.arcana
    return (
      <div
        className={`${a.jobClass} summary-size arcana`}
        ref={(div) => { this.div = div; this.setDraggable(a.jobCode, m.memberKey) }}
      >
        <div className={`${a.jobClass}-title arcana-title small`}>
          {`${a.jobNameShort}:${a.rarityStars}`}
          <span className="badge badge-sm pull-right">{this.renderMemberCost(m)}</span>
        </div>
        <div className="arcana-summary">
          <small>
            <div className="pull-right mini info">
              {this.renderInfoButton(a)}
            </div>
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
              <li className="chain-ability-name">
                {this.renderChainAbility(m, true, this.props.removeChain)}
              </li>
            </ul>
          </small>
        </div>
      </div>
    )
  }

  private renderRemoveButton(): JSX.Element | null {
    if (!this.props.member) {
      return null
    }
    return (
      <button
        type="button"
        className="close close-member"
        aria-hidden="true"
        onClick={this.props.removeMember}
      >
        &times;
      </button>
    )
  }
}
