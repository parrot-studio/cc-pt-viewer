declare var window
declare var document
declare var history
declare var $

// ブラウザ代理オブジェクト（クライアント）
export default class Browser {
  public static thisPage(): string {
    return window.location.href
  }

  public static isPhoneDevice(): boolean {
    return (window.innerWidth < 768)
  }

  public static confirm(mes: string): boolean {
    return (window.confirm(mes))
  }

  public static alert(mes: string): void {
    return window.alert(mes)
  }

  public static changeTitle(title: string): void {
    document.title = title
  }

  public static changeUrl(url: string): void {
    history.replaceState("", "", url)
  }

  public static csrfToken(): string {
    return ($("meta[name=\"csrf-token\"]").attr("content") || "")
  }

  public static setDraggable(div: HTMLDivElement, code: string, memkey?: string | null): void {
    if (!div) {
      return
    }

    const d = $(div)
    d.attr("data-job-code", code)
    if (memkey) {
      d.attr("data-member-key", memkey)
    }
    d.draggable({
      containment: false,
      helper: "clone",
      opacity: 0.7,
      zIndex: 10000,
      start: () => {
        $("#search-area").addClass("hide")
        $("#help-area").removeClass("hide")
      },
      stop: () => {
        $("#search-area").removeClass("hide")
        $("#help-area").addClass("hide")
      }
    })
  }

  public static addDropHandler(div: HTMLDivElement, code: string, callback): void {
    if (!div) {
      return
    }

    $(div).droppable({
      drop: (e, ui) => {
        e.preventDefault()
        callback(code, ui.draggable)
      }
    })
  }

  public static addSwipeHandler(div: HTMLDivElement, callbackLeft, callbackRight): void {
    if (!div) {
      return
    }

    $(div).swipe({
      swipeLeft: ((e) => {
        e.preventDefault()
        callbackLeft()
      }),
      swipeRight: ((e) => {
        e.preventDefault()
        callbackRight()
      })
    })
  }

  public static addSwitchHandler(div: HTMLDivElement, state: boolean, callback, params: any): void {
    if (!div) {
      return
    }

    const base = {
      state,
      onSwitchChange: ((e, s) => {
        callback(s)
      })
    }

    $(div).bootstrapSwitch(Object.assign(base, (params || {})))
  }
}
