import _ from 'lodash'
import fastclick from 'fastclick'

import React from 'react'
import ReactDOM from 'react-dom'

import Searcher from './lib/Searcher'
import Conditions from './model/Conditions'
import AppView from './components/AppView'

$(() => {
  fastclick.attach(document.body)

  $(document).on('keypress', (e) => !(e.which === 13 || e.keyCode === 13))

  const mode = $("#mode").val()
  const appPath = $("#app-path").val()
  const aboutPath = $("#about-path").val()
  const ptm = $("#ptm").val() || ''
  const ptver = $("#pt-ver").val() || ''
  const dataver = $("#data-ver").val() || ''
  const phoneDevice = (window.innerWidth < 768 ? true : false)

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
          mode,
          phoneDevice,
          appPath,
          aboutPath,
          latestInfo: Conditions.latestInfo(),
          ptm,
          ptver
        }),
      document.getElementById('app-view')
    )
  })
})
