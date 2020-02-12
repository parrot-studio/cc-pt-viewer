import * as _ from "lodash"
import * as React from "react"
import { Button } from "react-bootstrap"

import Arcana from "../../model/Arcana"
import MessageStream from "../../lib/MessageStream"
import Browser from "../../lib/BrowserProxy"

export default abstract class ArcanaRenderer<T, S> extends React.Component<T, S> {

  protected div: HTMLDivElement | null = null

  public componentDidMount(): void {
    if (this.div) {
      Browser.hide(this.div)
      Browser.fadeIn(this.div)
    }
  }

  public componentWillUpdate(): void {
    if (this.div) {
      Browser.hide(this.div)
    }
  }

  public componentDidUpdate(): void {
    if (this.div) {
      Browser.fadeIn(this.div)
    }
  }

  protected isSameArcana(ba: Arcana | null, na: Arcana | null) {
    if (ba == null && na == null) {
      return true
    }

    if (ba && na) {
      return (ba.jobCode === na.jobCode)
    }
    return false
  }

  protected openArcanaViewModal(a: Arcana, e): void {
    e.preventDefault()
    MessageStream.arcanaViewStream.push(a)
  }

  protected setDraggable(code: string, memkey?: string | null) {
    if (!this.div) {
      return
    }
    Browser.setDraggable(this.div, code, memkey)
  }

  protected renderSkill(a: Arcana): string {
    const s1 = a.firstSkill
    const s2 = a.secondSkill
    const s3 = a.thirdSkill
    const maxLength = 17

    let render = s1.name
    if (s2) {
      render += `/${s2.name}`
    }
    if (s3) {
      render += `/${s3.name}`
    }
    render += `(${s1.costForView()}`
    if (s2) {
      render += `/${s2.costForView()}`
    }
    if (s3) {
      render += `/${s3.costForView()}`
    }
    render += ")"

    if (render.length > maxLength) {
      render = render.substr(0, maxLength - 3)
      render += "..."
    }

    return render
  }

  protected renderAbilityNames(a: Arcana): JSX.Element {
    let abName1 = "なし"
    if (a.firstAbility) {
      abName1 = a.firstAbility.name
    }
    let abName2 = "なし"
    if (a.secondAbility) {
      abName2 = a.secondAbility.name
    }

    return <span>{abName1}<br />{abName2}</span>
  }

  protected renderChainAbilityName(a: Arcana): string {
    const ca = a.chainAbility
    if (!ca || _.isEmpty(ca.name)) {
      return "なし"
    } else {
      return ca.name
    }
  }

  protected renderInfoButton(a: Arcana): JSX.Element {
    return (
      <Button
        bsStyle="default"
        bsSize="xsmall"
        onClick={this.openArcanaViewModal.bind(this, a)}
      >
        Info
      </Button>
    )
  }
}
