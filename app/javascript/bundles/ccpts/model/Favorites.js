import _ from "lodash"
import { Cookie } from "../lib/Cookie"
import MessageStream from "./MessageStream"

const __favorites_COOKIE_NAME = "fav-arcana"
let __favorites = {}

export default class Favorites {

  static stateFor(code) {
    if (!code) {
      return false
    }
    if (__favorites[code]) {
      return true
    }
    return false
  }

  static setState(code, state) {
    __favorites[code] = state
    Favorites.store()
    MessageStream.favoritesStream.push(__favorites)
    return state
  }

  static list() {
    return _.chain(__favorites)
      .map((s, c) => {
        if (s) {
          return c
        }
        return ""
      }).compact().value().sort()
  }

  static clear() {
    __favorites = {}
    Cookie.delete(__favorites_COOKIE_NAME)
    MessageStream.favoritesStream.push(__favorites)
    return __favorites
  }

  static store() {
    const fl = Favorites.list()
    const co = {}
    co[__favorites_COOKIE_NAME] = fl.join("/")
    Cookie.set(co)
    return __favorites
  }

  static init() {
    __favorites = {}
    try {
      const list = Cookie.valueFor(__favorites_COOKIE_NAME)
      if (!list) {
        return __favorites
      }
      __favorites = _.reduce(list.split("/"), (f, c) => {
        f[c] = true
        return f
      }, {})
    } catch (e) {
      __favorites = {}
    }
  }
}
