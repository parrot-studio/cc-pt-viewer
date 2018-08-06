import CookieBase from "./CookieBase"

export default class QueryLogCookie {
  public static set(data: any): void {
    CookieBase.set(QueryLogCookie.LOG_BASE_KEY, data)
  }

  public static get(): any {
    return CookieBase.get(QueryLogCookie.LOG_BASE_KEY)
  }

  public static clear(): void {
    CookieBase.clear(QueryLogCookie.LOG_BASE_KEY)
  }

  public static replace(data: any): void {
    CookieBase.replace(QueryLogCookie.LOG_BASE_KEY, data)
  }

  public static delete(key: string): void {
    CookieBase.delete(QueryLogCookie.LOG_BASE_KEY, key)
  }

  public static valueFor(key: string): any {
    return CookieBase.valueFor(QueryLogCookie.LOG_BASE_KEY, key)
  }

  private static readonly LOG_BASE_KEY = "ccpts_query_logs"
}
