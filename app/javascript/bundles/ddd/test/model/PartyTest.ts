import Arcana from "../../model/Arcana"
import Member from "../../model/Member"
import PlayerParty from "../../model/PlayerParty"
import Party from "../../model/Party"

describe("Party", () => {
  describe("<<パーティー>>は<<プレイヤーパーティー>>と<<フレンドメンバー>>で構成される", () => {
    it("<<プレイヤーパーティー>>の「位置」にfriendをあわせた、7つの「位置」を持つ", () => {
      expect(Party.POSITIONS).toHaveLength(7)
      expect(Party.POSITIONS).toContain("friend")
      PlayerParty.POSITIONS.forEach((pos) => {
        expect(Party.POSITIONS).toContain(pos)
      })
    })

    it("「位置」と<<メンバー>>を指定して登録できる", () => {
      const member = new Member(new Arcana("F100", 24), null)
      Party.POSITIONS.forEach((pos) => {
        const party = new Party()
        party.addMember(pos, member)

        expect(party.memberFor(pos)).toEqual(member)
      })
    })

    describe("「位置」と「メインアルカナ」と「絆アルカナ」を指定して、<<メンバー>>を登録できる", () => {
      const main = new Arcana("K10", 20)

      it("「位置」と「メインアルカナ」と「絆アルカナ」を指定する", () => {
        const chain = new Arcana("K11", 2)

        Party.POSITIONS.forEach((pos) => {
          const party = new Party()
          party.createMember(pos, main, chain)

          const member = party.memberFor(pos)
          expect(member).not.toBeNull()
          expect(member?.mainArcana).toEqual(main)
          expect(member?.chainArcana).toEqual(chain)
        })
      })

      it("「位置」と「メインアルカナ」を指定する", () => {
        Party.POSITIONS.forEach((pos) => {
          const party = new Party()
          party.createMember(pos, main, null)

          const member = party.memberFor(pos)
          expect(member).not.toBeNull()
          expect(member?.mainArcana).toEqual(main)
          expect(member?.chainArcana).toBeNull()
        })
      })
    })

    describe("「位置」を指定して<<メンバー>>や「絆アルカナ」を削除できる", () => {
      let party = new Party()

      beforeEach(() => {
        party = new Party()
        party.createMember("mem1", new Arcana("P01", 0), null)
        party.createMember("mem2", new Arcana("P02", 4), new Arcana("P03", 8))
        party.createMember("sub2", new Arcana("P05", 10), null)
        party.createMember("friend", new Arcana("P10", 8), new Arcana("P12", 12))
      })

      it("「位置」を指定して<<メンバー>>を削除できる", () => {
        party.removeMember("mem2")
        expect(party.memberFor("mem1")).not.toBeNull()
        expect(party.memberFor("mem2")).toBeNull()
        expect(party.memberFor("sub2")).not.toBeNull()
        expect(party.memberFor("friend")).not.toBeNull()

        party.removeMember("friend")
        expect(party.memberFor("mem1")).not.toBeNull()
        expect(party.memberFor("mem2")).toBeNull()
        expect(party.memberFor("sub2")).not.toBeNull()
        expect(party.memberFor("friend")).toBeNull()
      })

      it("「位置」を指定して「絆アルカナ」を削除できる", () => {
        party.removeMemberChainArcana("mem2")
        expect(party.memberFor("mem2")).not.toBeNull()
        expect(party.memberFor("mem2")?.chainArcana).toBeNull()

        party.removeMemberChainArcana("friend")
        expect(party.memberFor("friend")).not.toBeNull()
        expect(party.memberFor("friend")?.chainArcana).toBeNull()
      })
    })

    describe("<<フレンドメンバー>>を直接指定して操作できる", () => {
      const main = new Arcana("P10", 8)
      const chain = new Arcana("P12", 12)
      const member = new Member(main, chain)

      it("<<メンバー>>を<<フレンドメンバー>>として登録できる", () => {
        const party = new Party()
        party.addFriend(member)

        expect(party.friendMember.member).not.toBeNull()
        expect(party.friendMember.mainArcana).toEqual(main)
        expect(party.friendMember.chainArcana).toEqual(chain)
      })

      it("「メインアルカナ」と「絆アルカナ」を渡して<<フレンドメンバー>>として登録できる", () => {
        const party = new Party()
        party.createFriend(main, chain)

        expect(party.friendMember.member).not.toBeNull()
        expect(party.friendMember.mainArcana).toEqual(main)
        expect(party.friendMember.chainArcana).toEqual(chain)
      })

      it("<<フレンドメンバー>>を直接削除できる", () => {
        const party = new Party()
        party.addFriend(member)
        party.removeFriend()

        expect(party.friendMember.member).toBeNull()
        expect(party.friendMember.mainArcana).toBeNull()
        expect(party.friendMember.chainArcana).toBeNull()
      })

      it("<<フレンドメンバー>>の「絆アルカナ」を直接削除できる", () => {
        const party = new Party()
        party.addFriend(member)
        party.removeFriendChainArcana()

        expect(party.friendMember.member).not.toBeNull()
        expect(party.friendMember.mainArcana).toEqual(main)
        expect(party.friendMember.chainArcana).toBeNull()
      })
    })
  })

  describe("<<パーティー>>は「コスト」を持つ", () => {
    it("<<パーティー>>の「コスト」は<<プレイヤーパーティー>>のコストに等しい", () => {
      const party = new Party()
      party.createMember("mem1", new Arcana("P01", 0), null)
      party.createMember("mem2", new Arcana("P02", 4), new Arcana("P03", 8))
      party.createMember("sub2", new Arcana("P05", 10), null)
      party.createMember("friend", new Arcana("P10", 8), new Arcana("P12", 12))

      expect(party.cost).toEqual(party.playerParty.cost)
    })
  })

  describe("<<パーティー>>は自身を表す「コード」を持つ", () => {
    it("<<パーティー>>の「コード」は<<プレイヤーパーティー>>の「コード」と<<フレンドメンバー>>の「コード」を並べたもの", () => {
      const mem1 = new Member(new Arcana("F10", 10), null)
      const mem2 = new Member(new Arcana("F11", 4), new Arcana("F12", 10))
      const mem4 = new Member(new Arcana("F20", 18), null)
      const sub2 = new Member(new Arcana("P100", 20), new Arcana("P200", 0))

      const playerParty = new PlayerParty()
      playerParty.addMember("mem1", mem1)
      playerParty.addMember("mem2", mem2)
      playerParty.addMember("mem4", mem4)
      playerParty.addMember("sub2", sub2)

      const friend = new Member(new Arcana("A10", 6), null)

      const party = new Party()
      party.addMember("mem1", mem1)
      party.addMember("mem2", mem2)
      party.addMember("mem4", mem4)
      party.addMember("sub2", sub2)
      party.addFriend(friend)

      const expectCode = `${playerParty.code}${friend.code}`
      expect(party.code).toEqual(expectCode)
    })
  })

  describe("<<プレイヤーパーティー>>に存在する<<アルカナ>>も<<フレンドメンバー>>が保持できる", () => {
    const arcana1 = new Arcana("P10", 8)
    const arcana2 = new Arcana("P12", 12)
    const arcana3 = new Arcana("P24", 24)

    it("<<フレンドメンバー>>の「メインアルカナ」が<<プレイヤーパーティー>>に存在していても登録できる", () => {
      const party = new Party()
      party.createMember("mem1", arcana1, arcana2)
      party.createFriend(arcana2, arcana1)

      expect(party.memberFor("mem1")).not.toBeNull()
      expect(party.memberFor("mem1")?.mainArcana).toEqual(arcana1)
      expect(party.memberFor("mem1")?.chainArcana).toEqual(arcana2)
      expect(party.friendMember.mainArcana).toEqual(arcana2)
      expect(party.friendMember.chainArcana).toEqual(arcana1)
    })

    it("<<フレンドメンバー>>の「絆アルカナ」が<<プレイヤーパーティー>>に存在していても登録できる", () => {
      const party = new Party()
      party.createMember("mem1", arcana1, arcana2)
      party.createFriend(arcana3, arcana1)

      expect(party.memberFor("mem1")).not.toBeNull()
      expect(party.memberFor("mem1")?.mainArcana).toEqual(arcana1)
      expect(party.memberFor("mem1")?.chainArcana).toEqual(arcana2)
      expect(party.friendMember.mainArcana).toEqual(arcana3)
      expect(party.friendMember.chainArcana).toEqual(arcana1)
    })
  })
})
