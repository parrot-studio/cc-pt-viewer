import * as _ from "lodash"
import Cookie from "../lib/Cookie"
import MessageStream from "../lib/MessageStream"

export interface FavoritesParams {
  [key: string]: boolean
}

export default class Favorites {
  public static init(list: string[]): void {
    let favs: FavoritesParams = {}
    try {
      favs = _.reduce(list, (f, c) => {
        f[c] = true
        return f
      }, {})
    } catch (e) {
      favs = {}
    }

    this._instance = new Favorites(favs)
  }

  public static stateFor(code: string): boolean {
    return this._instance.stateFor(code)
  }

  public static setState(code: string, state: boolean): void {
    this._instance.setState(code, state)
  }

  public static clear(): void {
    this._instance.clear()
  }

  public static codes(): string[] {
    return this._instance.codes()
  }

  private static readonly COOKIE_NAME: string = "fav-arcana"

  private static _instance: Favorites = new Favorites({})

  private _favorites: FavoritesParams

  private constructor(params: FavoritesParams) {
    this._favorites = params
  }

  private stateFor(code: string): boolean {
    if (!code) {
      return false
    }
    if (this._favorites[code]) {
      return true
    }
    return false
  }

  private setState(code: string, state: boolean): void {
    this._favorites[code] = state
    this.store()
    MessageStream.favoritesStream.push(this._favorites)
  }

  private codes(): string[] {
    return _.chain(this._favorites)
      .map((s, c) => {
        if (s) {
          return c
        }
        return ""
      }).compact().value().sort()
  }

  private clear(): void {
    this._favorites = {}
    Cookie.delete(Favorites.COOKIE_NAME)
    MessageStream.favoritesStream.push({})
  }

  private store(): void {
    const cs = this.codes()
    const co: { [key: string]: string } = {}
    co[Favorites.COOKIE_NAME] = cs.join("/")
    Cookie.set(co)
  }
}
