import * as _ from "lodash"
import * as React from "react"

import Member from "../../model/Member"

import ArcanaRenderer from "./ArcanaRenderer"

export interface MemberRendererProps {
  member: Member | null
}

export abstract class MemberRenderer<T extends MemberRendererProps> extends ArcanaRenderer<T> {

  public shouldComponentUpdate(nextProps: T): boolean {
    return !this.isSameMember(this.props.member, nextProps.member)
  }

  protected isSameMember(bm: Member | null, nm: Member | null) {
    if (bm == null && nm == null) {
      return true
    }

    if (bm && nm) {
      if (this.isSameArcana(bm.arcana, nm.arcana)
        && this.isSameArcana(bm.chainArcana, nm.chainArcana)) {
        return true
      }
    }
    return false
  }

  protected renderMemberCost(m: Member): string {
    let cost = `${m.arcana.cost}`
    if (m.chainArcana) {
      cost += ` + ${m.chainArcana.chainCost}`
    }
    return cost
  }

  protected renderChainAbility(m: Member, modal: boolean, removeChain?: () => void): JSX.Element[] | JSX.Element {
    const c = m.chainArcana
    if (!c) {
      return <span>{`（${this.renderChainAbilityName(m.arcana)}）`}</span>
    }

    const render: JSX.Element[] = []
    let key = 0

    if (modal) {
      if (removeChain) {
        render.push(
          <button key={key++} type="button" className="close close-chain" onClick={removeChain}>
            &times;
          </button>
        )
      }
      render.push(
        <a key={key++} href="#" onClick={this.openArcanaViewModal.bind(this, c)}>
          {c.name}
        </a>
      )
    } else {
      render.push(<span key={key++} className="chained-ability">{c.name}</span>)
    }

    render.push(<span key={key++}> / </span>)

    let cname = "-"
    if (c.chainAbility) {
      cname = c.chainAbility.name
    }

    if (m.canUseChainAbility()) {
      render.push(
        <span key={key++} className="chained-ability">{cname}</span>
      )
    } else {
      render.push(
        <s key={key++}>{cname}</s>
      )
    }

    return render
  }
}
