import CookieBase from "./CookieBase"

export default class Cookie {
  public static set(data: any): void {
    CookieBase.set(Cookie.CCPTS_BASE_KEY, data)
  }

  public static get(): any {
    return CookieBase.get(Cookie.CCPTS_BASE_KEY)
  }

  public static clear(): void {
    CookieBase.clear(Cookie.CCPTS_BASE_KEY)
  }

  public static replace(data: any): void {
    CookieBase.replace(Cookie.CCPTS_BASE_KEY, data)
  }

  public static delete(key: string): void {
    CookieBase.delete(Cookie.CCPTS_BASE_KEY, key)
  }

  public static valueFor(key: string): any {
    return CookieBase.valueFor(Cookie.CCPTS_BASE_KEY, key)
  }

  private static readonly CCPTS_BASE_KEY = "ccpts"
}
