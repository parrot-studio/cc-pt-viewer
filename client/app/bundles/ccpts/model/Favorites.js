import _ from 'lodash'
import Bacon from 'baconjs'
import { Cookie } from '../lib/Cookie'

const __favorites_COOKIE_NAME = 'fav-arcana'

let __favorites = {}
let __favorites_notifyStream = new Bacon.Bus()

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
    __favorites_notifyStream.push(__favorites)
    return state
  }

  static list() {
    return _.chain(__favorites)
      .map((s, c) => {
        if (s) {
          return c
        }
        return ''
      }).compact().value().sort()
  }

  static clear() {
    __favorites = {}
    Cookie.delete(__favorites_COOKIE_NAME)
    __favorites_notifyStream.push(__favorites)
    return __favorites
  }

  static store() {
    let fl = Favorites.list()
    let co = {}
    co[__favorites_COOKIE_NAME] = fl.join('/')
    Cookie.set(co)
    return __favorites
  }

  static init() {
    __favorites = {}
    try {
      let list = Cookie.valueFor(__favorites_COOKIE_NAME)
      if (!list){
        return __favorites
      }
      __favorites = _.reduce(list.split('/'), (f, c) => {
        f[c] = true
        return f
      }, {})
    } catch(e) {
      __favorites = {}
    }
  }
}

Favorites.notifyStream = __favorites_notifyStream
