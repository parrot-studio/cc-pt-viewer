import * as _ from "lodash"

import * as Bacon from "baconjs"
import * as React from "react"
import { Button, Badge, Modal, Label, Tab, Tabs } from "react-bootstrap"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faTimes, faSearch } from "@fortawesome/free-solid-svg-icons"

import Arcana from "../../model/Arcana"
import Skill from "../../model/Skill"
import Ability from "../../model/Ability"
import Favorites from "../../model/Favorites"
import MessageStream from "../../lib/MessageStream"
import Browser from "../../lib/BrowserProxy"

interface ArcanaViewModalProps {
  viewArcana: Arcana | null
  showModal: boolean
  closeModal(): void
  openWikiModal(): void
}

export default class ArcanaViewModal extends React.Component<ArcanaViewModalProps> {
  public render(): JSX.Element | null {
    if (this.props.viewArcana) {
      return this.renderArcanaView()
    } else {
      return null
    }
  }

  private addFavHandler(inp: HTMLDivElement | null, a: Arcana): void {
    if (!inp) {
      return
    }

    Browser.addSwitchHandler(
      inp,
      Favorites.stateFor(a.jobCode),
      this.hundleFavoriteSwitch.bind(this),
      {
        size: "mini",
        onColor: "success",
        labelText: "お気に入り",
        labelWidth: "70"
      }
    )
  }

  private hundleFavoriteSwitch(state: boolean): void {
    const a = this.props.viewArcana
    if (a) {
      Favorites.setState(a.jobCode, state)
    }
  }

  private renderEachSkill(sk: Skill, ind: number): JSX.Element {
    const ss = _.chain(_.zip(sk.effects, _.range(sk.effects.length))
      .map((t) => {
        const ef = t[0]
        const num = t[1]
        if (!ef) {
          return
        }

        let multi = ""
        switch (ef.multiType) {
          case "forward":
            multi = " => "
            break
          default:
            multi = ""
        }
        if (!_.isEmpty(ef.multiCondition)) {
          multi = `（${multi} ${ef.multiCondition} ）`
        }

        const ses = Skill.subEffectForEffect(ef)
        if (!_.isEmpty(ef.note)) {
          ses.push(ef.note)
        }
        let sv = ""
        if (ses.length > 0) {
          sv = `（ ${ses.join(" / ")} ）`
        }

        return <li key={num}>{`${multi}${ef.category} - ${ef.subcategory}${sv}`}</li>
      }))
      .compact()
      .value()

    return (
      <div key={ind}>
        {sk.name}（{sk.costForView()}）
        <ul className="small list-unstyled ability-detail">
          {ss}
        </ul>
      </div>
    )
  }

  private renderSkill(a: Arcana): JSX.Element[] {
    const ss: JSX.Element[] = []
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

  private renderInheritSkill(a: Arcana): JSX.Element[] | null {
    if (a.inheritSkill) {
      return ([
        <dt key="isdt">伝授必殺技</dt>,
        <dd key="isdd">{this.renderEachSkill(a.inheritSkill, 1)}</dd>
      ])
    } else {
      return null
    }
  }

  private renderHeroicSkill(a: Arcana): JSX.Element[] | null {
    if (a.heroicSkill) {
      return ([
        <dt key="isdt">ヒロイックスキル</dt>,
        <dd key="isdd">{this.renderEachSkill(a.heroicSkill, 1)}</dd>
      ])
    } else {
      return null
    }
  }

  private renderDecisiveOrder(a: Arcana): JSX.Element[] | null {
    if (a.decisiveOrder) {
      return ([
        <dt key="isdt">決戦号令</dt>,
        <dd key="isdd">{this.renderEachSkill(a.decisiveOrder, 1)}</dd>
      ])
    } else {
      return null
    }
  }

  private renderDecisiveSkill(a: Arcana): JSX.Element[] | null {
    if (a.decisiveSkill) {
      return ([
        <dt key="isdt">決戦必殺</dt>,
        <dd key="isdd">{this.renderEachSkill(a.decisiveSkill, 1)}</dd>
      ])
    } else {
      return null
    }
  }

  private renderAbility(ab: Ability): JSX.Element {
    if (!ab || ab.name === "？") {
      return <li key={0}>{"？"}</li>
    }

    const abs = _.chain(_.zip(ab.effects, _.range(ab.effects.length))
      .map((t) => {
        const e = t[0]
        const num = t[1]
        if (!e) {
          return
        }

        let str = `${e.condition}`
        const cs = _.compact([e.subCondition, e.conditionNote])
        if (!_.isEmpty(cs)) {
          str = str.concat(`( ${cs.join(" / ")} )`)
        }
        str = str.concat(` - ${e.effect}`)
        if (!_.isEmpty(e.subEffect)) {
          str = str.concat(` / ${e.subEffect}`)
        }
        if (!_.isEmpty(e.effectNote)) {
          str = str.concat(`( ${e.effectNote} )`)
        }
        if (!_.isEmpty(e.target)) {
          str = str.concat(` : ${e.target}`)
        }
        if (!_.isEmpty(e.subTarget)) {
          str = str.concat(` / ${e.subTarget}`)
        }
        if (!_.isEmpty(e.targetNote)) {
          str = str.concat(` ( ${e.targetNote} )`)
        }
        return <li key={num}>{str}</li>
      }))
      .compact().value()

    return (
      <div>
        {ab.name}{!_.isEmpty(ab.weaponName) ? `（${ab.weaponName}）` : ""}
        <ul className="small list-unstyled ability-detail">
          {abs}
        </ul>
      </div>
    )
  }

  private renderFirstAbility(a: Arcana): JSX.Element[] | null {
    if (a.firstAbility && a.firstAbility.effects.length > 0) {
      return ([
        <dt key="a1dt">アビリティ1</dt>,
        <dd key="a1dd">{this.renderAbility(a.firstAbility)}</dd>
      ])
    } else {
      return null
    }
  }

  private renderSecondAbility(a: Arcana): JSX.Element[] | null {
    if (a.secondAbility && a.secondAbility.effects.length > 0) {
      return ([
        <dt key="a2dt">アビリティ2</dt>,
        <dd key="a2dd">{this.renderAbility(a.secondAbility)}</dd>
      ])
    } else {
      return null
    }
  }

  private renderPartyAbility(a: Arcana): JSX.Element[] | null {
    if (a.partyAbility && a.partyAbility.effects.length > 0) {
      return ([
        <dt key="pdt">PTアビリティ</dt>,
        <dd key="pdd">{this.renderAbility(a.partyAbility)}</dd>
      ])
    } else {
      return null
    }
  }

  private renderExtraAbility(a: Arcana): JSX.Element[] | null {
    if (a.extraAbility && a.extraAbility.effects.length > 0) {
      return ([
        <dt key="cdt">EXアビリティ</dt>,
        <dd key="cdd">{this.renderAbility(a.extraAbility)}</dd>
      ])
    } else {
      return null
    }
  }

  private renderWeaponAbility(a: Arcana): JSX.Element[] | null {
    if (a.weaponAbility && !_.isEmpty(a.weaponAbility.name)) {
      return ([
        <dt key="wdt">専用武器アビリティ</dt>,
        <dd key="wdd">{this.renderAbility(a.weaponAbility)}</dd>
      ])
    } else {
      return null
    }
  }

  private renderChainAbility(a: Arcana): JSX.Element[] | null {
    if (a.chainAbility && a.chainAbility.effects.length > 0) {
      return ([
        <dt key="cdt">絆アビリティ</dt>,
        <dd key="cdd">{this.renderAbility(a.chainAbility)}</dd>
      ])
    } else {
      return null
    }
  }

  private renderPassiveAbility(a: Arcana): JSX.Element[] | null {
    if (a.passiveAbility && a.passiveAbility.effects.length > 0) {
      return ([
        <dt key="cdt">パッシブアビリティ</dt>,
        <dd key="cdd">{this.renderAbility(a.passiveAbility)}</dd>
      ])
    } else {
      return null
    }
  }

  private renderGunkiAbility(a: Arcana): JSX.Element[] | null {
    const abs: Ability[] = a.gunkiAbilities
    if (abs.length < 1) {
      return null
    }

    let ind = 1
    const ret: JSX.Element[] = []
    abs.forEach((g) => {
      ret.push(
        <dt key={ind++}>義勇軍記</dt>,
        <dd key={ind++}>{this.renderAbility(g)}</dd>
      )
    })
    return ret
  }

  private renderCost(a: Arcana): string {
    if (a.isBuddy()) {
      return "Buddy"
    } else {
      return `${a.cost} ( ${a.chainCost} )`
    }
  }

  private renderOwner(a: Arcana): JSX.Element | null {
    const o = a.owner()
    if (!a.hasOwner() || !o) {
      return null
    }

    return (
      <small>
        / 主人：
        <a
          href="#"
          key={`${o.jobCode}.view`}
          onClick={this.openArcanaViewModal.bind(this, Arcana.forCode(o.jobCode))}
        >
          {o.name}
        </a>
      </small>
    )
  }

  private renderBuddy(a): JSX.Element | null {
    const b = a.buddy()
    if (!a.hasBuddy() || !b) {
      return null
    }

    return (
      <small>
        / バディ：
        <a
          href="#"
          key={`${b.jobCode}.view`}
          onClick={this.openArcanaViewModal.bind(this, Arcana.forCode(b.jobCode))}
        >
          {b.name}
        </a>
      </small>
    )
  }

  private renderArcanaType(a: Arcana): JSX.Element | null {
    let cl = ""
    let text = ""
    switch (a.arcanaType) {
      case "third":
        cl = "success"
        text = "新世代"
        break
      case "first":
        text = "旧世代"
        break
      case "collaboration":
        cl = "info"
        text = "コラボ"
        break
      case "collabo_newgene":
        cl = "info"
        text = "コラボ（新世代）"
        break
      case "demon":
        text = "魔神"
        break
      case "demon_newgene":
        text = "魔神（新世代）"
        break
    }

    if (_.isEmpty(text)) {
      return null
    }
    if (_.isEmpty(cl)) {
      cl = "default"
    }

    return (
      <div className="pull-right">
        <Label bsStyle={cl}>{text}</Label>
      </div>
    )
  }

  private renderNoramlDetail(a: Arcana): JSX.Element {
    return (
      <dl className="small arcana-view-detail">
        <dt>必殺技</dt>
        <dd>{this.renderSkill(a)}</dd>
        {this.renderInheritSkill(a)}
        {this.renderFirstAbility(a)}
        {this.renderSecondAbility(a)}
        {this.renderPartyAbility(a)}
        {this.renderExtraAbility(a)}
        {this.renderWeaponAbility(a)}
        {this.renderChainAbility(a)}
      </dl>
    )
  }

  private renderGunkiDetail(a: Arcana): JSX.Element {
    return (
      <dl className="small arcana-view-detail">
        {this.renderHeroicSkill(a)}
        {this.renderGunkiAbility(a)}
      </dl>
    )
  }

  private renderKessenDerail(a: Arcana): JSX.Element {
    return (
      <dl className="small arcana-view-detail">
        {this.renderDecisiveOrder(a)}
        {this.renderDecisiveSkill(a)}
        {this.renderPassiveAbility(a)}
      </dl>
    )
  }

  private renderArcanaDetail(a: Arcana): JSX.Element {
    if (!a.hasGunkiAbility() && !a.hasKessen()) {
      return this.renderNoramlDetail(a)
    }

    const small = [this.renderNoramlDetail(a)]
    const normal = [
      (
        <Tab eventKey="normal" key="normal" title="通常アビリティ" tabClassName="small">
          {this.renderNoramlDetail(a)}
        </Tab>
      )
    ]

    if (a.hasGunkiAbility()) {
      small.push(this.renderGunkiDetail(a))
      normal.push(
        <Tab eventKey="gunki" title="義勇軍記" tabClassName="small">
          {this.renderGunkiDetail(a)}
        </Tab>
      )
    }
    if (a.hasKessen()) {
      small.push(this.renderKessenDerail(a))
      normal.push(
        <Tab eventKey="kessen" title="決戦" tabClassName="small">
          {this.renderKessenDerail(a)}
        </Tab>
      )
    }

    return (
      <div>
        <div className="hidden-sm hidden-md hidden-lg">
          {small}
        </div>
        <div className="hidden-xs">
          <Tabs defaultActiveKey="normal" id="arcana-detail-tabs">
            {normal}
          </Tabs>
        </div>
      </div>
    )
  }

  private openArcanaViewModal(a: Arcana | null, e): void {
    e.preventDefault()
    MessageStream.arcanaViewStream.plug(Bacon.sequentially(50, [null, a]))
  }

  private renderArcanaView(): JSX.Element | null {
    const a = this.props.viewArcana
    if (!a) {
      return null
    }

    return (
      <Modal show={this.props.showModal} onHide={this.props.closeModal}>
        <Modal.Body>
          <button type="button" className="close" onClick={this.props.closeModal}>
            <span aria-hidden="true">&times; Close</span>
          </button>
          <br />
          <div className={`arcana ${a.jobClass}`}>
            <div className={`arcana-title ${a.jobClass}-title`}>
              {`${a.jobName} : ${a.rarityStars}`}
              <Badge pullRight={true}>{this.renderCost(a)}</Badge>
            </div>
            <div className="arcana-view-body">
              {this.renderArcanaType(a)}
              <h4 className="arcana-name">
                <span className="text-muted">{a.title}</span>
                <strong>{a.name}</strong>
                {this.renderOwner(a)}
                {this.renderBuddy(a)}
              </h4>
              <div className="row">
                <div className="col-xs-12 col-sm-12 col-md-12">
                  <p className="pull-left">
                    <Button
                      bsStyle="default"
                      bsSize="small"
                      onClick={this.props.openWikiModal}
                    >
                      <FontAwesomeIcon icon={faSearch} /> Wikiで確認
                    </Button>
                  </p>
                  <p className="pull-right">
                    <input
                      type="checkbox"
                      data-job-code={a.jobCode}
                      ref={(inp) => { this.addFavHandler(inp, a) }}
                    />
                  </p>
                </div>
                <div className="col-xs-12 col-sm-4 col-md-4">
                  <dl className="small arcana-view-detail">
                    <dt>職業</dt>
                    <dd>{a.jobDetail}</dd>
                    <dt>ATK / HP</dt>
                    <dd>
                      {`${a.maxAtkForView()} / ${a.maxHpForView()}`}
                      <br />
                      {`( ${a.limitAtkForView()} / ${a.limitHpForView()} )`}
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
                <div className="col-xs-12 col-sm-8 col-md-8">
                  {this.renderArcanaDetail(a)}
                </div>
              </div>
            </div>
          </div>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this.props.closeModal}>
            <FontAwesomeIcon icon={faTimes} /> 閉じる
          </Button>
        </Modal.Footer>
      </Modal>
    )
  }
}
