import _ from "lodash"

import React from "react"
import { Button } from "react-bootstrap"

import MessageStream from "../../model/MessageStream"

export default class ArcanaRenderer extends React.Component {

  shouldComponentUpdate(nextProps) {
    if (!_.isUndefined(this.props.member)) {
      if (this.isSameMember(this.props.member, nextProps.member)) {
        return false
      }
      return true
    } else if (!_.isUndefined(this.props.arcana)) {
      if (this.isSameArcana(this.props.arcana, nextProps.arcana)) {
        return false
      }
      return true
    }
    return true
  }

  componentDidMount() {
    this.fadeDiv()
  }

  componentDidUpdate() {
    this.fadeDiv()
  }

  isSameMember(bm, nm) {
    if (bm === null && nm === null) {
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

  isSameArcana(ba, na) {
    if (ba === null && na === null) {
      return true
    }
    if (ba && na) {
      return (ba.jobCode === na.jobCode)
    }
    return false
  }

  fadeDiv() {
    if (this._div) {
      $(this._div).hide()
      $(this._div).fadeIn()
    }
  }

  openArcanaViewModal(a, e) {
    e.preventDefault()
    MessageStream.arcanaViewStream.push(a)
  }

  setDraggable(code, k) {
    if (!this._div) {
      return
    }

    const d = $(this._div)
    d.attr("data-job-code", code)
    if (k) {
      d.attr("data-member-key", k)
    }
    d.draggable({
      connectToSortable: false,
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

  renderSkill(a) {
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

  renderAbilityNames(a) {
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

  renderChainAbilityName(a) {
    if (_.isEmpty(a.chainAbility) || _.isEmpty(a.chainAbility.name)) {
      return "なし"
    } else {
      return a.chainAbility.name
    }
  }

  renderInfoButton(a, view) {
    if (_.eq(view, "chain")) {
      return null
    }
    return (
      <Button
        bsStyle="default"
        bsSize="xsmall"
        onClick={this.openArcanaViewModal.bind(this, a)}>
        Info
      </Button>
    )
  }

  renderMemberCost(m) {
    if (!m) {
      return ""
    }
    let cost = `${m.arcana.cost}`
    if (m.chainArcana) {
      cost += ` + ${m.chainArcana.chainCost}`
    }
    return cost
  }

  renderChainAbility(m, type) {
    const c = m.chainArcana
    if (!c) {
      return `（${m.arcana.chainAbility.name}）`
    }

    const render = []
    let key = 0

    switch (type) {
      case "member":
        render.push(
          <button key={key++} type='button' className='close close-chain' onClick={this.props.removeChain}>
            &times;
          </button>
        )
        render.push(
          <a key={key++} href='#' onClick={this.openArcanaViewModal.bind(this, c)}>
            {c.name}
          </a>
        )
        break
      case "full":
        render.push(
          <a key={key++} href='#' onClick={this.openArcanaViewModal.bind(this, c)}>
            {c.name}
          </a>
        )
        break
      default:
        render.push(<span key={key++} className='chained-ability'>{c.name}</span>)
    }

    render.push(<span key={key++}> / </span>)

    if (m.canUseChainAbility()) {
      render.push(
        <span key={key++} className='chained-ability'>{c.chainAbility.name}</span>
      )
    } else {
      render.push(
        <s key={key++}>{c.chainAbility.name}</s>
      )
    }

    return render
  }
}
