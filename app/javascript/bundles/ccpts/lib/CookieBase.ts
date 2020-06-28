/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
/* eslint-disable @typescript-eslint/no-explicit-any */
import * as _ from "lodash"
import * as Cookies from "js-cookie"

export default class CookieBase {
  public static set(base: string, data: any): void {
    const d = _.merge(CookieBase.get(base), (data || {}))
    Cookies.set(base, d, { expires: CookieBase.EXPIRE_DATE })
  }

  public static get(base: string): any {
    return (Cookies.getJSON(base) || {})
  }

  public static clear(base: string): void {
    Cookies.remove(base)
  }

  public static replace(base: string, data: any): void {
    Cookies.set(base, (data || {}), { expires: CookieBase.EXPIRE_DATE })
  }

  public static delete(base: string, key: string): void {
    const c: any = CookieBase.get(base)
    delete c[key]
    CookieBase.replace(base, c)
  }

  public static valueFor(base: string, key: string): any {
    const c: any = CookieBase.get(base)
    return c[key]
  }

  private static readonly EXPIRE_DATE = 60
}
