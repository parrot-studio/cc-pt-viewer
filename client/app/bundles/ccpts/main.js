import _ from 'lodash'
import fastclick from 'fastclick'

import React from 'react'
import ReactDOM from 'react-dom'

import Searcher from './lib/Searcher'
import AppView from './components/AppView'

$(() => {
  fastclick.attach(document.body)

  $(document).on('keypress', (e) => !(e.which === 13 || e.keyCode === 13))

  const appPath = $("#app-path").val()
  const aboutPath = $("#about-path").val()
  const ptm = $("#ptm").val() || ''
  const ptver = $("#pt-ver").val() || ''
  const dataver = $("#data-ver").val() || ''
  const infover = $("#info-ver").val() || ''
  const phoneDevice = (window.innerWidth < 768 ? true : false)
  const code = $("#code").val() || ''

  let mode = $("#mode").val()
  let originTitle = document.title

  if (_.eq(mode, 'ptedit') && phoneDevice && _.isEmpty(ptm)) {
    mode = 'database'
    originTitle = `データベースモード : ${originTitle}`
    document.title = originTitle
    history.replaceState('','',`db`)
  }

  if (phoneDevice) {
    $("#ads").hide()
  }

  if (_.isEmpty(mode)) {
    return
  }

  Searcher.init(dataver, appPath)

  ReactDOM.render(
    React.createElement(AppView,
      {
        mode,
        phoneDevice,
        appPath,
        aboutPath,
        ptm,
        ptver,
        infover,
        code,
        originTitle
      }),
    document.getElementById('app-view')
  )
})
