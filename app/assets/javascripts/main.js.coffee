$ ->
  FastClick.attach(document.body)

  $(document).on 'keypress', (e) -> !(e.which == 13 || e.keyCode == 13)

  mode = $("#mode").val()
  if _.isEmpty(mode)
    CommonView.init()
  else
    switch mode
      when 'ptedit'
        if CommonView.isPhoneDevice() && _.isEmpty($("#ptm").val())
          window.location.href = "#{$("#app-path").val()}db"
        else
          Conditions.init().onValue ->
            EditView.init()
      when 'database'
        Conditions.init().onValue ->
          DatabaseView.init()
