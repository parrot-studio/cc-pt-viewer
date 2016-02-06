$(() => {
  $(document).on('keypress', (e) => {
    return !(e.which === 13 || e.keyCode === 13)
  })

  let mode = $("#mode").val()
  let appPath = $("#app-path").val()
  let aboutPath = $("#about-path").val()
  let ptm = $("#ptm").val() || ''
  let ptver = $("#pt-ver").val() || ''
  let phoneDevice = (window.innerWidth < 768 ? true : false)

  if ((mode === 'ptedit') && phoneDevice && _.isEmpty(ptm)) {
    window.location.href = `${appPath}db`
    return
  }

  if (phoneDevice) {
    $("#ads").hide()
  }

  if (_.isEmpty(mode)) {
    return
  }

  Conditions.init().onValue(() => {
    ReactDOM.render(
      React.createElement(AppView,
        {
          mode: mode,
          phoneDevice: phoneDevice,
          appPath: appPath,
          aboutPath: aboutPath,
          latestInfo: Conditions.latestInfo(),
          ptm: ptm,
          ptver: ptver
        }),
      document.getElementById('app-view')
    )
  })
})
