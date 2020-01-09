import Arcana from "../../model/Arcana"

describe("Arcana", () => {
  const arcanaCode = "F01"
  const cost = 4
  const arcana = new Arcana(arcanaCode, cost)

  describe("<<アルカナ>>は「アルカナコード」を持つ", () => {
    it("自身を特定する「アルカナコード」を必ず持っている", () => {
      expect(arcana.arcanaCode).toBe(arcanaCode)
    })

    it("「アルカナコード」が同じ<<アルカナ>>は等価である", () => {
      const otherArcana = new Arcana(arcanaCode, 1)

      expect(arcana.isEqual(otherArcana)).toBe(true)
    })
  })

  describe("<<アルカナ>>は「コスト」を持つ", () => {
    it("「コスト」は0以上である", () => {
      expect(arcana.cost).toBeGreaterThan(0)
      expect(arcana.cost).toBe(cost)
    })
  })
})
