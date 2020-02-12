import * as React from "react"

import Arcana from "../../model/Arcana"
import Member from "../../model/Member"

import { MemberRenderer, MemberRendererProps } from "./MemberRenderer"

export interface HeroCharacterProps extends MemberRendererProps {
  mode: "edit" | "full"
}

export default class HeroCharacter extends MemberRenderer<HeroCharacterProps> {

  public render(): JSX.Element {
    const hero = this.props.member
    let a: Arcana | null = null
    if (hero) {
      a = hero.arcana
    }

    if (!a || !a.heroicSkill) {
      return <div className="none hero-size arcana" />
    }

    if (this.props.mode === "edit") {
      return this.renderForEdit(a)
    } else {
      return this.renderForFull(a)
    }
  }

  private renderForEdit(a: Arcana): JSX.Element {
    return (
      <div
        className={`${a.jobClass} choice hero-size arcana`}
        ref={(div) => { this.div = div; this.setDraggable(a.jobCode, Member.HERO_KEY) }}
      >
        {this.renderBody(a)}
      </div>
    )
  }

  private renderForFull(a: Arcana): JSX.Element {
    return (
      <div className={`${a.jobClass} choice hero-size arcana`}>
        {this.renderBody(a)}
      </div>
    )
  }

  private renderBody(a: Arcana): JSX.Element | null {
    if (!a.heroicSkill) {
      return null
    }

    return (
      <div>
        <div className={`${a.jobClass}-title arcana-title small`}>
          {`${a.jobNameShort}:${a.rarityStars}`}
        </div>
        <div className="arcana-hero">
          <small>
            <div className="pull-right mini info">
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
              <li className="heroic-skill">{a.heroicSkill.name}</li>
            </ul>
          </small>
        </div>
      </div>
    )
  }
}
