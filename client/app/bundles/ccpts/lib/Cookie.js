import _ from 'lodash'
import Cookies from 'js-cookie'

const __cookie_EXPIRE_DATE = 60

class CookieBase {

  static set(base, data) {
    const d = _.merge(CookieBase.get(base), (data || {}))
    Cookies.set(base, d, {expires: __cookie_EXPIRE_DATE})
  }

  static get(base) {
    return (Cookies.getJSON(base) || {})
  }

  static clear(base) {
    Cookies.remove(base)
  }

  static replace(base, data) {
    Cookies.set(base, (data || {}), {expires: __cookie_EXPIRE_DATE})
  }

  static delete(base, key) {
    const c = CookieBase.get(base)
    delete c[key]
    CookieBase.replace(base, c)
  }

  static valueFor(base, key) {
    const c = CookieBase.get(base)
    return c[key]
  }
}

const __cookie_BASE_KEY = 'ccpts'

class Cookie {

  static set(data) {
    CookieBase.set(__cookie_BASE_KEY, data)
  }

  static get() {
    return CookieBase.get(__cookie_BASE_KEY)
  }

  static clear() {
    CookieBase.clear(__cookie_BASE_KEY)
  }

  static replace(data) {
    CookieBase.replace(__cookie_BASE_KEY, data)
  }

  static delete(key) {
    CookieBase.delete(__cookie_BASE_KEY, key)
  }

  static valueFor(key) {
    return CookieBase.valueFor(__cookie_BASE_KEY, key)
  }
}

const __cookie_LOG_KEY = 'ccpts_query_logs'

class QueryLogCookie {

  static set(data) {
    CookieBase.set(__cookie_LOG_KEY, data)
  }

  static get() {
    return CookieBase.get(__cookie_LOG_KEY)
  }

  static clear() {
    CookieBase.clear(__cookie_LOG_KEY)
  }

  static replace(data) {
    CookieBase.replace(__cookie_LOG_KEY, data)
  }

  static delete(key) {
    CookieBase.delete(__cookie_LOG_KEY, key)
  }

  static valueFor(key) {
    return CookieBase.valueFor(__cookie_LOG_KEY, key)
  }
}

export { Cookie, QueryLogCookie }
