import SkillEffect from "../../model/SkillEffect"

describe("SkillEffect", () => {

  describe("<<必殺技効果>>の基本情報", () => {
    const order = 1
    const mainCategory = "attack"
    const subCategory = "range_line"
    const effect = new SkillEffect(order, mainCategory, subCategory, [])

    it("攻撃や回復などの「大カテゴリ」を持つ", () => {
      expect(effect.mainCategory).toEqual(mainCategory)
    })
    it("「大カテゴリ」はさらに詳細な「小カテゴリ」を持つ", () => {
      expect(effect.subCategory).toEqual(subCategory)
    })
    it("「発動順序」を持つ", () => {
      expect(effect.order).toEqual(order)
    })
  })

  describe("「付加効果」が存在することがある", () => {
    const order = 1
    const mainCategory = "attack"
    const subCategory = "range_line"

    it("「付加効果」が空のことがある", () => {
      const effect = new SkillEffect(order, mainCategory, subCategory, [])
      expect(effect.subEffects.length).toEqual(0)
    })
    it("「付加効果」は複数持てる", () => {
      const sub1 = "aup"
      const sub2 = "fire"
      const es = [sub1, sub2]
      const effect = new SkillEffect(order, mainCategory, subCategory, es)

      expect(effect.subEffects.length).toEqual(es.length)
      es.forEach((eff) => {
        expect(effect.subEffects).toContain(eff)
      })
    })
  })
})
