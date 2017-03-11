import _ from 'lodash'

import Bacon from 'baconjs'
import React from 'react'
import { Button, Badge, Modal, Label } from 'react-bootstrap'

import Arcana from '../../model/Arcana'
import Favorites from '../../model/Favorites'
import Skill from '../../model/Skill'
import MessageStream from '../../model/MessageStream'

export default class ArcanaViewModal extends React.Component {

  addFavHandler(inp, a) {
    $(inp).bootstrapSwitch({
      state: Favorites.stateFor(a.jobCode),
      size: 'mini',
      onColor: 'success',
      labelText: 'お気に入り',
      labelWidth: '70',
      onSwitchChange: (e, state) => {
        Favorites.setState($(e.target).data('jobCode'), state)
      }
    })
  }

  renderEachSkill(sk, ind) {
    const ss = _.map(_.zip(sk.effects, _.range(sk.effects.length)), (t) => {
      const ef = t[0]
      let multi = ""
      switch (ef.multi_type) {
        case 'forward':
          multi = ' => '
          break
        case 'either':
          multi = ' または '
          break
        default:
          multi = ""
      }
      if (!_.isEmpty(ef.multi_condition)) {
        multi = `（${multi} ${ef.multi_condition} ）`
      }

      const ses = Skill.subEffectForEffect(ef)
      if (!_.isEmpty(ef.note)) {
        ses.push(ef.note)
      }
      let sv = ""
      if (ses.length > 0) {
        sv = `（ ${ses.join(' / ')} ）`
      }

      return <li key={t[1]}>{`${multi}${ef.category} - ${ef.subcategory}${sv}`}</li>
    })

    let cost = sk.cost
    if (_.isInteger(cost) && cost < 1) {
      cost = '-'
    }

    return (
      <div key={ind}>
        {sk.name}（{cost}）
        <ul className='small list-unstyled ability-detail'>
          {ss}
        </ul>
      </div>
    )
  }

  renderSkill(a) {
    const ss = []
    let ind = 1
    ss.push(this.renderEachSkill(a.firstSkill, ind))
    if (a.secondSkill && !_.isEmpty(a.secondSkill.name)) {
      ind += 1
      ss.push(this.renderEachSkill(a.secondSkill, ind))
    }
    if (a.thirdSkill && !_.isEmpty(a.thirdSkill.name)) {
      ind += 1
      ss.push(this.renderEachSkill(a.thirdSkill, ind))
    }
    return ss
  }

  renderInheritSkill(a) {
    if (!_.isEmpty(a.inheritSkill)) {
      return ([
        <dt key="isdt">伝授スキル</dt>,
        <dd key="isdd">{this.renderEachSkill(a.inheritSkill, 1)}</dd>
      ])
    } else {
      return null
    }
  }

  renderAbility(ab) {
    if (!ab || _.eq(ab.name, '？')) {
      return '？'
    }

    const abs = _.map(_.zip(ab.effects, _.range(ab.effects.length)), (t) => {
      const e = t[0]
      let str = `${e.condition} - ${e.effect}`
      if (!_.isEmpty(e.target)) {
        str = str.concat(`:${e.target}`)
      }
      if (!_.isEmpty(e.note)) {
        str = str.concat(` (${e.note})`)
      }
      return <li key={t[1]}>{str}</li>
    })

    return (
      <div>
        {ab.name}{!_.isEmpty(ab.weaponName) ? `（${ab.weaponName}）` : ""}
        <ul className='small list-unstyled ability-detail'>
          {abs}
        </ul>
      </div>
    )
  }

  renderFirstAbility(a) {
    if (a.firstAbility && !_.isEmpty(a.firstAbility.effects)) {
      return ([
        <dt key="a1dt">アビリティ1</dt>,
        <dd key="a1dd">{this.renderAbility(a.firstAbility)}</dd>
      ])
    } else {
      return null
    }
  }

  renderSecondAbility(a) {
    if (a.secondAbility && !_.isEmpty(a.secondAbility.effects)) {
      return ([
        <dt key="a2dt">アビリティ2</dt>,
        <dd key="a2dd">{this.renderAbility(a.secondAbility)}</dd>
      ])
    } else {
      return null
    }
  }

  renderPartyAbility(a) {
    if (a.partyAbility && !_.isEmpty(a.partyAbility.effects)) {
      return ([
        <dt key="pdt">PTアビリティ</dt>,
        <dd key="pdd">{this.renderAbility(a.partyAbility)}</dd>
      ])
    } else {
      return null
    }
  }

  renderWeaponAbility(a) {
    if (a.weaponAbility && !_.isEmpty(a.weaponAbility.name)) {
      return ([
        <dt key="wdt">専用武器アビリティ</dt>,
        <dd key="wdd">{this.renderAbility(a.weaponAbility)}</dd>
      ])
    } else {
      return null
    }
  }

  renderChainAbility(a) {
    if (a.chainAbility && !_.isEmpty(a.chainAbility.effects)) {
      return ([
        <dt key="cdt">絆アビリティ</dt>,
        <dd key="cdd">{this.renderAbility(a.chainAbility)}</dd>
      ])
    } else {
      return null
    }
  }

  renderCost(a) {
    if (a.isBuddy()) {
      return 'Buddy'
    } else {
      return `${a.cost} ( ${a.chainCost} )`
    }
  }

  renderOwner(a) {
    if (!a.hasOwner()) {
      return null
    }
    const o = a.owner()
    return (
      <small>
        / 主人：
        <a href="#"
          key={`${o.jobCode}.view`}
          onClick={this.openArcanaViewModal.bind(this, Arcana.forCode(o.jobCode))}>
          {o.name}
        </a>
      </small>
    )
  }

  renderBuddy(a) {
    if (!a.hasBuddy()) {
      return null
    }
    const b = a.buddy()
    return (
      <small>
        / バディ：
        <a href="#"
          key={`${b.jobCode}.view`}
          onClick={this.openArcanaViewModal.bind(this, Arcana.forCode(b.jobCode))}>
          {b.name}
        </a>
      </small>
    )
  }

  renderArcanaType(a) {
    let cl, text;
    switch(a.arcanaType) {
      case 'third':
        cl = 'success'
        text = '新世代'
        break
      case 'first':
        text = '旧世代'
        break
      case 'collaboration':
        cl = 'info'
        text = 'コラボ'
        break
      case 'demon':
        text = '魔神'
        break
    }

    if (!text) {
      return null
    }
    if (!cl) {
      cl = 'default'
    }

    return (
      <div className="pull-right">
        <Label bsStyle={cl}>{text}</Label>
      </div>
    )
  }

  openArcanaViewModal(a, e) {
    e.preventDefault()
    MessageStream.arcanaViewStream.plug(Bacon.sequentially(50, [null, a]))
  }

  renderArcanaView() {
    const a = this.props.viewArcana

    return (
      <Modal show={this.props.showModal} onHide={this.props.closeModal}>
        <Modal.Body>
          <button type="button" className="close" onClick={this.props.closeModal}>
            <span aria-hidden="true">&times; Close</span>
          </button>
          <br/>
          <div className={`arcana ${a.jobClass}`}>
            <div className={`arcana-title ${a.jobClass}-title`}>
              {`${a.jobName} : ${a.rarityStars}`}
              <Badge pullRight={true}>{this.renderCost(a)}</Badge>
            </div>
            <div className='arcana-view-body'>
              {this.renderArcanaType(a)}
              <h4 className='arcana-name'>
                <span className='text-muted'>{a.title}</span>
                <strong>{a.name}</strong>
                {this.renderOwner(a)}
                {this.renderBuddy(a)}
              </h4>
              <div className='row'>
                <div className='col-xs-12 hidden-sm hidden-md hidden-lg'>
                  <p className='pull-right'>
                    <input
                      type='checkbox'
                      data-job-code={a.jobCode}
                      ref={(inp) => {
                        this.addFavHandler(inp, a)
                      }}/>
                  </p>
                </div>
                <div className='col-xs-12 col-sm-4 col-md-4'>
                  <dl className='small arcana-view-detail'>
                    <dt>職業</dt>
                    <dd>{a.jobDetail}</dd>
                    <dt>ATK / HP</dt>
                    <dd>
                      {`${a.maxAtk} / ${a.maxHp}`}
                      <br/>
                      {`( ${a.limitAtk} / ${a.limitHp} )`}
                    </dd>
                    <dt>武器タイプ</dt>
                    <dd>{a.weaponName}</dd>
                    <dt>所属</dt>
                    <dd>{a.union}</dd>
                    <dt>声優</dt>
                    <dd>{a.voiceActor}</dd>
                    <dt>イラストレーター</dt>
                    <dd>{a.illustrator}</dd>
                    <dt>入手先</dt>
                    <dd>{`${a.sourceCategory} - ${a.source}`}</dd>
                  </dl>
                </div>
                <div className='col-xs-12 col-sm-8 col-md-8'>
                  <dl className='small arcana-view-detail'>
                    <dt>スキル</dt>
                    <dd>{this.renderSkill(a)}</dd>
                    {this.renderInheritSkill(a)}
                    {this.renderFirstAbility(a)}
                    {this.renderSecondAbility(a)}
                    {this.renderPartyAbility(a)}
                    {this.renderWeaponAbility(a)}
                    {this.renderChainAbility(a)}
                  </dl>
                </div>
                <div className='col-xs-12 col-sm-12 col-md-12'>
                  <p className='pull-left'>
                    <Button
                      bsStyle="default"
                      bsSize="small"
                      onClick={this.props.openWikiModal}>
                      <i className="fa fa-search"/> Wikiで確認
                    </Button>
                  </p>
                  <p className='pull-right hidden-xs'>
                    <input
                      type='checkbox'
                      data-job-code={a.jobCode}
                      ref={(inp) => {
                        this.addFavHandler(inp, a)
                      }}/>
                  </p>
                </div>
              </div>
            </div>
          </div>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.closeModal}>
            <i className="fa fa-remove"/>閉じる
          </Button>
        </Modal.Footer>
      </Modal>
    )
  }

  render() {
    if (this.props.viewArcana) {
      return this.renderArcanaView()
    } else {
      return null
    }
  }
}
