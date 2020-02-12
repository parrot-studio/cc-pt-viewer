import Skill from "../../model/Skill"
import SkillEffect from "../../model/SkillEffect"

describe("Skill", () => {
  const effect = new SkillEffect(1, "", "", [])

  describe("<<必殺技>>の基本情報", () => {
    const skillName = "グランドクロス"
    const skillCost = 2
    const effects = [effect]
    const skill = new Skill(skillName, skillCost, "", effects)

    it("「名称」を持つ", () => {
      expect(skill.name).toEqual(skillName)
    })
    it("「コスト」を持つ", () => {
      expect(skill.cost).toEqual(skillCost)
    })
  })

  describe("「発動条件」を持つことがある", () => {
    const skillName = "グランドクロス"
    const skillCost = 2
    const effects = [effect]

    it("「発動条件」が空である", () => {
      const cond = ""
      const skill = new Skill(skillName, skillCost, cond, effects)
      expect(skill.condition).toEqual(cond)
    })
    it("「発動条件」を持っている", () => {
      const cond = "マナ4個以下の時"
      const skill = new Skill(skillName, skillCost, cond, effects)
      expect(skill.condition).toEqual(cond)
    })
  })

  describe("<<必殺技効果>>は1個から複数存在する", () => {
    const skillName = "グランドクロス"
    const skillCost = 2
    const cond = ""

    it("<<必殺技効果>>は最低一つ必要", () => {
      expect(() => {
        // tslint:disable-next-line:no-unused-variable
        const skill = new Skill(skillName, skillCost, cond, [])
      }).toThrow()
    })
    it("<<必殺技効果>>は複数持つことができる", () => {
      const effect2 = new SkillEffect(2, "", "", [])
      const effects = [effect, effect2]
      const skill = new Skill(skillName, skillCost, cond, effects)

      expect(skill.effects.length).toBeGreaterThanOrEqual(1)
      expect(skill.effects.length).toEqual(effects.length)
    })
  })
})
