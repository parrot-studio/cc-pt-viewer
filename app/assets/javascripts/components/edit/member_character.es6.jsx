class MemberCharacter extends ArcanaRenderer {

  renderMember() {
    let m = this.props.member
    if (!m) {
      return <div className='none summary-size arcana'></div>
    }

    let a = m.arcana
    return (
      <div className={`${a.jobClass} summary-size arcana`}
        ref={(div) => {
          this._div = div
          this.setDraggable(a.jobCode, this.props.code)
        }}>
        <div className={`${a.jobClass}-title arcana-title small`}>
          {`${a.jobNameShort}:${a.rarityStars}`}
          <span className='badge badge-sm pull-right'>{this.renderMemberCost(m)}</span>
        </div>
        <div className='arcana-summary'>
          <small>
            <div className='pull-right mini info'>
              {this.renderInfoButton(a)}
            </div>
            <div className='pull-left overflow'>
              <span className='text-muted small'>{a.title}</span><br/>
              <strong>{a.name}</strong>
            </div>
          </small>
          <p className='clearfix'/>
          <small>
            <ul className='small text-muted list-unstyled summary-detail overflow'>
              <li>{`${a.maxAtk} / ${a.maxHp}`}</li>
              <li>{this.renderSkill(a)}</li>
              <li>{this.renderAbilityNames(a)}</li>
              <li className='chain-ability-name'>{this.renderChainAbility(m, "member")}</li>
            </ul>
          </small>
        </div>
      </div>
    )
  }

  renderRemoveButton() {
    if (!this.props.member) {
      return null
    }
    return (
      <button type="button" className="close close-member"
        aria-hidden="true" onClick={this.props.removeMember}>
        &times;
      </button>
    )
  }

  render() {
    return (
      <div>
        {this.renderRemoveButton()}
        <label className="member-label">{this.props.name}</label>
        <div className="member-character">
          {this.renderMember()}
        </div>
      </div>
    )
  }
}
