declare var window
declare var Browser

export default class BrowserProxy {

  public static isWindowDefined: boolean = (() => {
    if (typeof window === "undefined") {
      return false
    }
    if (typeof Browser === "undefined") {
      return false
    }
    return true
  })()

  public static thisPage(): string {
    if (BrowserProxy.isWindowDefined) {
      return Browser.thisPage()
    }
    return "/"
  }

  public static isPhoneDevice(): boolean {
    if (BrowserProxy.isWindowDefined) {
      return Browser.isPhoneDevice()
    }
    return false
  }

  public static confirm(mes: string): boolean {
    if (BrowserProxy.isWindowDefined) {
      return Browser.confirm(mes)
    }
    return true
  }

  public static alert(mes: string): void {
    if (BrowserProxy.isWindowDefined) {
      return Browser.alert(mes)
    }
  }

  public static changeTitle(title: string): void {
    if (BrowserProxy.isWindowDefined) {
      return Browser.changeTitle(title)
    }
  }

  public static changeUrl(url: string): void {
    if (BrowserProxy.isWindowDefined) {
      return Browser.changeUrl(url)
    }
  }

  public static fadeIn(el): void {
    if (!el) {
      return
    }
    el.classList.add("fadeIn")
    el.classList.remove("hide")
    el.style.display = ""
  }

  public static show(el): void {
    if (!el) {
      return
    }
    el.classList.remove("hide")
    el.style.display = ""
  }

  public static hide(el): void {
    if (!el) {
      return
    }
    el.classList.add("hide")
    el.classList.remove("fadeIn")
    el.style.display = ""
  }

  public static setDraggable(div, code: string, memkey?: string | null): void {
    if (BrowserProxy.isWindowDefined) {
      Browser.setDraggable(div, code, memkey)
    }
  }

  public static addDropHandler(div, code: string, callback): void {
    if (BrowserProxy.isWindowDefined) {
      Browser.addDropHandler(div, code, callback)
    }
  }

  public static csrfToken(): string {
    if (BrowserProxy.isWindowDefined) {
      return Browser.csrfToken()
    }
    return ""
  }

  public static addSwipeHandler(div, callbackLeft, callbackRight): void {
    if (BrowserProxy.isWindowDefined && BrowserProxy.isPhoneDevice()) {
      Browser.addSwipeHandler(div, callbackLeft, callbackRight)
    }
  }

  public static addSwitchHandler(div, state: boolean, callback, params): void {
    if (BrowserProxy.isWindowDefined) {
      Browser.addSwitchHandler(div, state, callback, params)
    }
  }
}
