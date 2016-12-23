import _ from 'lodash'
import fastclick from 'fastclick'

import React from 'react'
import ReactDOM from 'react-dom'

import Searcher from './lib/Searcher'
import Conditions from './model/Conditions'
import AppView from './components/AppView'

$(() => {
  fastclick.attach(document.body)

  $(document).on('keypress', (e) => {
    return !(e.which === 13 || e.keyCode === 13)
  })

  let mode = $("#mode").val()
  let appPath = $("#app-path").val()
  let aboutPath = $("#about-path").val()
  let ptm = $("#ptm").val() || ''
  let ptver = $("#pt-ver").val() || ''
  let dataver = $("#data-ver").val() || ''
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

  Searcher.init(dataver, appPath)

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
