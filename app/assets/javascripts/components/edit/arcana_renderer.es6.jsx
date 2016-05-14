class ArcanaRenderer extends React.Component {

  shouldComponentUpdate(nextProps, nextState) {
    if (!_.isUndefined(this.props.member)) {
      if (this.isSameMember(this.props.member, nextProps.member)){
        return false
      }
      return true
    } else if (!_.isUndefined(this.props.arcana)) {
      if (this.isSameArcana(this.props.arcana, nextProps.arcana)){
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
    this.props.arcanaViewStream.push(a)
  }

  setDraggable(code, k) {
    if (!this._div){
      return
    }

    let d = $(this._div)
    d.attr("data-job-code", code)
    if (k){
      d.attr("data-member-key", k)
    }
    d.draggable({
      connectToSortable: false,
      containment: false,
      helper: 'clone',
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
    let s1 = a.firstSkill
    let s2 = a.secondSkill
    let s3 = a.thirdSkill
    let maxLength = 17

    let render = s1.name
    if (s2 && !_.isEmpty(s2.name)) {
      render += `/${s2.name}`
    }
    if (s3 && !_.isEmpty(s3.name)) {
      render += `/${s3.name}`
    }
    render += `(${s1.cost}`
    if (s2 && s1.cost !== s2.cost) {
      render += `/${s2.cost}`
    }
    if (s3 && s3.cost !== s3.cost) {
      render += `/${s3.cost}`
    }
    render += ')'

    if (render.length > maxLength) {
      render = render.substr(0, maxLength - 3)
      render += '...'
    }

    return render
  }

  renderAbilityNames(a) {
    let abName1 = a.firstAbility.name
    if (_.isEmpty(abName1)) {
      abName1 = "なし"
    }

    let abName2 = a.secondAbility.name
    if (_.isEmpty(abName2)) {
      abName2 = "なし"
    }

    return <span>{abName1}<br/>{abName2}</span>
  }

  renderInfoButton(a) {
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
    let c = m.chainArcana
    if (!c) {
      return `（${m.arcana.chainAbility.name}）`
    }

    let render = []
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

    if (m.canUseChainAbility()){
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
