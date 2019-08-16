import * as React from "react"
import * as ReactDOM from "react-dom"
import FastClick from "fastclick"

import AppView from "./ccpts/components/AppView"
import Browser from "./ccpts/lib/BrowserProxy"

declare var document
declare var window
declare var FastClick

document.addEventListener("DOMContentLoaded", () => {
  // init
  FastClick.attach(document.body)
  document.addEventListener("submit", (e) => e.preventDefault())

  if (window.innerWidth < 768) {
    Browser.hide(document.getElementById("ads"))
  }

  // create app
  const paramDiv = document.getElementById("app-params")
  const params = JSON.parse(paramDiv.getAttribute("data-params"))
  const app = (
    <AppView
      conditions={params.conditions}
      appPath={params.appPath}
      aboutPath={params.aboutPath}
      mode={params.mode}
      dataver={params.dataver}
      ptver={params.ptver}
      arcana={params.arcana}
      party={params.party}
      partyView={params.partyView}
      latestInfo={params.latestInfo}
      heroes={params.heroes}
      originTitle={params.originTitle}
      queryLogs={params.queryLogs}
      queryString={params.queryString}
      firstResults={params.firstResults}
      tutorial={params.tutorial}
      favorites={params.favorites}
      lastMembers={params.lastMembers}
      parties={params.parties}
    />
  )

  // append app
  Browser.hide(document.getElementById("ccpts-loading"))
  ReactDOM.render(app, document.getElementById("ccpts-app"))
})
