import Arcana from "../../model/Arcana"
import Member from "../../model/Member"
import FrienfMember from "../../model/FriendMember"

describe("FriendMember", () => {
  const arcana = new Arcana("A01", 4)
  const chain = new Arcana("A02", 2)
  const member = new Member(arcana, chain)

  describe("<<フレンドメンバー>>は<<メンバー>>を持つ", () => {
    it("<<メンバー>>を一つ持つことができる", () => {
      const friend = new FrienfMember(member)
      expect(friend.member).toEqual(member)
    })

    it("<<メンバー>>が空も許される", () => {
      const friend = new FrienfMember(null)
      expect(friend.member).toBeNull()
    })
  })

  describe("<<フレンドメンバー>>は「コスト」を持つ", () => {
    it("「コスト」は<<メンバー>>の状態にかかわらず、常に0である", () => {
      const friend = new FrienfMember(member)
      expect(friend.cost).toEqual(0)
    })
  })

  describe("<<フレンドメンバー>>は自身を表す「コード」を持つ", () => {
    it("メンバーが存在する場合、メンバーの「コード」である", () => {
      const friend = new FrienfMember(member)
      expect(friend.code).toEqual(member.code)
    })

    it("メンバーが存在しない場合、NNである", () => {
      const friend = new FrienfMember(null)
      expect(friend.code).toEqual("NN")
    })
  })
})
