// ブラウザ代理オブジェクト（クライアント）
Browser = {};

Browser.thisPage = function () {
  return window.location.href;
}

Browser.isPhoneDevice = function () {
  return (window.innerWidth < 768);
}

Browser.confirm = function (mes) {
  return (window.confirm(mes));
}

Browser.alert = function (mes) {
  window.alert(mes);
}

Browser.changeTitle = function (title) {
  document.title = title;
}

Browser.changeUrl = function (url) {
  history.replaceState("", "", url);
}

Browser.setDraggable = function (div, code, memkey) {
  if (!div) {
    return;
  }

  var d = $(div);
  d.attr("data-job-code", code);
  if (memkey) {
    d.attr("data-member-key", memkey);
  }
  d.draggable({
    containment: false,
    helper: "clone",
    opacity: 0.7,
    zIndex: 10000,
    start: () => {
      $("#search-area").addClass("hide");
      $("#help-area").removeClass("hide");
    },
    stop: () => {
      $("#search-area").removeClass("hide");
      $("#help-area").addClass("hide");
    }
  });
}

Browser.addDropHandler = function (div, code, callback) {
  if (!div) {
    return;
  }

  $(div).droppable({
    drop: (e, ui) => {
      e.preventDefault();
      callback(code, ui.draggable);
    }
  });
}

Browser.csrfToken = function () {
  return ($("meta[name=\"csrf-token\"]").attr("content") || "");
}

Browser.addSwipeHandler = function (div, callbackLeft, callbackRight) {
  if (!div) {
    return;
  }

  $(div).swipe({
    swipeLeft: (function (e) {
      e.preventDefault();
      callbackLeft();
    }),
    swipeRight: (function (e) {
      e.preventDefault();
      callbackRight();
    })
  });
}


Browser.addSwitchHandler = function (div, state, callback, params) {
  if (!div) {
    return
  }

  var base = {
    state: state,
    onSwitchChange: (function (e, s) {
      callback(s)
    })
  }

  $(div).bootstrapSwitch(Object.assign(base, (params || {})))
}
