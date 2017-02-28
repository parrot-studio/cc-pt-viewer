import Bacon from 'baconjs'

const __queryStream = new Bacon.Bus()
const __conditionStream = new Bacon.Bus()
const __resultStream = new Bacon.Bus()
const __arcanaViewStream = new Bacon.Bus()
const __historyStream = new Bacon.Bus()
const __partyStream = new Bacon.Bus()
const __memberCodeStream = new Bacon.Bus()
const __favoritesStream = new Bacon.Bus()
const __partiesStream = new Bacon.Bus()
const __queryLogsStream = new Bacon.Bus()

__conditionStream.plug(__queryStream)

export default class MessageStream {
  static get queryStream() {
    return __queryStream
  }

  static get conditionStream() {
    return __conditionStream
  }

  static get resultStream() {
    return __resultStream
  }

  static get arcanaViewStream() {
    return __arcanaViewStream
  }

  static get historyStream() {
    return __historyStream
  }

  static get partyStream() {
    return __partyStream
  }

  static get memberCodeStream() {
    return __memberCodeStream
  }

  static get favoritesStream() {
    return __favoritesStream
  }

  static get partiesStream() {
    return __partiesStream
  }

  static get queryLogsStream() {
    return __queryLogsStream
  }
}
