import * as _ from "lodash"
import * as React from "react"
import { Button } from "react-bootstrap"

import Arcana from "../../model/Arcana"
import MessageStream from "../../model/MessageStream"

export default abstract class ArcanaRenderer<T> extends React.Component<T> {

  protected div: HTMLDivElement | null = null

  public componentDidMount(): void {
    this.fadeDiv()
  }

  public componentDidUpdate(): void {
    this.fadeDiv()
  }

  protected isSameArcana(ba: Arcana | null, na: Arcana | null) {
    if (_.isEmpty(ba) && _.isEmpty(na)) {
      return true
    }

    if (ba && na) {
      return (ba.jobCode === na.jobCode)
    }
    return false
  }

  protected openArcanaViewModal(a: Arcana, e: Event): void {
    e.preventDefault()
    MessageStream.arcanaViewStream.push(a)
  }

  protected setDraggable(code: string, memkey?: string | null) {
    if (!this.div) {
      return
    }

    const d = $(this.div)
    d.attr("data-job-code", code)
    if (memkey) {
      d.attr("data-member-key", memkey)
    }
    d.draggable({
      containment: false,
      helper: "clone",
      opacity: 0.7,
      zIndex: 10000,
      start: () => {
        $("#search-area").hide()
        $("#help-area").show()
      },
      stop: () => {
        $("#search-area").show()
        $("#help-area").hide()
      }
    })
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

  private fadeDiv(): void {
    if (this.div) {
      $(this.div).hide()
      $(this.div).fadeIn()
    }
  }
}
