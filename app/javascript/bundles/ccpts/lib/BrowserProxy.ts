// eslint-disable-next-line @typescript-eslint/no-explicit-any
declare let window: any

// NOTE: SSRするなら切り離す
import Browser from "../../browser"

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

  public static fadeIn(el: HTMLDivElement): void {
    if (!el) {
      return
    }
    el.classList.add("fadeIn")
    el.classList.remove("hide")
    el.style.display = ""
  }

  public static show(el: HTMLDivElement): void {
    if (!el) {
      return
    }
    el.classList.remove("hide")
    el.style.display = ""
  }

  public static hide(el: HTMLDivElement): void {
    if (!el) {
      return
    }
    el.classList.add("hide")
    el.classList.remove("fadeIn")
    el.style.display = ""
  }

  public static setDraggable(div: HTMLDivElement, code: string, memkey?: string | null): void {
    if (BrowserProxy.isWindowDefined) {
      Browser.setDraggable(div, code, memkey)
    }
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  public static addDropHandler(div: HTMLLIElement | HTMLDivElement | null, code: string, callback: (targetKey: string, drag: any) => void): void {
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

  public static addSwipeHandler(div: HTMLDivElement | null, callbackLeft: () => void, callbackRight: () => void): void {
    if (BrowserProxy.isWindowDefined && BrowserProxy.isPhoneDevice() && div) {
      Browser.addSwipeHandler(div, callbackLeft, callbackRight)
    }
  }

  // eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
  public static addSwitchHandler(div: HTMLDivElement, state: boolean, callback, params): void {
    if (BrowserProxy.isWindowDefined) {
      Browser.addSwitchHandler(div, state, callback, params)
    }
  }

  public static updateSwitchState(div: HTMLDivElement, state: boolean): void {
    if (BrowserProxy.isWindowDefined) {
      Browser.updateSwitchState(div, state)
    }
  }
}
