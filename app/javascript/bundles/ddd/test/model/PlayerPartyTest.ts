import Arcana from "../../model/Arcana"
import Member from "../../model/Member"
import PlayerParty from "../../model/PlayerParty"

describe("PlayerParty", () => {
  const arcana = new Arcana("K01", 6)
  const otherArcana = new Arcana("K02", 4)
  const anotherArcana = new Arcana("K10", 20)

  describe("<<プレイヤーパーティー>>は<<メンバー>>を保持する「位置」を持つ", () => {
    it("6つの「位置」を持つ", () => {
      expect(PlayerParty.POSITIONS).toHaveLength(6)
      expect(PlayerParty.POSITIONS).toContain("mem1")
      expect(PlayerParty.POSITIONS).toContain("mem2")
      expect(PlayerParty.POSITIONS).toContain("mem3")
      expect(PlayerParty.POSITIONS).toContain("mem4")
      expect(PlayerParty.POSITIONS).toContain("sub1")
      expect(PlayerParty.POSITIONS).toContain("sub2")
    })

    it("「位置」と<<メンバー>>を指定して登録できる", () => {
      PlayerParty.POSITIONS.forEach((pos) => {
        const member = new Member(arcana, null)
        const playerParty = new PlayerParty()
        playerParty.addMember(pos, member)

        expect(playerParty.memberFor(pos)).toEqual(member)
      })
    })

    it("「位置」と「メインアルカナ」と「絆アルカナ」を指定して、メンバーを登録できる", () => {
      PlayerParty.POSITIONS.forEach((pos) => {
        const playerParty = new PlayerParty()
        playerParty.createMember(pos, arcana, otherArcana)

        const member = playerParty.memberFor(pos)
        expect(member).not.toBeNull()
        expect(member?.mainArcana).toEqual(arcana)
        expect(member?.chainArcana).toEqual(otherArcana)
      })
    })

    it("同じ「位置」に<<メンバー>>が再度追加された場合、追加された<<メンバー>>で上書きする", () => {
      const member = new Member(arcana, null)
      const otherMember = new Member(otherArcana, null)

      PlayerParty.POSITIONS.forEach((pos) => {
        const playerParty = new PlayerParty()
        playerParty.addMember(pos, member)
        playerParty.addMember(pos, otherMember)

        expect(playerParty.memberFor(pos)).toEqual(otherMember)
      })
    })

    it("各「位置」は<<メンバー>>が空でも許容される", () => {
      const playerParty = new PlayerParty()
      PlayerParty.POSITIONS.forEach((pos) => {
        expect(playerParty.memberFor(pos)).toBeNull()
      })
    })

    it("各「位置」に<<メンバー>>は削除することができ、その「位置」は空になる", () => {
      const member = new Member(arcana, null)

      PlayerParty.POSITIONS.forEach((pos) => {
        const playerParty = new PlayerParty()
        playerParty.addMember(pos, member)
        playerParty.removeMember(pos)

        expect(playerParty.memberFor(pos)).toBeNull()
      })
    })

    it("「位置」を指定して「絆アルカナ」を削除できる", () => {
      const playerParty = new PlayerParty()
      playerParty.createMember("mem1", arcana, otherArcana)
      playerParty.removeMemberChainArcana("mem1")

      const member = playerParty.memberFor("mem1")
      expect(member).not.toBeNull()
      expect(member?.mainArcana).toEqual(arcana)
      expect(member?.chainArcana).toBeNull()
    })
  })

  describe("<<プレイヤーパーティー>>の中で同一の<<アルカナ>>は一つしか存在できない", () => {
    describe("自身の「メインアルカナ」として持つ<<アルカナ>>を、「メインアルカナ」として持つ別な<<メンバー>>が追加された場合", () => {
      const mem1 = new Member(arcana, null)
      const mem2 = new Member(arcana, null)
      const mem3 = new Member(otherArcana, null)

      const playerParty = new PlayerParty()
      playerParty.addMember("mem2", mem2)
      playerParty.addMember("mem1", mem1)
      playerParty.addMember("mem3", mem3)

      it("最後に追加された<<メンバー>>が残り、他の<<メンバー>>は削除される", () => {
        expect(playerParty.memberFor("mem1")).not.toBeNull()
        expect(playerParty.memberFor("mem2")).toBeNull()
        expect(playerParty.memberFor("mem1")).toEqual(mem1)
        expect(playerParty.memberFor("mem3")).toEqual(mem3)
      })
    })

    describe("自身の「メインアルカナ」として持つ<<アルカナ>>を、「絆アルカナ」として持つ別な<<メンバー>>が追加された場合", () => {
      const mem1 = new Member(arcana, null)
      const mem3 = new Member(otherArcana, arcana)

      const playerParty = new PlayerParty()
      playerParty.addMember("mem1", mem1)
      playerParty.addMember("mem3", mem3)

      it("先に追加されていた<<メンバー>>が削除される", () => {
        expect(playerParty.memberFor("mem1")).toBeNull()
        expect(playerParty.memberFor("mem3")).toEqual(mem3)
      })
    })

    describe("自身の「絆アルカナ」として持つ<<アルカナ>>を、「メインアルカナ」として持つ別な<<メンバー>>が追加された場合", () => {
      const mem2 = new Member(arcana, otherArcana)
      const mem4 = new Member(otherArcana, null)

      const playerParty = new PlayerParty()
      playerParty.addMember("mem2", mem2)
      playerParty.addMember("mem4", mem4)

      it("先に追加されていた<<メンバー>>の「絆アルカナ」のみが削除される", () => {
        const afterMem2 = playerParty.memberFor("mem2")
        expect(afterMem2).not.toBeNull()
        expect(afterMem2?.mainArcana).toEqual(arcana)
        expect(afterMem2?.chainArcana).toBeNull()

        expect(playerParty.memberFor("mem4")).toEqual(mem4)
      })
    })

    describe("自身の「絆アルカナ」として持つ<<アルカナ>>を、「絆アルカナ」として持つ別な<<メンバー>>が追加された場合", () => {
      const sub1 = new Member(arcana, otherArcana)
      const sub2 = new Member(anotherArcana, otherArcana)

      const playerParty = new PlayerParty()
      playerParty.addMember("sub1", sub1)
      playerParty.addMember("sub2", sub2)

      it("先に追加されていた<<メンバー>>の「絆アルカナ」のみが削除される", () => {
        const afterSub1 = playerParty.memberFor("sub1")
        expect(afterSub1).not.toBeNull()
        expect(afterSub1?.mainArcana).toEqual(arcana)
        expect(afterSub1?.chainArcana).toBeNull()

        expect(playerParty.memberFor("sub2")).toEqual(sub2)
      })
    })
  })

  describe("<<プレイヤーパーティー>>は「コスト」を持つ", () => {
    it("「コスト」は各<<メンバー>>の「コスト」を合計したもの", () => {
      const mem1 = new Member(arcana, otherArcana)
      const mem4 = new Member(anotherArcana, null)
      const totalCost = mem1.cost + mem4.cost

      const playerParty = new PlayerParty()
      playerParty.addMember("mem1", mem1)
      playerParty.addMember("mem4", mem4)

      expect(playerParty.cost).toEqual(totalCost)
    })
  })

  describe("<<プレイヤーパーティー>>は自身を表す「コード」を持つ", () => {
    const mem1 = new Member(new Arcana("F10", 10), null)
    const mem2 = new Member(new Arcana("F11", 4), new Arcana("F12", 10))
    const mem3 = new Member(new Arcana("F13", 6), new Arcana("F14", 2))
    const mem4 = new Member(new Arcana("F20", 18), null)
    const sub1 = new Member(new Arcana("F21", 20), null)
    const sub2 = new Member(new Arcana("P100", 20), new Arcana("P200", 0))

    it("「コード」は各「位置」の順に<<メンバー>>の「コード」を並べたもの", () => {
      const playerParty = new PlayerParty()
      playerParty.addMember("mem1", mem1)
      playerParty.addMember("mem2", mem2)
      playerParty.addMember("mem3", mem3)
      playerParty.addMember("mem4", mem4)
      playerParty.addMember("sub1", sub1)
      playerParty.addMember("sub2", sub2)

      const expectCode = `${mem1.code}${mem2.code}${mem3.code}${mem4.code}${sub1.code}${sub2.code}`
      expect(playerParty.code).toEqual(expectCode)
    })

    it("<<メンバー>>が存在しない「位置」の「コード」はNNとなる", () => {
      const playerParty = new PlayerParty()
      playerParty.addMember("mem1", mem1)
      playerParty.addMember("mem2", mem2)
      playerParty.addMember("mem4", mem4)
      playerParty.addMember("sub2", sub2)

      const expectCode = `${mem1.code}${mem2.code}NN${mem4.code}NN${sub2.code}`
      expect(playerParty.code).toEqual(expectCode)
    })
  })
})
