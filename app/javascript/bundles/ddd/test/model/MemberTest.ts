import Arcana from "../../model/Arcana"
import Member from "../../model/Member"

describe("Member", () => {
  const main = new Arcana("F02", 2)
  const chain = new Arcana("P01", 1)

  describe("<<メンバー>>は「メインアルカナ」と「絆アルカナ」で構成される", () => {
    it("「メインアルカナ」と「絆アルカナ」が存在する", () => {
      const member = new Member(main, chain)
      expect(member.mainArcana).toEqual(main)
      expect(member.chainArcana).toEqual(chain)
    })

    it("「メインアルカナ」は必須、「絆アルカナ」はなくても良い", () => {
      const member = new Member(main, null)
      expect(member.mainArcana).toEqual(main)
      expect(member.chainArcana).toBeNull()
    })
  })

  describe("<<メンバー>>は「コスト」を持つ", () => {
    it("「コスト」は「メインアルカナ」と「絆アルカナ」の合計", () => {
      const member = new Member(main, chain)
      expect(member.cost).toEqual(main.cost + chain.cost)
    })

    it("「絆アルカナ」が存在しなければ、「メインアルカナ」のみで計算", () => {
      const member = new Member(main, null)
      expect(member.cost).toEqual(main.cost)
    })
  })

  describe("<<メンバー>>は自身を表す「コード」を持つ", () => {
    it("「メインメンバー」の「アルカナコード」＋「絆アルカナ」の「アルカナコード」", () => {
      const member = new Member(main, chain)
      expect(member.code).toEqual(`${main.arcanaCode}${chain.arcanaCode}`)
    })

    it("「絆アルカナ」が存在しなければ、「絆アルカナ」のコードは「N」", () => {
      const member = new Member(main, null)
      expect(member.code).toEqual(`${main.arcanaCode}N`)
    })
  })
})
