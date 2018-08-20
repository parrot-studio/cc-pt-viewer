import * as _ from "lodash"
import Cookie from "../lib/Cookie"
import MessageStream from "./MessageStream"

export interface FavoritesParams {
  [key: string]: boolean
}

export default class Favorites {
  public static stateFor(code: string): boolean {
    if (!code) {
      return false
    }
    if (Favorites.favorites[code]) {
      return true
    }
    return false
  }

  public static setState(code: string, state: boolean): boolean {
    Favorites.favorites[code] = state
    Favorites.store()
    MessageStream.favoritesStream.push(Favorites.favorites)
    return state
  }

  public static list(): string[] {
    return _.chain(Favorites.favorites)
      .map((s, c) => {
        if (s) {
          return c
        }
        return ""
      }).compact().value().sort()
  }

  public static clear(): FavoritesParams {
    Favorites.favorites = {}
    Cookie.delete(Favorites.COOKIE_NAME)
    MessageStream.favoritesStream.push(Favorites.favorites)
    return Favorites.favorites
  }

  public static store(): FavoritesParams {
    const fl = Favorites.list()
    const co: { [key: string]: string } = {}
    co[Favorites.COOKIE_NAME] = fl.join("/")
    Cookie.set(co)
    return Favorites.favorites
  }

  public static init(): void {
    Favorites.favorites = {}
    try {
      const list: string | null = Cookie.valueFor(Favorites.COOKIE_NAME)
      if (!list) {
        return
      }
      Favorites.favorites = _.reduce(list.split("/"), (f, c) => {
        f[c] = true
        return f
      }, Favorites.favorites)
    } catch (e) {
      Favorites.favorites = {}
    }
  }

  private static readonly COOKIE_NAME: string = "fav-arcana"

  private static favorites: FavoritesParams = {}
}
